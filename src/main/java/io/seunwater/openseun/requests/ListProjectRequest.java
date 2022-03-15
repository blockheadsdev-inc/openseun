package io.seunwater.openseun.requests;

import io.seunwater.openseun.common.ProjectCategory;
import io.seunwater.openseun.common.ProjectType;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ListProjectRequest {

    private String name;

    private String description;

    private String location;

    private BigDecimal estimatedReductions;

    private ProjectCategory category;

    private ProjectType type;

}
