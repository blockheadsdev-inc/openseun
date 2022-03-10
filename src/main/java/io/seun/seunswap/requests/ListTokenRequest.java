package io.seun.seunswap.requests;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ListTokenRequest {

    private UUID walletId;

    private String tokenId;

    private int amount;

    private long priceInTinyBars;

}
