package io.seunwater.seunswap.model;

import io.seunwater.seunswap.security.FieldEncryptor;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.Convert;
import javax.persistence.Entity;
import javax.persistence.Id;
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
