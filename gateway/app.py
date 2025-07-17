from flask import Flask, request, jsonify
import grpc
import llm_pb2
import llm_pb2_grpc

app = Flask(__name__)

# gRPC channel to llm-service inside cluster
channel = grpc.insecure_channel('llm-service:9090')
stub = llm_pb2_grpc.LlmServiceStub(channel)

@app.route('/llm')
def llm():
    prompt = request.args.get('prompt', '')
    response = stub.GetCompletion(llm_pb2.PromptRequest(prompt=prompt))
    return jsonify({'result': response.result})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
