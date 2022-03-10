package io.seun.seunswap.service;

import com.hedera.hashgraph.sdk.*;
import io.github.cdimascio.dotenv.Dotenv;
import io.seun.seunswap.model.Account;
import io.seun.seunswap.model.SeunSwapToken;
import io.seun.seunswap.repository.AccountRepository;
import io.seun.seunswap.repository.TokenRepository;
import io.seun.seunswap.responses.CreateKeyStoreResponse;
import io.seun.seunswap.responses.FetchTokenBalanceResponse;
import io.seun.seunswap.responses.FetchTokenPriceResponse;
import io.seun.seunswap.responses.ListTokenResponse;
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

    public static AccountId CONTROLLER_ID = AccountId.fromString(Dotenv.load().get("CONTROLLER_ID"));
    public static PublicKey CONTROLLER_PUBLIC_KEY = PublicKey.fromString(Dotenv.load().get("CONTROLLER_PUBLIC_KEY"));
    public static PrivateKey CONTROLLER_PRIVATE_KEY = PrivateKey.fromString(Dotenv.load().get("CONTROLLER_PRIVATE_KEY"));

    public static ContractId SEUN_SWAP_CONTRACT_ID = ContractId.fromString(Dotenv.load().get("SEUN_SWAP_CONTRACT_ID"));

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

        Client client = Client.forTestnet().setOperator(
                AccountId.fromString(account.getAccountId()),
                PrivateKey.fromString(account.getPrivateKey()));

        Status status = new ContractExecuteTransaction()
                .setGas(2_000_000)
                .setContractId(SEUN_SWAP_CONTRACT_ID)
                .setFunction(
                        "tokenPurchase",
                        new ContractFunctionParameters()
                                .addAddress(TokenId.fromString(token.getTokenId()).toSolidityAddress())
                                .addInt64(amount.longValue()))
                .freezeWith(client)
                .sign(PrivateKey.fromString(account.getPrivateKey()))
                .execute(client)
                .getReceipt(client)
                .status;

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

        Status status = new ContractExecuteTransaction()
                .setGas(2_000_000)
                .setContractId(SEUN_SWAP_CONTRACT_ID)
                .setFunction(
                        "tokenPurchase",
                        new ContractFunctionParameters()
                                .addAddress(TokenId.fromString(tokenId).toSolidityAddress())
                                .addInt64(amount.longValue()))
                .freezeWith(client)
                .sign(PrivateKey.fromString(account.getPrivateKey()))
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

        Hbar amount_payable = Hbar.from(token.getPrice().intValueExact() * quantity, HbarUnit.TINYBAR);

        Status status = new ContractExecuteTransaction()
                .setGas(2_000_000)
                .setContractId(SEUN_SWAP_CONTRACT_ID)
                .setFunction(
                        "tokenSale",
                        new ContractFunctionParameters()
                                .addAddress(TokenId.fromString(token.getTokenId()).toSolidityAddress())
                                .addInt64(quantity))
                .setPayableAmount(amount_payable)
                .freezeWith(controller_client)
                .sign(CONTROLLER_PRIVATE_KEY)
                .execute(controller_client)
                .getReceipt(controller_client)
                .status;

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

        token.setPrice(tokenPrice);

        tokenRepository.save(token);

        return new FetchTokenPriceResponse(token.getTokenId(), tokenPrice);

    }

    @Async
    @SneakyThrows
    public FetchTokenBalanceResponse fetchTokenBalance(UUID walletTokenId) {

        Client client = Client.forTestnet().setOperator(CONTROLLER_ID, CONTROLLER_PRIVATE_KEY);

        SeunSwapToken token = tokenRepository.findById(walletTokenId).get();

        BigInteger tokenBalance = new ContractCallQuery()
                .setContractId(SEUN_SWAP_CONTRACT_ID)
                .setGas(1_000_000)
                .setFunction(
                        "getTokenBalance",
                        new ContractFunctionParameters()
                                .addAddress(TokenId.fromString(token.getTokenId()).toSolidityAddress()))
                .setMaxQueryPayment(new Hbar(2))
                .execute(client)
                .getUint256(0);

        token.setBalance(tokenBalance);

        tokenRepository.save(token);

        return new FetchTokenBalanceResponse(token.getTokenId(), tokenBalance);

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
        return tokenRepository.findAll();
    }

    public void deleteListedToken(UUID walletTokenId){
        tokenRepository.deleteById(walletTokenId);
    }

}
