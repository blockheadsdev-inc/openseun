package io.seunwater.openseun.responses;

import io.seunwater.openseun.common.ProjectStatus;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@AllArgsConstructor
public class ListProjectResponse {

    private UUID projectId;

    private String name;

    private ProjectStatus status;

}
