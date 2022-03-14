package io.seunwater.seunswap.responses;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigInteger;
import java.util.UUID;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class FetchTokenBalanceResponse {

    private String tokenId;

    private BigInteger balance;

}
