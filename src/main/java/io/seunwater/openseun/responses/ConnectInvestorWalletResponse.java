package io.seunwater.openseun.responses;

import io.seunwater.openseun.common.WalletStatus;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@AllArgsConstructor
public class ConnectInvestorWalletResponse {

    private UUID investorId;

    private UUID walletId;

    private WalletStatus walletStatus;

}
