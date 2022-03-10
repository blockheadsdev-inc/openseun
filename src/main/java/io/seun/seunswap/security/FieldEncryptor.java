package io.seun.seunswap.security;

import io.github.cdimascio.dotenv.Dotenv;
import jakarta.persistence.AttributeConverter;
import lombok.SneakyThrows;
import org.springframework.stereotype.Component;

import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.security.Key;
import java.util.Base64;

@Component
public class FieldEncryptor implements AttributeConverter<String, String> {

    private final String ENCRYPTION_ALGORITHM = Dotenv.load().get("ALGORITHM");
    private final String ENCRYPTION_KEY = Dotenv.load().get("SECRET");

    private final Key key;

    private final Cipher cipher;

    @SneakyThrows
    public FieldEncryptor() {
        key = new SecretKeySpec(ENCRYPTION_KEY.getBytes(StandardCharsets.UTF_8), ENCRYPTION_ALGORITHM);
        cipher = Cipher.getInstance(ENCRYPTION_ALGORITHM);
    }

    @SneakyThrows
    @Override
    public String convertToDatabaseColumn(String field) {
        cipher.init(Cipher.ENCRYPT_MODE, key);
        return Base64.getEncoder().encodeToString(cipher.doFinal(field.getBytes(StandardCharsets.UTF_8)));
    }

    @SneakyThrows
    @Override
    public String convertToEntityAttribute(String databaseData) {
        cipher.init(Cipher.DECRYPT_MODE, key);
        return new String(cipher.doFinal(Base64.getDecoder().decode(databaseData)));
    }

}
