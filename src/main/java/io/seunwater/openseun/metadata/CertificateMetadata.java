package io.seunwater.openseun.metadata;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class CertificateMetadata{
	private String version;
	private String name;
	private String description;
	private String image;
	private Localization localization;
}