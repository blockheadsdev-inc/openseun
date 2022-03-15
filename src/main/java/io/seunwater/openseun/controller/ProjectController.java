package io.seunwater.openseun.controller;

import io.seunwater.openseun.model.Project;
import io.seunwater.openseun.requests.*;
import io.seunwater.openseun.responses.ListProjectResponse;
import io.seunwater.openseun.service.ProjectService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/openseun/testnet/project")
@RequiredArgsConstructor
@Tag(name = "Project API", description = "Use this endpoint to access project functionality.")
public class ProjectController {

    private final ProjectService projectService;

    @PostMapping("/listProject")
    @Operation(summary = "Use this endpoint to List a new Project.")
    public ResponseEntity<ListProjectResponse> listProject(@RequestBody ListProjectRequest request){
        ListProjectResponse response = projectService.listProject(request);
        return ResponseEntity.status(HttpStatus.OK).body(response);
    }

    @PostMapping("/activateProject")
    @Operation(summary = "Use this endpoint to Activate an existing Project.")
    public ResponseEntity<String> activateProject(@RequestBody ActivateProjectRequest request){
        projectService.activateProject(request);
        return ResponseEntity.ok().body("Project Activated");
    }

    @DeleteMapping("/deactivateProject")
    @Operation(summary = "Use this endpoint to Deactivate an existing Project.")
    public ResponseEntity<String> deactivateProject(@RequestBody DeactivateProjectRequest request){
        projectService.deactivateProject(request);
        return ResponseEntity.ok().body("Project Deactivated");
    }

    @PutMapping("/updateProjectDetails")
    @Operation(summary = "Use this endpoint to Update an existing project's Details.")
    public ResponseEntity<String> updateProjectDetails(@RequestBody UpdateProjectDetailsRequest request){
        projectService.updateProjectDetails(request);
        return ResponseEntity.ok().body("Project Details Updated");
    }

    @GetMapping("/fetchProjectData")
    @Operation(summary = "Use this endpoint to Query an existing Project")
    public ResponseEntity<Project> fetchProject(@RequestBody FetchProjectRequest request){
        Project project = projectService.fetchProject(request);

        return ResponseEntity.status(HttpStatus.OK).body(project);
    }

    @GetMapping("/fetchAllProjects")
    @Operation(summary = "Use this endpoint to Fetch All Active Projects.")
    public ResponseEntity<List<Project>> fetchAllProjects(@RequestBody FetchAllProjectsRequest request){
        List<Project> projects = projectService.fetchAllProjects();

        return ResponseEntity.ok().body(projects);

    }

}
