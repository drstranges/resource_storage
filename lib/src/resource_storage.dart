// Copyright 2024 The Cached Resource Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'util/logger.dart';
import 'util/timestamp_provider.dart';

/// Base interface for resource cache storage
abstract interface class ResourceStorage<K, V> {
  /// Associates the [key] with the given [value] in the storage.
  ///
  /// If the key was already in the storage, its associated value is changed.
  /// Otherwise the key/value pair is added to the storage.
  Future<void> put(K key, V value, {int? storeTime});

  /// Returns cached entry by [key] if exists
  Future<CacheEntry<V>?> getOrNull(K key);

  /// Removes [key] and its associated value, if present, from the storage.
  Future<void> remove(K key);

  /// Clears all cached data in the storage
  Future<void> clear();
}

/// Base cache entry
class CacheEntry<V> {
  CacheEntry(this.value, {required this.storeTime});

  /// Cached value
  V value;

  /// Timestamp in milliseconds since the "Unix epoch"
  /// when entry was added to the storage
  int storeTime;
}

abstract interface class ResourceStorageProvider {
  ResourceStorage<K, V> createStorage<K, V>({
    required String storageName,
    StorageDecoder<V>? decode,
    StorageExecutor? executor,
    TimestampProvider? timestampProvider,
    Logger? logger,
  });
}

/// Base interface for persistent storage decoding.
///
/// For example, if value is stored as json in the DB, then after retrieving
/// data from the storage we need to convert it back. So we need decoder
/// like that:
/// ```dart
/// StorageDecoder<User> decoder = User.fromJson
/// ```
typedef StorageDecoder<V> = FutureOr<V> Function(dynamic storedValue);

/// Interface for task executor that can be provided externally
typedef StorageExecutor = FutureOr<T> Function<T>(FutureOr<T> Function() task);

/// Synchronous task executor that just calls a [task]
FutureOr<T> syncStorageExecutor<T>(FutureOr<T> Function() task) => task();
