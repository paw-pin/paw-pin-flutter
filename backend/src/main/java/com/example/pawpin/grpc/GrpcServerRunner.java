package com.example.pawpin.grpc;

import io.grpc.Server;
import io.grpc.ServerBuilder;
import jakarta.annotation.PostConstruct;
import org.springframework.stereotype.Component;

@Component
public class GrpcServerRunner {

    private final LLMServiceImpl llmService;
    private Server server;

    public GrpcServerRunner(LLMServiceImpl llmService) {
        this.llmService = llmService;
    }

    @PostConstruct
    public void start() throws Exception {
        server = ServerBuilder.forPort(9090)
                .addService(llmService)
                .build()
                .start();

        Runtime.getRuntime().addShutdownHook(new Thread(() -> {
            if (server != null) {
                server.shutdown();
            }
        }));
    }
}
