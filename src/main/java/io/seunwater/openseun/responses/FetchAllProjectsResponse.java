package io.seunwater.openseun.responses;

import io.seunwater.openseun.model.Project;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@AllArgsConstructor
public class FetchAllProjectsResponse {

    private List<Project> projects;

}
