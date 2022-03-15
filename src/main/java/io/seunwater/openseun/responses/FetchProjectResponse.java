package io.seunwater.openseun.responses;

import io.seunwater.openseun.model.Project;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
public class FetchProjectResponse {

    private Project project;
}
