package io.seunwater.seunswap.requests;

import com.hedera.hashgraph.sdk.PrivateKey;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CreateKeyStoreRequest {

    private String accountId;

    private String publicKey;

    private String privateKey;

    private String walletName;

}
