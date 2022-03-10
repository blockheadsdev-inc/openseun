package io.seun.seunswap.model;

import io.seun.seunswap.security.FieldEncryptor;
import jakarta.persistence.Convert;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
public class Account {

    @Id
    private UUID walletId;

    private String accountId;

    private String publicKey;

    @Convert(converter = FieldEncryptor.class)
    private String privateKey;

    private String nickname;


}
