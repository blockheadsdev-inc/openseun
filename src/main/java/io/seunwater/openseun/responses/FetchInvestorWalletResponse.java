package io.seunwater.openseun.responses;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.UUID;

@Data
@AllArgsConstructor
public class FetchInvestorWalletResponse {

    private UUID investorId;

    private UUID walletId;

    private String walletName;

    private String publicKey;

}
