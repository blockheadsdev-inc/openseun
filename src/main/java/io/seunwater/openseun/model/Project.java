package io.seunwater.openseun.model;

import io.seunwater.openseun.common.ProjectCategory;
import io.seunwater.openseun.common.ProjectType;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.Entity;
import javax.persistence.Id;
import java.math.BigDecimal;
import java.util.UUID;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
public class Project {

    @Id
    private UUID projectId;

    private String name;

    private String location;

    private BigDecimal estimatedReductions;

    private ProjectCategory category;

    private ProjectType type;

}
