package io.seunwater.openseun.responses;

import io.seunwater.openseun.common.WalletStatus;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.UUID;

@Data
@AllArgsConstructor
public class AddInvestorResponse {

    private UUID investorId;

    private String name;

    private WalletStatus walletStatus;

}
