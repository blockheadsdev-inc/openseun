package io.seunwater.openseun.requests;

import io.seunwater.openseun.model.OffsetOption;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ChooseOffsetProjectRequest {

    private UUID investorId;

    private OffsetOption offsetOption;

}
