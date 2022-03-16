package io.seunwater.openseun.responses;

import io.seunwater.openseun.common.BeneficiaryCategory;
import io.seunwater.openseun.common.WalletStatus;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.UUID;

@Data
@AllArgsConstructor
public class AddProjectBeneficiaryResponse {

    private UUID beneficiaryId;

    private BeneficiaryCategory category;

    private WalletStatus walletStatus;

}
