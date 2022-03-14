package io.seunwater.seunswap.requests;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class UpdateTokenPriceRequest {

    private UUID walletId;

    private UUID walletTokenId;

    private int newPrice;

}
