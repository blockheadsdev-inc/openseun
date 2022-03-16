package io.seunwater.openseun.service;

import io.seunwater.openseun.model.Investor;
import io.seunwater.openseun.repository.InvestorRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
@RequiredArgsConstructor
public class InvestorService {

    private final InvestorRepository investorRepository;

    public Investor getInvestor(UUID investorId){
        return investorRepository.findById(investorId).get();
    }

    public void saveInvestor(Investor investor){
        investorRepository.save(investor);
    }

    public boolean validateInvestor(UUID investorId){
        return investorRepository.findById(investorId).isPresent();
    }
}
