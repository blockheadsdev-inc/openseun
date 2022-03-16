package io.seunwater.openseun.responses;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

@Data
@AllArgsConstructor
public class FetchAllProjectWalletsResponse {

    private List<FetchProjectWalletResponse> projectWallets;
}
