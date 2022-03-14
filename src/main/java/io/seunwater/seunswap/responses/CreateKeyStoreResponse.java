package io.seunwater.seunswap.responses;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CreateKeyStoreResponse {

    @JsonProperty("walletId")
    private UUID walletId;

    @JsonProperty("walletName")
    private String walletName;

}
