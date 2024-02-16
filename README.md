## Resource Storage
[![pub package](https://img.shields.io/pub/v/resource_storage.svg)](https://pub.dev/packages/resource_storage)

Base classes to implement resource storage for [cached_resource](https://pub.dev/packages/cached_resource) package.

## Components

1. `ResourceStorage`: base class to implement resource storage.
2. `CacheEntry`: base class that holds cached value and store timestamp.
3. `ResourceStorageProvider`: interface for resource storage factory.
4. `StorageDecoder`: interface for persistent storage decoding.
5. `StorageExecutor`: interface for task executor that can be provided externally and its simple implementation `syncStorageExecutor`.
6. `TimestampProvider`: helper class to use in tests for mocking of timestamp.
7. `Logger`: base logger interface.
8. `JsonStorageAdapter`: helper class for toJson/fromJson conversion using provided executor.