package com.example.rdsservice.grpc;

import com.example.rdsservice.item.Item;
import com.example.rdsservice.item.ItemRepository;
import io.grpc.stub.StreamObserver;
import com.google.protobuf.Empty;
import rds.RdsServiceGrpc;
import rds.Rds.ItemId;
import rds.Rds;
import org.springframework.stereotype.Service;

@Service
public class RdsServiceImpl extends RdsServiceGrpc.RdsServiceImplBase {
    private final ItemRepository repository;
    public RdsServiceImpl(ItemRepository repository) { this.repository = repository; }

    private Rds.Item toProto(Item item) {
        return Rds.Item.newBuilder()
                .setId(item.getId())
                .setName(item.getName())
                .build();
    }

    @Override
    public void createItem(Rds.Item request, StreamObserver<Rds.Item> responseObserver) {
        Item item = new Item();
        item.setName(request.getName());
        item = repository.save(item);
        responseObserver.onNext(toProto(item));
        responseObserver.onCompleted();
    }

    @Override
    public void getItem(ItemId request, StreamObserver<Rds.Item> responseObserver) {
        repository.findById(request.getId()).ifPresent(item -> responseObserver.onNext(toProto(item)));
        responseObserver.onCompleted();
    }

    @Override
    public void updateItem(Rds.Item request, StreamObserver<Rds.Item> responseObserver) {
        Item item = repository.findById(request.getId()).orElseGet(Item::new);
        item.setName(request.getName());
        item = repository.save(item);
        responseObserver.onNext(toProto(item));
        responseObserver.onCompleted();
    }

    @Override
    public void deleteItem(ItemId request, StreamObserver<Empty> responseObserver) {
        repository.deleteById(request.getId());
        responseObserver.onNext(Empty.getDefaultInstance());
        responseObserver.onCompleted();
    }
}
