package io.seun.seunswap.responses;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigInteger;
import java.util.UUID;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ListTokenResponse {

    private UUID walletTokenId;

    private String tokenId;

    private BigInteger price;

}
