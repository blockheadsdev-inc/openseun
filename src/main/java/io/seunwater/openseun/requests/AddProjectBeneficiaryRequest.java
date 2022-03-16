package io.seunwater.openseun.requests;

import io.seunwater.openseun.common.BeneficiaryCategory;
import io.seunwater.openseun.common.InvestorCategory;
import io.seunwater.openseun.common.WalletStatus;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.UUID;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class AddProjectBeneficiaryRequest {


    private UUID projectId;

    private String name;

    private String location;

    private BeneficiaryCategory category;

}
