package io.seun.seunswap.requests;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class PurchaseTokenRequest {

    private UUID walletId;

    private UUID walletTokenId;

    private long quantity;

}
