package io.seunwater.openseun.controller;

import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/openseun/testnet/investor")
@RequiredArgsConstructor
@Tag(name = "Investor API", description = "Use this endpoint to access investor functionality.")
public class InvestorController {
}
