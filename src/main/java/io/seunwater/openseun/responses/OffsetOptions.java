package io.seunwater.openseun.responses;

import io.seunwater.openseun.model.OffsetOption;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class OffsetOptions {

    private List<OffsetOption> options;

}
