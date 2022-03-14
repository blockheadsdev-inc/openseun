package io.seunwater.seunswap.controller;

import io.seun.seunswap.requests.*;
import io.seunwater.seunswap.responses.CreateKeyStoreResponse;
import io.seunwater.seunswap.responses.FetchTokenBalanceResponse;
import io.seunwater.seunswap.responses.FetchTokenPriceResponse;
import io.seunwater.seunswap.responses.ListTokenResponse;
import io.seunwater.seunswap.service.HashgraphService;
import io.seunwater.seunswap.requests.*;
import io.swagger.v3.oas.annotations.Operation;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigInteger;

@RestController
@RequestMapping("/seunswap/testnet")
@RequiredArgsConstructor
public class SwapController {

    private final HashgraphService hashgraphService;

//    create account keystore
    @Operation(summary = "Use this endpoint to create a keystore wallet.")
    @PostMapping("/createKeyStore")
    public ResponseEntity<CreateKeyStoreResponse> createKeyStore(@RequestBody CreateKeyStoreRequest request){

        CreateKeyStoreResponse response = hashgraphService.createKeyStore(request.getAccountId(), request.getPublicKey(), request.getPrivateKey(), request.getWalletName());

        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(response);
    }

//    list token
    @Operation(summary = "Use this endpoint to add a fungible token to the SEUNswap Exchange.")
    @PostMapping("/listToken")
    public ResponseEntity<?> listToken(@RequestBody ListTokenRequest request){

        if (hashgraphService.verifyWalletId(request.getWalletId())){

            ListTokenResponse listTokenResponse = hashgraphService.listToken(request.getWalletId(), request.getTokenId(), BigInteger.valueOf(request.getAmount()), request.getPriceInTinyBars());

            return ResponseEntity.status(HttpStatus.ACCEPTED).body(listTokenResponse);

        }

        return ResponseEntity.status(HttpStatus.ACCEPTED).body("Request Rejected");

    }

//    sell token
    @Operation(summary = "Use this endpoint to exchange a token for hbar.")
    @PostMapping("/sellToken")
    public ResponseEntity<String> sellToken(@RequestBody SellTokenRequest request){

        if (hashgraphService.verifyWalletId(request.getWalletId())) {

            hashgraphService.sellToken(request.getWalletId(), request.getWalletTokenId(), BigInteger.valueOf(request.getAmount()));

            return ResponseEntity.status(HttpStatus.ACCEPTED).body("Request Accepted");

        }

        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Request Rejected");

    }

//    purchase token
    @Operation(summary = "Use this endpoint to exchange hbar for the provided token.")
    @PostMapping("/purchaseToken")
    public ResponseEntity<String> purchaseToken(@RequestBody PurchaseTokenRequest request){

        if (hashgraphService.verifyWalletId(request.getWalletId())){

            hashgraphService.purchaseToken(request.getWalletId(), request.getWalletTokenId(), request.getQuantity());

            return ResponseEntity.status(HttpStatus.ACCEPTED).body("Request Accepted");
        }

        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Request Rejected");

    }

//    change listed token price
    @Operation(summary = "Use this endpoint to update the price of a Listed Token.")
    @PostMapping("/updateTokenPrice")
    public ResponseEntity<String> updateTokenPrice(@RequestBody UpdateTokenPriceRequest request){

        if (hashgraphService.verifyWalletId(request.getWalletId())){

            hashgraphService.changeTokenPrice(request.getWalletTokenId(), BigInteger.valueOf(request.getNewPrice()));

            return ResponseEntity.status(HttpStatus.ACCEPTED).body("Request Accepted");

        }

        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Request Rejected");

    }

//    get listed token price
    @Operation(summary = "Use this endpoint to query the Listed Token's price.")
    @GetMapping("/fetchTokenPrice")
    public ResponseEntity<?> getTokenPrice(@RequestBody FetchTokenPriceRequest request){

        if (hashgraphService.verifyWalletId(request.getWalletId())){

            FetchTokenPriceResponse price = hashgraphService.fetchTokenPrice(request.getWalletTokenId());

            return ResponseEntity.status(HttpStatus.ACCEPTED).body(price);

        }

        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Request Rejected");

    }

//    get controller token balance
    @Operation(summary = "Use this endpoint to query the smart contract's token balance.")
    @GetMapping("/fetchTokenBalance")
    public ResponseEntity<?> getTokenBalance(@RequestBody FetchTokenBalanceRequest request){

        if (hashgraphService.verifyWalletId(request.getWalletId())){

            FetchTokenBalanceResponse balance = hashgraphService.fetchTokenBalance(request.getWalletTokenId());

            return ResponseEntity.status(HttpStatus.ACCEPTED).body(balance);

        }

        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Request Rejected");

    }

    @Operation(summary = "Use this endpoint to fetch all the Tokens Listed on SEUNswap.")
    @GetMapping("/fetchListedTokens")
    public ResponseEntity<?> getListedTokens(){

        return ResponseEntity
                .status(HttpStatus.OK)
                .body(
                        hashgraphService
                                .getListedTokens());

    }

    @Operation(summary = "Use this endpoint to delete a Token Listed on SEUNswap.", hidden = true)
    @DeleteMapping("/deleteListedToken")
    public ResponseEntity<?> deleteListedToken(@RequestBody DeleteListedTokenRequest request){

        hashgraphService.deleteListedToken(request.getWalletTokenId());

        return ResponseEntity
                .status(HttpStatus.OK)
                .body("Token Deleted!");

    }

}
