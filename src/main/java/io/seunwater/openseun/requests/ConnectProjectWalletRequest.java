package io.seunwater.openseun.requests;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ConnectProjectWalletRequest {

    private UUID projectId;

    private String accountId;

    private String publicKey;

    private String privateKey;

    private String walletName;

}
