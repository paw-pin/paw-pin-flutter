package com.example.centralservice.grpc;

import io.grpc.ManagedChannel;
import io.grpc.ManagedChannelBuilder;
import io.grpc.stub.StreamObserver;
import llm.LlmServiceGrpc;
import llm.Llm.PromptRequest;
import llm.Llm.PromptResponse;
import rds.RdsServiceGrpc;
import rds.Rds.Item;
import rds.Rds.ItemId;
import com.google.protobuf.Empty;
import central.CentralServiceGrpc;
import org.springframework.stereotype.Service;

@Service
public class CentralServiceImpl extends CentralServiceGrpc.CentralServiceImplBase {
    private final LlmServiceGrpc.LlmServiceBlockingStub llmStub;
    private final RdsServiceGrpc.RdsServiceBlockingStub rdsStub;

    public CentralServiceImpl() {
        ManagedChannel llmChannel = ManagedChannelBuilder.forAddress("llm-service", 9090)
                .usePlaintext()
                .build();
        llmStub = LlmServiceGrpc.newBlockingStub(llmChannel);

        ManagedChannel rdsChannel = ManagedChannelBuilder.forAddress("rds-service", 9091)
                .usePlaintext()
                .build();
        rdsStub = RdsServiceGrpc.newBlockingStub(rdsChannel);
    }

    @Override
    public void getCompletion(PromptRequest request, StreamObserver<PromptResponse> responseObserver) {
        PromptResponse response = llmStub.getCompletion(request);
        responseObserver.onNext(response);
        responseObserver.onCompleted();
    }

    @Override
    public void createItem(Item request, StreamObserver<Item> responseObserver) {
        Item response = rdsStub.createItem(request);
        responseObserver.onNext(response);
        responseObserver.onCompleted();
    }

    @Override
    public void getItem(ItemId request, StreamObserver<Item> responseObserver) {
        Item response = rdsStub.getItem(request);
        responseObserver.onNext(response);
        responseObserver.onCompleted();
    }

    @Override
    public void updateItem(Item request, StreamObserver<Item> responseObserver) {
        Item response = rdsStub.updateItem(request);
        responseObserver.onNext(response);
        responseObserver.onCompleted();
    }

    @Override
    public void deleteItem(ItemId request, StreamObserver<Empty> responseObserver) {
        rdsStub.deleteItem(request);
        responseObserver.onNext(Empty.getDefaultInstance());
        responseObserver.onCompleted();
    }
}
