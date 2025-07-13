package com.example.pawpin.rest;

import com.example.pawpin.util.ClaudeService;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/claude")
public class ClaudeController {

    private final ClaudeService claudeService;

    public ClaudeController(ClaudeService claudeService) {
        this.claudeService = claudeService;
    }

    @GetMapping
    public String callClaude(@RequestParam String prompt) throws Exception {
        return claudeService.callClaude(prompt);
    }
}

