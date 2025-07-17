FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
COPY . ./
# Copy proto file
COPY protos/llm.proto ./protos/llm.proto
RUN python -m grpc_tools.protoc -Iprotos --python_out=. --grpc_python_out=. protos/llm.proto
EXPOSE 8080
CMD ["python", "app.py"]
