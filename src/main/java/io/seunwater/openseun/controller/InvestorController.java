package io.seunwater.openseun.controller;

import io.seunwater.openseun.model.Investor;
import io.seunwater.openseun.model.OffsetOption;
import io.seunwater.openseun.requests.AddInvestorRequest;
import io.seunwater.openseun.requests.ChooseOffsetProjectRequest;
import io.seunwater.openseun.requests.FetchInvestorInfoRequest;
import io.seunwater.openseun.requests.PurchaseCarbonCreditsRequest;
import io.seunwater.openseun.responses.AddInvestorResponse;
import io.seunwater.openseun.responses.FetchInvestorInfoResponse;
import io.seunwater.openseun.service.InvestorService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/openseun/testnet/investor")
@RequiredArgsConstructor
@Tag(name = "Investor API", description = "Use this endpoint to access investor functionality.")
public class InvestorController {

    private final InvestorService investorService;

//    Add investor
    @PostMapping("/addInvestor")
    @Operation(summary = "Use this endpoint to add a New Investor.")
    public ResponseEntity<AddInvestorResponse> addInvestor(@RequestBody AddInvestorRequest request){
        return ResponseEntity.status(HttpStatus.OK).body(investorService.addInvestor(request));
    }

    @GetMapping("/fetchInvestorInfo")
    @Operation(summary = "Use this endpoint to query Investor Information.")
    public ResponseEntity<FetchInvestorInfoResponse> getInvestorInfo(FetchInvestorInfoRequest request){
        return ResponseEntity.status(HttpStatus.OK).body(investorService.getInvestorInfo(request));
    }

    @GetMapping("/fetchAllInvestors")
    @Operation(hidden = true, summary = "Use this endpoint to fetch Investor Data.")
    public ResponseEntity<List<Investor>> getAllInvestors(){
        return ResponseEntity.status(HttpStatus.OK).body(investorService.fetchAllInvestors());
    }


    @PostMapping("/purchaseCarbonCredits")
    @Operation(summary = "Use this endpoint to start the carbon credit purchase process.")
    public ResponseEntity<ArrayList<OffsetOption>> purchaseCarbonCredits(PurchaseCarbonCreditsRequest request){
        return ResponseEntity.status(HttpStatus.OK).body(investorService.purchaseCarbonCredits(request));
    }

    @PostMapping("/chooseOffsetOption")
    @Operation(summary = "Use this endpoint to complete the carbon credit purchase process.")
    public ResponseEntity<String> chooseOffsetOption(ChooseOffsetProjectRequest request){

        investorService.chooseOffsetOption(request);

        return ResponseEntity.status(HttpStatus.OK).body("Request Accepted");
    }

}
