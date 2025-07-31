package com.example.rdsservice.grpc;

import io.grpc.Server;
import io.grpc.ServerBuilder;
import jakarta.annotation.PostConstruct;
import org.springframework.stereotype.Component;

@Component
public class GrpcServerRunner {
    private final RdsServiceImpl rdsService;
    private Server server;

    public GrpcServerRunner(RdsServiceImpl rdsService) {
        this.rdsService = rdsService;
    }

    @PostConstruct
    public void start() throws Exception {
        server = ServerBuilder.forPort(9091)
                .addService(rdsService)
                .build()
                .start();

        System.out.println("gRPC server started on port 9091");

        Runtime.getRuntime().addShutdownHook(new Thread(() -> {
            if (server != null) {
                System.out.println("Shutting down gRPC server...");
                server.shutdown();
            }
        }));

        // BLOCK MAIN THREAD
        server.awaitTermination();
    }
}
