package com.example.pawpin.grpc;

import com.example.pawpin.util.ClaudeService;
import io.grpc.stub.StreamObserver;
import llm.LlmServiceGrpc;
import llm.Llm.PromptRequest;
import llm.Llm.PromptResponse;
import org.springframework.stereotype.Service;

@Service
public class LLMServiceImpl extends LlmServiceGrpc.LlmServiceImplBase {

    private final ClaudeService claudeService;

    public LLMServiceImpl(ClaudeService claudeService) {
        this.claudeService = claudeService;
    }

    @Override
    public void getCompletion(PromptRequest request, StreamObserver<PromptResponse> responseObserver) {
        try {
            String result = claudeService.callClaude(request.getPrompt());
            PromptResponse response = PromptResponse.newBuilder().setResult(result).build();
            responseObserver.onNext(response);
            responseObserver.onCompleted();
        } catch (Exception e) {
            responseObserver.onError(e);
        }
    }
}
