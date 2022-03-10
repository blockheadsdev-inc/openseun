package io.seun.seunswap.responses;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigInteger;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class FetchTokenPriceResponse {

    private String tokenId;

    private BigInteger price;

}
