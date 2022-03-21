package io.seunwater.openseun.service;

import io.seunwater.openseun.common.WalletStatus;
import io.seunwater.openseun.model.Investor;
import io.seunwater.openseun.model.OffsetOption;
import io.seunwater.openseun.model.Project;
import io.seunwater.openseun.repository.InvestorRepository;
import io.seunwater.openseun.requests.AddInvestorRequest;
import io.seunwater.openseun.requests.ChooseOffsetProjectRequest;
import io.seunwater.openseun.requests.FetchInvestorInfoRequest;
import io.seunwater.openseun.requests.PurchaseCarbonCreditsRequest;
import io.seunwater.openseun.responses.AddInvestorResponse;
import io.seunwater.openseun.responses.FetchInvestorInfoResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class InvestorService {

    private final InvestorRepository investorRepository;

    private final ProjectService projectService;

    private final WalletService walletService;

    private final Double OFFSET_PRICE_USD = Double.valueOf(30);

    public AddInvestorResponse addInvestor(AddInvestorRequest request){

        Investor investor = new Investor(
                UUID.randomUUID(),
                null,
                request.getName(),
                request.getLocation(),
                0.0,
                request.getCategory(),
                WalletStatus.INACTIVE);

        investorRepository.save(investor);

        return new AddInvestorResponse(investor.getInvestorId(), investor.getName(), investor.getWalletStatus());

    }

    public FetchInvestorInfoResponse getInvestorInfo(FetchInvestorInfoRequest request){

        Investor investor = investorRepository.findById(request.getInvestorId()).get();

        return new FetchInvestorInfoResponse(
                investor.getInvestorId(),
                investor.getWalletId(),
                investor.getName(),
                investor.getLocation(),
                investor.getTotalInvestments(),
                investor.getCategory(),
                investor.getWalletStatus());
    }

    public List<Investor> fetchAllInvestors(){
        return investorRepository.findAll();
    }

    public Investor getInvestor(UUID investorId){
        return investorRepository.findById(investorId).get();
    }

    public void saveInvestor(Investor investor){
        investorRepository.save(investor);
    }

    public boolean validateInvestor(UUID investorId){
        return investorRepository.findById(investorId).isPresent();
    }


//    calculate offset
    public ArrayList<OffsetOption> purchaseCarbonCredits(PurchaseCarbonCreditsRequest request){

        Double price = OFFSET_PRICE_USD;

        List<Project> projects = projectService.fetchAllProjects();

        ArrayList<OffsetOption> offsetOptions = new ArrayList<>();

        for (Project project : projects){
            offsetOptions.add(new OffsetOption(project.getProjectId(), request.getOffset(),(request.getOffset()) * price));
        }

        return offsetOptions;

    }

    public void chooseOffsetOption(ChooseOffsetProjectRequest request){

        Investor investor = investorRepository.findById(request.getInvestorId()).get();

        Project project = projectService.getProject(request.getOffsetOption().getProjectId());



        investor.setTotalInvestments(investor.getTotalInvestments() + (request.getOffsetOption().getOffsetQuantity() * request.getOffsetOption().getOffsetPrice()));
        project.setBenefitsReceived(project.getBenefitsReceived() + (request.getOffsetOption().getOffsetQuantity() * request.getOffsetOption().getOffsetPrice()));

        walletService.generateCertificate(investor.getWalletId());

        walletService.transferBonds(investor.getWalletId(), project.getWalletId(), (long) (request.getOffsetOption().getOffsetQuantity() * request.getOffsetOption().getOffsetPrice()));

        projectService.saveProject(project);
        investorRepository.save(investor);

    }


}
