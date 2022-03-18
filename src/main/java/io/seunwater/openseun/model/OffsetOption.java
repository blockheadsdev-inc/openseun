package io.seunwater.openseun.model;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.UUID;

@Data
@AllArgsConstructor
public class OffsetOption {

    private UUID projectId;

    private double offsetQuantity;

    private double offsetPrice;

}
