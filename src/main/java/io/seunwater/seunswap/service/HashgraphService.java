package io.seunwater.seunswap.service;

import com.hedera.hashgraph.sdk.*;
import io.seunwater.seunswap.model.Account;
import io.seunwater.seunswap.model.SeunSwapToken;
import io.seunwater.seunswap.repository.AccountRepository;
import io.seunwater.seunswap.repository.TokenRepository;
import io.seunwater.seunswap.responses.CreateKeyStoreResponse;
import io.seunwater.seunswap.responses.FetchTokenBalanceResponse;
import io.seunwater.seunswap.responses.FetchTokenPriceResponse;
import io.seunwater.seunswap.responses.ListTokenResponse;
import lombok.RequiredArgsConstructor;
import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.math.BigInteger;
import java.util.List;
import java.util.UUID;

@Service
@Slf4j
@RequiredArgsConstructor
public class HashgraphService {

    private static String CONTROLLER_ID_Str = "0.0.30866177";

    private static String CONTROLLER_PRK_Str = "302e020100300506032b657004220420c0222d3b3af133714a7e8ef21ee730159589ef2ff9b8e86f01c939aecb0e7bfc";

    private static String CONTRACT_ID_Str = "0.0.33990706";

    private static String OPERATOR_ID_Str = "0.0.14410";

    private static String OPERATOR_PRK_Str = "302e020100300506032b657004220420c2b949ec8f503faaa1533e20d29378a67a0e35e46affef9d296a84354c299367";

    public static AccountId CONTROLLER_ID = AccountId.fromString(CONTROLLER_ID_Str);

    public static AccountId OPERATOR_ID = AccountId.fromString(OPERATOR_ID_Str);

    public static PrivateKey CONTROLLER_PRIVATE_KEY = PrivateKey.fromString(CONTROLLER_PRK_Str);

    public static PrivateKey OPERATOR_PRIVATE_KEY = PrivateKey.fromString(OPERATOR_PRK_Str);

    public static ContractId SEUN_SWAP_CONTRACT_ID = ContractId.fromString(CONTRACT_ID_Str);

    private final AccountRepository accountRepository;

    private final TokenRepository tokenRepository;


    public CreateKeyStoreResponse createKeyStore(String accountId, String publicKey, String privateKey, String nickname){

        Account account = accountRepository.save(new Account(UUID.randomUUID(), accountId, publicKey, privateKey, nickname));

        return new CreateKeyStoreResponse(account.getWalletId(), account.getNickname());

    }

    @Async
    @SneakyThrows
    public ListTokenResponse listToken(UUID walletId, String tokenId, BigInteger amount, Long priceInTinyBars){

        Account account = accountRepository.findById(walletId).get();

        List<SeunSwapToken> tokens = tokenRepository.findByTokenId(tokenId);

        Client client = Client.forTestnet().setOperator(
                AccountId.fromString(account.getAccountId()),
                PrivateKey.fromString(account.getPrivateKey()));

        if (tokens.size() == 1){

            SeunSwapToken token = tokens.get(0);
            
            token.setPrice(token.getPrice().add(BigInteger.valueOf(priceInTinyBars)).divide(BigInteger.TWO));
            
            token.setBalance(BigInteger.valueOf(priceInTinyBars));

            changeTokenPrice(token.getWalletTokenId(), token.getPrice());

            Status status = new ContractExecuteTransaction()
                    .setGas(2_000_000)
                    .setContractId(SEUN_SWAP_CONTRACT_ID)
                    .setFunction(
                            "listToken",
                            new ContractFunctionParameters()
                                    .addAddress(TokenId.fromString(tokenId).toSolidityAddress())
                                    .addUint256(amount)
                                    .addUint256(BigInteger.valueOf(priceInTinyBars.intValue()))
                    )
                    .freezeWith(client)
                    .signWithOperator(client)
                    .execute(client)
                    .getReceipt(client)
                    .status;

            if (status.equals(Status.SUCCESS)){
                
                log.info("List Token Tx status :: " + status);
                
                tokenRepository.save(token);
            
                return new ListTokenResponse(token.getWalletTokenId(), token.getTokenId(), token.getPrice());
            
            }
            
        }
        
//        associate controller with token
        associateWithToken(tokenId);

//        transfer Tokens to controller
        sellToken(walletId, tokenId, amount);

        String name = queryTokenInfo(TokenId.fromString(tokenId));

//        list token
        Status status = new ContractExecuteTransaction()
                .setGas(2_000_000)
                .setContractId(SEUN_SWAP_CONTRACT_ID)
                .setFunction(
                        "listToken",
                        new ContractFunctionParameters()
                                .addAddress(TokenId.fromString(tokenId).toSolidityAddress())
                                .addUint256(amount)
                                .addUint256(BigInteger.valueOf(priceInTinyBars.intValue()))
                )
                .freezeWith(client)
                .signWithOperator(client)
                .execute(client)
                .getReceipt(client)
                .status;


        if (status.equals(Status.SUCCESS)){

            log.info("List Token Tx status :: " + status);

            SeunSwapToken token = tokenRepository
                    .save(
                            new SeunSwapToken(
                                    UUID.randomUUID(),
                                    account.getWalletId(),
                                    tokenId,
                                    name,
                                    Hbar
                                            .fromTinybars(priceInTinyBars)
                                            .getValue()
                                            .toBigInteger(),
                                    amount));

            return new ListTokenResponse(token.getWalletTokenId(), token.getTokenId(), token.getPrice());

        }


        return null;

    }

//    execute tokenPurchase contract function
    @Async
    @SneakyThrows
    public void sellToken(UUID walletId, UUID walletTokenId, BigInteger amount){

        Account account = accountRepository.findById(walletId).get();
        SeunSwapToken token = tokenRepository.findById(walletTokenId).get();

        Hbar amount_payable = Hbar.from(amount.longValue(), HbarUnit.TINYBAR);

        Client client = Client.forTestnet().setOperator(
                AccountId.fromString(account.getAccountId()),
                PrivateKey.fromString(account.getPrivateKey()));

        System.out.println("Payable :: " + amount_payable );

        Status status = new TransferTransaction()
                .addHbarTransfer(CONTROLLER_ID, amount_payable.negated())
                .addHbarTransfer(AccountId.fromString(account.getAccountId()), amount_payable)
                .addTokenTransfer(TokenId.fromString(token.getTokenId()), AccountId.fromString(account.getAccountId()), (-1 * amount.longValue()))
                .addTokenTransfer(TokenId.fromString(token.getTokenId()), CONTROLLER_ID,amount.longValue())
                .execute(client)
                .getReceipt(client)
                .status;

        token.setBalance(token.getBalance().add(amount));

        tokenRepository.save(token);


        log.info("Token Purchase Tx status :: " + status);

    }

    //    execute tokenPurchase contract function
    @Async
    @SneakyThrows
    public void sellToken(UUID walletId, String tokenId, BigInteger amount){

        Account account = accountRepository.findById(walletId).get();

        Client client = Client.forTestnet().setOperator(
                AccountId.fromString(account.getAccountId()),
                PrivateKey.fromString(account.getPrivateKey()));

        Hbar amount_payable = Hbar.from(amount.longValue(), HbarUnit.TINYBAR);

        Status status = new TransferTransaction()
                .addHbarTransfer(CONTROLLER_ID, amount_payable.negated())
                .addHbarTransfer(AccountId.fromString(account.getAccountId()), amount_payable)
                .addTokenTransfer(TokenId.fromString(tokenId), AccountId.fromString(account.getAccountId()), (-1 * amount.longValue()))
                .addTokenTransfer(TokenId.fromString(tokenId), CONTROLLER_ID, amount.longValue())
                .execute(client)
                .getReceipt(client)
                .status;

        log.info("Token Purchase Tx status :: " + status);

    }

//    execute tokenSale contract function
    @Async
    @SneakyThrows
    public void purchaseToken(UUID walletId, UUID walletTokenId, Long quantity){

        Account account = accountRepository.findById(walletId).get();
        SeunSwapToken token = tokenRepository.findById(walletTokenId).get();

        Client controller_client = Client
                .forTestnet()
                .setOperator(CONTROLLER_ID, CONTROLLER_PRIVATE_KEY);

        Client client = Client.forTestnet().setOperator(AccountId.fromString(account.getAccountId()), PrivateKey.fromString(account.getPrivateKey()));

        Hbar amount_payable = Hbar.from(token.getPrice().intValueExact() * quantity, HbarUnit.TINYBAR);

        System.out.println("Payable :: " + amount_payable);
        System.out.println("Payable neg :: " + amount_payable.negated());
        System.out.println("Quant  :: " + quantity);
        System.out.println("Quant neg :: " + (-1 * quantity));

        Status status = new TransferTransaction()
                .addHbarTransfer(CONTROLLER_ID, amount_payable)
                .addHbarTransfer(AccountId.fromString(account.getAccountId()), amount_payable.negated())
                .addTokenTransfer(TokenId.fromString(token.getTokenId()), AccountId.fromString(account.getAccountId()),quantity)
                .addTokenTransfer(TokenId.fromString(token.getTokenId()), CONTROLLER_ID,(-1 * quantity))
                .signWithOperator(controller_client)
                .signWithOperator(client)
                .execute(controller_client)
                .getReceipt(controller_client).status;

        log.info("Token Purchase Tx status :: " + status);

        if (status.equals(Status.SUCCESS)){
            token.setBalance(token.getBalance().subtract(BigInteger.valueOf(quantity.intValue())));
            tokenRepository.save(token);
        }

    }

    @Async
    @SneakyThrows
    public boolean changeTokenPrice(UUID walletTokenId, BigInteger newPrice){

        SeunSwapToken token = tokenRepository.findById(walletTokenId).get();

        Client client = Client.forTestnet().setOperator(CONTROLLER_ID, CONTROLLER_PRIVATE_KEY);

        Status status = new ContractExecuteTransaction()
                .setGas(2_000_000)
                .setContractId(SEUN_SWAP_CONTRACT_ID)
                .setFunction(
                        "updateTokenPrice",
                        new ContractFunctionParameters()
                                .addAddress(TokenId.fromString(token.getTokenId()).toSolidityAddress())
                                .addUint256(newPrice))
                .freezeWith(client)
                .sign(CONTROLLER_PRIVATE_KEY)
                .execute(client)
                .getReceipt(client)
                .status;

        if (status.equals(Status.SUCCESS)){
            token.setPrice(newPrice);
            tokenRepository.save(token);

            return true;
        }

        return false;
    }

    @Async
    @SneakyThrows
    public FetchTokenPriceResponse fetchTokenPrice(UUID walletTokenId) {

        Client client = Client.forTestnet().setOperator(CONTROLLER_ID, CONTROLLER_PRIVATE_KEY);

        SeunSwapToken token = tokenRepository.findById(walletTokenId).get();

        BigInteger tokenPrice = new ContractCallQuery()
                .setContractId(SEUN_SWAP_CONTRACT_ID)
                .setGas(1_000_000)
                .setFunction(
                        "getTokenPrice",
                        new ContractFunctionParameters()
                                .addAddress(TokenId.fromString(token.getTokenId()).toSolidityAddress()))
                .setMaxQueryPayment(new Hbar(2))
                .execute(client)
                .getUint256(0);

        tokenRepository.save(token);

        return new FetchTokenPriceResponse(token.getTokenId(), tokenPrice);

    }

    @Async
    @SneakyThrows
    public FetchTokenBalanceResponse fetchTokenBalance(UUID walletTokenId) {

        Client client = Client.forTestnet().setOperator(CONTROLLER_ID, CONTROLLER_PRIVATE_KEY);

        SeunSwapToken token = tokenRepository.findById(walletTokenId).get();



        tokenRepository.save(token);

        return new FetchTokenBalanceResponse(token.getTokenId(), token.getBalance());

    }

    @Async
    @SneakyThrows
    public boolean isControllerAssociatedWithToken(String tokenId) {

        Client client = Client.forTestnet().setOperator(CONTROLLER_ID, CONTROLLER_PRIVATE_KEY);

        return new ContractCallQuery()
                .setContractId(SEUN_SWAP_CONTRACT_ID)
                .setGas(1_000_000)
                .setFunction(
                        "isAssociatedWithToken",
                        new ContractFunctionParameters()
                                .addAddress(TokenId.fromString(tokenId).toSolidityAddress()))
                .setMaxQueryPayment(new Hbar(2))
                .execute(client)
                .getBool(0);

    }

    @Async
    @SneakyThrows
    private void associateWithToken(String tokenId){

        Client client = Client.forTestnet().setOperator(CONTROLLER_ID, CONTROLLER_PRIVATE_KEY);

        Status associationContractExecStatus = new ContractExecuteTransaction()
                .setContractId(SEUN_SWAP_CONTRACT_ID)
                .setGas(2_000_000)
                .setFunction(
                        "associateControllerWithToken",
                        new ContractFunctionParameters()
                                .addAddress(TokenId.fromString(tokenId).toSolidityAddress()))
                .freezeWith(client)
                .sign(CONTROLLER_PRIVATE_KEY)
                .execute(client)
                .getReceipt(client)
                .status;

        log.info("SeunSwap Association Tx status :: " + associationContractExecStatus);


    }

    public boolean verifyWalletId(UUID walletId){
        return accountRepository.findById(walletId).isPresent();
    }

    public List<SeunSwapToken> getListedTokens(){

        for (SeunSwapToken tk : tokenRepository.findAll()){
            if (tk.getTokenName() == null ||  tk.getTokenName().equals("")){
                tk.setTokenName(queryTokenInfo(TokenId.fromString(tk.getTokenId())));
            }
            tokenRepository.save(tk);
        }

        return tokenRepository.findAll();

    }

    public void deleteListedToken(UUID walletTokenId){
        tokenRepository.deleteById(walletTokenId);
    }

    @Async
    @SneakyThrows
    public String queryTokenInfo(TokenId tokenId){

        Client client = Client.forTestnet().setOperator(OPERATOR_ID, OPERATOR_PRIVATE_KEY);

        return new TokenInfoQuery()
                .setTokenId(tokenId)
                .setMaxQueryPayment(new Hbar(2))
                .execute(client)
                .name;

    }

}
