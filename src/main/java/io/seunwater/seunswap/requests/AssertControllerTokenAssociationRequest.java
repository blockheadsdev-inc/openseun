package io.seunwater.seunswap.requests;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class AssertControllerTokenAssociationRequest {

    private UUID walletId;

    private String tokenId;

}
