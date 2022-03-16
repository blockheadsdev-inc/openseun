package io.seunwater.openseun.repository;

import io.seunwater.openseun.model.ProjectBeneficiary;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface BeneficiaryRepository extends JpaRepository<ProjectBeneficiary, UUID> {

    List<ProjectBeneficiary> findByProjectId(UUID projectId);

}
