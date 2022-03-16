package io.seunwater.openseun.requests;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class DisconnectProjectWalletRequest {

    private UUID projectId;

    private UUID walletId;

}
