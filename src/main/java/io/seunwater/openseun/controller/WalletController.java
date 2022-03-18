package io.seunwater.openseun.controller;

import io.seunwater.openseun.requests.ConnectInvestorWalletRequest;
import io.seunwater.openseun.requests.ConnectProjectWalletRequest;
import io.seunwater.openseun.requests.FetchInvestorWalletRequest;
import io.seunwater.openseun.requests.FetchProjectWalletRequest;
import io.seunwater.openseun.responses.ConnectInvestorWalletResponse;
import io.seunwater.openseun.responses.ConnectProjectWalletResponse;
import io.seunwater.openseun.responses.FetchInvestorWalletResponse;
import io.seunwater.openseun.responses.FetchProjectWalletResponse;
import io.seunwater.openseun.service.WalletService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/openseun/testnet/wallet")
@RequiredArgsConstructor
@Tag(name = "Wallet API", description = "Use this endpoint to access wallet functionality.")
public class WalletController {

    private final WalletService walletService;

//    connect investor wallet
    @PostMapping("/createInvestorKeyStore")
    @Operation(summary = "Use this endpoint to create an investor's hedera wallet")
    public ResponseEntity<ConnectInvestorWalletResponse> connectInvestorWallet(ConnectInvestorWalletRequest request){
        ConnectInvestorWalletResponse response = walletService.connectInvestorWallet(request);

        return ResponseEntity.status(HttpStatus.OK).body(response);
    }

//    connect project wallet
    @PostMapping("/createProjectKeyStore")
    @Operation(summary = "Use this endpoint to create a project's hedera wallet")
    public ResponseEntity<ConnectProjectWalletResponse> connectProjectWallet(ConnectProjectWalletRequest request){

        return ResponseEntity.status(HttpStatus.OK).body(walletService.connectProjectWallet(request));
    }

//    fetch investor wallet
    @GetMapping("/fetchInvestorWallet")
    @Operation(summary = "Use this endpoint to query an investor's hedera wallet")
    public ResponseEntity<FetchInvestorWalletResponse> fetchInvestorWallet(FetchInvestorWalletRequest request){
        return ResponseEntity.status(HttpStatus.OK).body(walletService.fetchInvestorWallet(request));
    }

//    fetch project wallet
    @GetMapping("/fetchProjectWallet")
    @Operation(summary = "Use this endpoint to query a project's hedera wallet")
    public ResponseEntity<FetchProjectWalletResponse> fetchProjectWallet(FetchProjectWalletRequest request){
        return ResponseEntity.status(HttpStatus.OK).body(walletService.fetchProjectWallet(request));
    }


}
