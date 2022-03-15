package io.seunwater.openseun.model;

import io.seunwater.openseun.common.InvestorCategory;
import io.seunwater.openseun.common.ProjectCategory;
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
public class Investor {

    @Id
    private UUID investorId;

    private UUID walletId;

    private String name;

    private String location;

    private BigDecimal totalInvestments;

    private InvestorCategory category;

}
