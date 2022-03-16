package io.seunwater.openseun.model;

import io.seunwater.openseun.common.ProjectCategory;
import io.seunwater.openseun.common.ProjectStatus;
import io.seunwater.openseun.common.ProjectType;
import io.seunwater.openseun.common.WalletStatus;
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

    private UUID walletId;

    private String name;

    private String description;

    private String location;

    private Double estimatedReductions;

    private Double benefitsReceived;

    private ProjectCategory category;

    private ProjectType type;

    private ProjectStatus projectStatus;

    private WalletStatus walletStatus;

}
