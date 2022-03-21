package io.seunwater.openseun.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.hedera.hashgraph.sdk.*;
import io.seunwater.openseun.metadata.CertificateMetadata;
import io.seunwater.openseun.metadata.Localization;
import lombok.RequiredArgsConstructor;
import lombok.SneakyThrows;
import org.springframework.stereotype.Service;

import java.math.BigInteger;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Arrays;

@Service
@RequiredArgsConstructor
public class HashgraphService {


//    Assuming the investor already has purchased H20B on SEUNswap,
//    they can proceed to offset their carbon footprint
//    by purchasing carbon credits.
//    A carbon credit purchase generates a certificate
//    that is accredited to the investor.
//    Technically, they transfer their H20B to OpenSEUN
//    in exchange for the certificate.
//    This transfer incurs tx fees which OpenSEUN takes commission.
//    The Investor first enters the offset-quantity.
//    OpenSEUN calculates the quantity of H20B required
//    to match the offset for each project.
//    The Investor selects what project to invest in.
//    OpenSeun charges equivalent H20B from the Investor
//    to the Smart Contract.
//    The certificate is generated and transferred to the Investor
//    The H20B is transferred to the project account,
//    and can be swapped for Hbar on SEUNswap.

//    Derived Hedera Transactions (will be handled in smart contract where applicable)...
//
//    Associate Project Account with H20B
//    Create Certificate NFT
//    Transfer Certificate to Contract
//    Transfer H20B from Investor to Project
//    Transfer Certificate NFT to Investor

    private final AccountId OPERATOR_ID = AccountId.fromString("0.0.14410");
    private final TokenId H20B_ID = TokenId.fromString("0.0.30861311");
    private final ContractId SEUN_SWAP_CONTRACT_ID = ContractId.fromString("0.0.30897088");
    private final String CERTIFICATE_IMAGE_URL = "";


    @SneakyThrows
    public void associateProjectWithBond(AccountId accountId, PublicKey key, PrivateKey pk){


        Client projectClient = Client.forTestnet().setOperator(accountId, pk);

        ArrayList<TokenId> tokenIds = new ArrayList<>();

        tokenIds.add(H20B_ID);

        TransactionReceipt receipt = new TokenAssociateTransaction()
                .setTokenIds(tokenIds)
                .setAccountId(accountId)
                .freezeWith(projectClient)
                .execute(projectClient)
                .getReceipt(projectClient);

        System.out.println("Bond Association Tx :: " + receipt.status);

    }

    @SneakyThrows
    public void generateCertificateNFT(AccountId investorId, PrivateKey pk, PublicKey key) throws JsonProcessingException {

        Client investorClient = Client.forTestnet().setOperator(investorId, pk);

        TokenId bondId = H20B_ID;

        ArrayList<CustomFee> fees = new ArrayList<>();

        ArrayList<byte[]> metadataList = new ArrayList<>();

        CertificateMetadata certificateMetadata = new CertificateMetadata();

        certificateMetadata.setVersion("0.0.1");
        certificateMetadata.setName("OpenSEUN H20B Certificate");
        certificateMetadata.setDescription("Certificate awarded to " + investorId + " for the purchase of Carbon Credits on OpenSEUN.");
        certificateMetadata.setImage(CERTIFICATE_IMAGE_URL);
        certificateMetadata.setLocalization(new Localization("en"));

        ObjectMapper objectMapper = new ObjectMapper();

        byte[] cert_bytes = objectMapper.writeValueAsString(certificateMetadata).getBytes(StandardCharsets.UTF_8);

        if (cert_bytes.length > 50){
            int splits = cert_bytes.length/50;

            System.out.println("Number of splits :: " + splits);

            for(int x = 0; x < splits; x++){
                metadataList.add(Arrays.copyOfRange(cert_bytes, x * (cert_bytes.length/splits), (x + 1) * (cert_bytes.length/splits)));
            }
        }

        System.out.println("Certificate Bytes :: " + Arrays.toString(cert_bytes) + " with length :: " + cert_bytes.length);

        fees.add(new CustomFixedFee()
                .setAmount(30)
                .setDenominatingTokenId(bondId)
                .setFeeCollectorAccountId(OPERATOR_ID));


        TokenId tokenId = new TokenCreateTransaction()
                .setTokenName("OpenSEUN BOND CERTIFICATE")
                .setTokenSymbol("OSEUNCERT")
                .setSupplyKey(key)
                .setTreasuryAccountId(investorId)
                .setCustomFees(fees)
                .setTokenType(TokenType.NON_FUNGIBLE_UNIQUE)
                .execute(investorClient)
                .getReceipt(investorClient)
                .tokenId;

        System.out.println("Token Id :: " +tokenId);

        TransactionReceipt receipt = new TokenMintTransaction()
                .setMetadata(metadataList)
                .setTokenId(tokenId)
                .setMaxTransactionFee(new Hbar(2))
                .execute(investorClient)
                .getReceipt(investorClient);

        System.out.println("Token Mint Tx status :: " + receipt.status);

    }

    @SneakyThrows
    public void transferBondFromInvestorToProject(
            AccountId investorId,
            PrivateKey investor_pk,
            AccountId projectId,
            PrivateKey project_pk,
            long amount
            ){

        Client investorClient = Client.forTestnet().setOperator(investorId, investor_pk);
        Client projectClient = Client.forTestnet().setOperator(projectId, project_pk);

        BigInteger tokenPrice = new ContractCallQuery()
                .setContractId(SEUN_SWAP_CONTRACT_ID)
                .setGas(1_000_000)
                .setFunction(
                        "getTokenPrice",
                        new ContractFunctionParameters()
                                .addAddress(H20B_ID.toSolidityAddress()))
                .setMaxQueryPayment(new Hbar(2))
                .execute(investorClient)
                .getUint256(0);

        long transfer_value = tokenPrice.longValue() * amount;

        Status status = new TransferTransaction()
                .addTokenTransfer(H20B_ID, investorId, (-1 * amount))
                .addTokenTransfer(H20B_ID, projectId, (1 * amount))
                .addHbarTransfer(investorId, Hbar.fromTinybars(-1 * transfer_value))
                .addHbarTransfer(projectId, Hbar.fromTinybars(transfer_value))
                .signWithOperator(investorClient)
                .signWithOperator(projectClient)
                .execute(investorClient)
                .getReceipt(investorClient).status;

        System.out.println("H20B Payment Status :: " + status);

    }


}
