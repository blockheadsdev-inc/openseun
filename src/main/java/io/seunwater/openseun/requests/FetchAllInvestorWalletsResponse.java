package io.seunwater.openseun.requests;

import io.seunwater.openseun.responses.FetchInvestorWalletResponse;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

@Data
@AllArgsConstructor
public class FetchAllInvestorWalletsResponse {

    private List<FetchInvestorWalletResponse> investorWallets;

}
