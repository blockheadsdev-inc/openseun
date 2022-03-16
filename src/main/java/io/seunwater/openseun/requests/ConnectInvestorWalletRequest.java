package io.seunwater.openseun.requests;

import io.seunwater.openseun.common.WalletHolderType;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ConnectInvestorWalletRequest {

    private UUID investorId;

    private String accountId;

    private String publicKey;

    private String privateKey;

    private String walletName;

}
