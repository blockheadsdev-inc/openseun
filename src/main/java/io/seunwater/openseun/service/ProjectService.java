package io.seunwater.openseun.service;

import io.seunwater.openseun.common.ProjectStatus;
import io.seunwater.openseun.model.Project;
import io.seunwater.openseun.repository.ProjectRepository;
import io.seunwater.openseun.requests.*;
import io.seunwater.openseun.responses.ListProjectResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ProjectService {

    private final ProjectRepository projectRepository;


    public ListProjectResponse listProject(ListProjectRequest request){
        Project project = projectRepository
                .save(
                        new Project(
                                UUID.randomUUID(),
                                request.getName(),
                                request.getDescription(),
                                request.getLocation(),
                                request.getEstimatedReductions(),
                                request.getCategory(),
                                request.getType(),
                                ProjectStatus.ACTIVE
                        ));

        return new ListProjectResponse(project.getProjectId(), project.getName(), project.getStatus());
    }

    public void activateProject(ActivateProjectRequest request){

        Project project = projectRepository.findById(request.getProjectId()).get();
        project.setStatus(ProjectStatus.ACTIVE);
        projectRepository.save(project);

    }

    public void deactivateProject(DeactivateProjectRequest request){
        Project project = projectRepository.findById(request.getProjectId()).get();
        project.setStatus(ProjectStatus.INACTIVE);
        projectRepository.save(project);
    }

    public void updateProjectDetails(UpdateProjectDetailsRequest request){

        Project project = projectRepository.findById(request.getProjectId()).get();

        project.setName(request.getName());
        project.setDescription(request.getDescription());
        project.setLocation(request.getLocation());
        project.setEstimatedReductions(request.getEstimatedReductions());
        project.setCategory(request.getCategory());
        project.setType(request.getType());

        projectRepository.save(project);

    }

    public Project fetchProject(FetchProjectRequest request){
        return projectRepository.findById(request.getProjectId()).get();
    }

    public List<Project> fetchAllProjects(){
        return projectRepository.findByStatus(ProjectStatus.ACTIVE);
    }

}
