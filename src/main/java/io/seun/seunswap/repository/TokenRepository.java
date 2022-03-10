package io.seun.seunswap.repository;

import io.seun.seunswap.model.SeunSwapToken;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import javax.swing.text.html.Option;
import java.math.BigInteger;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface TokenRepository extends JpaRepository<SeunSwapToken, UUID> {

    List<SeunSwapToken> findByTokenId(String tokenId);

    List<SeunSwapToken> findByWalletId(String walletId);

    Optional<SeunSwapToken> findByPrice(BigInteger price);

}
