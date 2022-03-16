package io.seunwater.openseun.controller;

import io.seunwater.openseun.service.WalletService;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/openseun/testnet/wallet")
@RequiredArgsConstructor
@Tag(name = "Wallet API", description = "Use this endpoint to access wallet functionality.")
public class WalletController {

    private final WalletService walletService;

//    connect investor wallet
//    connect project wallet

//    fetch investor wallet
//    fetch investor wallets

//    fetch project wallet
//    fetch project wallets

//    credit wallet

}
