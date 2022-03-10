package io.seun.seunswap.requests;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigInteger;
import java.util.UUID;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class SellTokenRequest {

    private UUID walletId;

    private UUID walletTokenId;

    private int amount;

}
