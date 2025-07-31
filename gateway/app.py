from flask import Flask, request, jsonify
import grpc
import central_pb2
import central_pb2_grpc
import llm_pb2
import rds_pb2

app = Flask(__name__)

# gRPC channel to central-service inside cluster
channel = grpc.insecure_channel('central-service:9092')
stub = central_pb2_grpc.CentralServiceStub(channel)

@app.route('/llm')
def llm():
    prompt = request.args.get('prompt', '')
    response = stub.GetCompletion(llm_pb2.PromptRequest(prompt=prompt))
    return jsonify({'result': response.result})

@app.route('/items', methods=['POST'])
def create_item():
    data = request.get_json(force=True)
    item = rds_pb2.Item(name=data.get('name', ''))
    result = stub.CreateItem(item)
    return jsonify({'id': result.id, 'name': result.name})

@app.route('/items/<int:item_id>', methods=['GET'])
def get_item(item_id):
    result = stub.GetItem(rds_pb2.ItemId(id=item_id))
    return jsonify({'id': result.id, 'name': result.name})

@app.route('/items/<int:item_id>', methods=['PUT'])
def update_item(item_id):
    data = request.get_json(force=True)
    item = rds_pb2.Item(id=item_id, name=data.get('name', ''))
    result = stub.UpdateItem(item)
    return jsonify({'id': result.id, 'name': result.name})

@app.route('/items/<int:item_id>', methods=['DELETE'])
def delete_item(item_id):
    stub.DeleteItem(rds_pb2.ItemId(id=item_id))
    return jsonify({'deleted': True})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
