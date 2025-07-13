package com.example.pawpin.util;

import org.springframework.stereotype.Service;
import software.amazon.awssdk.auth.credentials.DefaultCredentialsProvider;
import software.amazon.awssdk.auth.credentials.ProfileCredentialsProvider;
import software.amazon.awssdk.core.SdkBytes;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.bedrockruntime.BedrockRuntimeClient;
import software.amazon.awssdk.services.bedrockruntime.model.InvokeModelRequest;
import software.amazon.awssdk.services.bedrockruntime.model.InvokeModelResponse;

import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;

import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class ClaudeService {

    private final BedrockRuntimeClient client = BedrockRuntimeClient.builder()
            .region(Region.EU_CENTRAL_1) // or whatever region Claude is deployed in
            .credentialsProvider(DefaultCredentialsProvider.create()) // ProfileCredentialsProvider.create("pawpin")
            .build();

    private final ObjectMapper objectMapper = new ObjectMapper();
    public String callClaude(String userInput) throws Exception {
        Map<String, Object> message = Map.of(
                "role", "user",
                "content", userInput
        );

        String body = objectMapper.writeValueAsString(Map.of(
                "messages", new Object[] { message },
                "max_tokens", 1024,
                "temperature", 0.7,
                "top_k", 250,
                "top_p", 0.9,
                "anthropic_version", "bedrock-2023-05-31"
        ));

        InvokeModelRequest request = InvokeModelRequest.builder()
                .modelId("eu.anthropic.claude-3-7-sonnet-20250219-v1:0")
                .contentType("application/json")
                .accept("application/json")
                .body(SdkBytes.fromString(body, StandardCharsets.UTF_8))
                .build();

        InvokeModelResponse response = client.invokeModel(request);
        String responseBody = response.body().asUtf8String();

        // Parse and extract the assistant's reply text
        Map<String, Object> result = objectMapper.readValue(responseBody, Map.class);
        var content = (List<Map<String, String>>) result.get("content");
        return content.get(0).get("text");
    }

}
