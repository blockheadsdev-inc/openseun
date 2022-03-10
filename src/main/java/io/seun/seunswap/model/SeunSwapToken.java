package io.seun.seunswap.model;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigInteger;
import java.util.UUID;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
public class SeunSwapToken {

    @Id
    private UUID walletTokenId;

    private UUID walletId;

    private String tokenId;

    private BigInteger price;

    private BigInteger balance;

}
