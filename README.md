# Welcome

[Hyperledger Iroha](https://github.com/hyperledger/iroha) client using Akka gRPC

The published assets are in a Jetbrains Space, public JARs are not included for this repository.

## Testing

Integration tests for this library require Docker to start Hyperledger Iroha.

```
docker-compose up -d node postgres
sbt test
```
