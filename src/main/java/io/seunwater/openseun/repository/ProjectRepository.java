package io.seunwater.openseun.repository;

import io.seunwater.openseun.common.ProjectStatus;
import io.seunwater.openseun.model.Project;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface ProjectRepository extends JpaRepository<Project, UUID> {

    List<Project> findByProjectStatus(ProjectStatus status);


}
