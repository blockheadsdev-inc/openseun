package io.seunwater.openseun.requests;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class EjectProjectBeneficiaryRequest {

    private UUID beneficiaryId;

    private UUID projectId;

}
