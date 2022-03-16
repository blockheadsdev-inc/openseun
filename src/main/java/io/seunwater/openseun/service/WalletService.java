package io.seunwater.openseun.service;

import io.seunwater.openseun.common.WalletStatus;
import io.seunwater.openseun.model.Investor;
import io.seunwater.openseun.model.Project;
import io.seunwater.openseun.model.Wallet;
import io.seunwater.openseun.repository.WalletRepository;
import io.seunwater.openseun.requests.*;
import io.seunwater.openseun.responses.ConnectInvestorWalletResponse;
import io.seunwater.openseun.responses.ConnectProjectWalletResponse;
import io.seunwater.openseun.responses.FetchInvestorWalletResponse;
import io.seunwater.openseun.responses.FetchProjectWalletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class WalletService {

    private final WalletRepository walletRepository;
    private final InvestorService investorService;
    private final ProjectService projectService;

//    connect investor wallet
    public ConnectInvestorWalletResponse connectInvestorWallet(ConnectInvestorWalletRequest request){

        Wallet wallet = new Wallet(
                UUID.randomUUID(),
                request.getInvestorId(),
                request.getAccountId(),
                request.getPublicKey(),
                request.getPrivateKey(),
                request.getWalletName());

        walletRepository.save(wallet);

        Investor investor = investorService.getInvestor(request.getInvestorId());

        investor.setWalletId(wallet.getWalletId());
        investor.setWalletStatus(WalletStatus.ACTIVE);

        investorService.saveInvestor(investor);

        return new ConnectInvestorWalletResponse(wallet.getOwnerId(), wallet.getWalletId(), investor.getWalletStatus());
    }

//    disconnect investor wallet
    public void disconnectInvestorWallet(DisconnectInvestorWalletRequest request){
        Investor investor = investorService.getInvestor(request.getInvestorId());

        investor.setWalletId(null);
        investor.setWalletStatus(WalletStatus.INACTIVE);

        walletRepository.deleteById(request.getWalletId());

        investorService.saveInvestor(investor);

    }

//    connect project wallet
    public ConnectProjectWalletResponse connectProjectWallet(ConnectProjectWalletRequest request){

        Wallet wallet = new Wallet(
                UUID.randomUUID(),
                request.getProjectId(),
                request.getAccountId(),
                request.getPublicKey(),
                request.getPrivateKey(),
                request.getWalletName());

        walletRepository.save(wallet);

        Project project = projectService.getProject(request.getProjectId());

        project.setWalletId(wallet.getWalletId());
        project.setWalletStatus(WalletStatus.ACTIVE);

        projectService.saveProject(project);

        return new ConnectProjectWalletResponse(project.getProjectId(), project.getWalletId(), project.getWalletStatus());

    }

//    disconnect project wallet
    public void disconnectProjectWallet(DisconnectProjectWalletRequest request){

        Project project = projectService.getProject(request.getProjectId());

        project.setWalletId(null);
        project.setWalletStatus(WalletStatus.INACTIVE);

        walletRepository.deleteById(request.getWalletId());

        projectService.saveProject(project);

    }

//    fetch investor wallet
    public FetchInvestorWalletResponse fetchInvestorWallet(FetchInvestorWalletRequest request){
        if (investorService.validateInvestor(request.getInvestorId())) {
            Wallet wallet = walletRepository.findById(request.getWalletId()).get();
            return new FetchInvestorWalletResponse(wallet.getOwnerId(), wallet.getWalletId(), wallet.getWalletName(), wallet.getPublicKey());
        }
        return null;
    }

//    fetch investor wallets
    public FetchAllInvestorWalletsResponse fetchAllInvestorWallets(FetchAllInvestorWalletsRequest request){

        if (investorService.validateInvestor(request.getInvestorId())){

            List<Wallet> wallets = walletRepository.findByOwnerId(request.getInvestorId());

            ArrayList<FetchInvestorWalletResponse> walletList =  new ArrayList<>();

            for (Wallet wallet: wallets){
                walletList.add(new FetchInvestorWalletResponse(wallet.getOwnerId(), wallet.getWalletId(), wallet.getWalletName(), wallet.getPublicKey()));
            }

            return new FetchAllInvestorWalletsResponse(walletList);
        }

        return null;
    }

//    fetch project wallet
    public FetchProjectWalletResponse fetchProjectWallet(FetchProjectWalletRequest request){

        if (projectService.validateProject(request.getProjectId())){

            Wallet wallet = walletRepository.findById(request.getWalletId()).get();

            return new FetchProjectWalletResponse(request.getProjectId(), wallet.getWalletId(), wallet.getWalletName(), wallet.getPublicKey());
        }

        return null;
    }

//    fetch project wallets
    public ArrayList<FetchProjectWalletResponse> fetchAllProjectWallets(FetchAllProjectWalletsRequest request){
        if (projectService.validateProject(request.getProjectId())){

            List<Wallet> wallets = walletRepository.findByOwnerId(request.getProjectId());

            ArrayList<FetchProjectWalletResponse> walletList = new ArrayList<>();

            for (Wallet wallet : wallets){
                walletList.add(new FetchProjectWalletResponse(request.getProjectId(), wallet.getWalletId(), wallet.getWalletName(), wallet.getPublicKey()));
            }

            return walletList;

        }
        return null;
    }

//    credit wallet
    public void creditWallet(){}

//    charge wallet
    public void chargeWallet(){}


}
