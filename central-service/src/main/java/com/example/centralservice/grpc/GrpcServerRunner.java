package com.example.centralservice.grpc;

import io.grpc.Server;
import io.grpc.ServerBuilder;
import jakarta.annotation.PostConstruct;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

@Component
public class GrpcServerRunner {
    private static final Logger log = LoggerFactory.getLogger(GrpcServerRunner.class);
    private final CentralServiceImpl centralService;
    private Server server;
    public GrpcServerRunner(CentralServiceImpl centralService) { this.centralService = centralService; }

    @PostConstruct
    public void start() throws Exception {
        server = ServerBuilder.forPort(9092)
                .addService(centralService)
                .build()
                .start();

        log.info("gRPC server started on port 9092");

        Runtime.getRuntime().addShutdownHook(new Thread(() -> {
            System.out.println("Shutting down gRPC server...");
            if (server != null) {
                server.shutdown();
            }
        }));

        // BLOCK MAIN THREAD
        server.awaitTermination();
    }
}
