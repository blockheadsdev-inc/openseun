package io.seunwater.openseun.service;

import io.seunwater.openseun.common.WalletStatus;
import io.seunwater.openseun.model.ProjectBeneficiary;
import io.seunwater.openseun.repository.BeneficiaryRepository;
import io.seunwater.openseun.requests.AddProjectBeneficiaryRequest;
import io.seunwater.openseun.requests.EjectProjectBeneficiaryRequest;
import io.seunwater.openseun.requests.FetchBeneficiaryProjectsRequest;
import io.seunwater.openseun.requests.FetchProjectBeneficiariesRequest;
import io.seunwater.openseun.responses.AddProjectBeneficiaryResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class BeneficiaryService {

    private final BeneficiaryRepository beneficiaryRepository;
    private final HashgraphService hashgraphService;

//    add project beneficiary
    public AddProjectBeneficiaryResponse addProjectBeneficiary(AddProjectBeneficiaryRequest request){

//        ProjectBeneficiary projectBeneficiary = new ProjectBeneficiary(
//                request.getProjectId(),
//                UUID.randomUUID(),
//                null,
//                request.getName(),
//                request.getLocation(),
//                BigDecimal.ZERO,
//                request.getCategory(),
//                WalletStatus.INACTIVE);
//
//        ProjectBeneficiary newProjectBeneficiary = beneficiaryRepository.save(projectBeneficiary);
//
//        return new AddProjectBeneficiaryResponse(
//                newProjectBeneficiary.getBeneficiaryId(),
//                newProjectBeneficiary.getCategory(),
//                newProjectBeneficiary.getWalletStatus());
        return null;

    }

//    eject project beneficiary
    public void ejectProjectBeneficiary(EjectProjectBeneficiaryRequest request){

        beneficiaryRepository.deleteById(request.getBeneficiaryId());

    }

//    get project beneficiaries
    public List<ProjectBeneficiary> getProjectBeneficiaries(FetchProjectBeneficiariesRequest request){

        return beneficiaryRepository.findByProjectId(request.getProjectId());

    }

//    TODO: get beneficiary's projects
    public void getBeneficiaryProjects(FetchBeneficiaryProjectsRequest request){

    }

//    TODO : credit project beneficiary
    public void creditBeneficiary(UUID beneficiaryId, long amount){}

}
