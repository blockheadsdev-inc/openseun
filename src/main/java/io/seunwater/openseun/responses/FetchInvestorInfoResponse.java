package io.seunwater.openseun.responses;

import io.seunwater.openseun.common.InvestorCategory;
import io.seunwater.openseun.common.WalletStatus;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.UUID;

@Data
@AllArgsConstructor
public class FetchInvestorInfoResponse {

    private UUID investorId;

    private UUID walletId;

    private String name;

    private String location;

    private Double totalInvestments;

    private InvestorCategory category;

    private WalletStatus walletStatus;

}
