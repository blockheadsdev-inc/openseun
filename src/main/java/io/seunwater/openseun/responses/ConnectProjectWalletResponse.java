package io.seunwater.openseun.responses;

import io.seunwater.openseun.common.WalletStatus;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@AllArgsConstructor
public class ConnectProjectWalletResponse {

    private UUID projectId;

    private UUID walletId;

    private WalletStatus walletStatus;

}
