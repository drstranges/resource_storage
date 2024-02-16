/*
 * Copyright 2024 The Cached Resource Authors. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

import 'package:resource_storage/resource_storage.dart';

void main() async {
  final storage =
      MemoryResourceStorage<String, Entity>(storageName: 'entity_storage');
  storage.put('key1', Entity('value1'));
  storage.put('key2', Entity('value2'));
  storage.put('key2', Entity('value2-1'));

  final cache1 = await storage.getOrNull('key1');
  print('key1: ${cache1?.value}');

  final cache2 = await storage.getOrNull('key2');
  print('key2: ${cache2?.value}');
}

class Entity {
  Entity(this.value);

  final String value;

  @override
  String toString() => 'Entity($value)';
}

typedef _CacheBox<K, V> = Map<K, CacheEntry<V>>;

/// Simple in memory key-value storage
class MemoryResourceStorage<K, V> implements ResourceStorage<K, V> {
  /// Creates simple in memory key-value storage.
  MemoryResourceStorage({
    required this.storageName,
    this.timestampProvider = const TimestampProvider(),
  });

  /// Optional storage name. Can be visible in logs.
  final String storageName;

  /// Set custom timestamp provider if you need it in tests
  final TimestampProvider timestampProvider;

  /// Cache
  final _cacheBox = _CacheBox<K, V>();

  @override
  Future<CacheEntry<V>?> getOrNull(K key) async => _cacheBox[key];

  @override
  Future<void> put(K key, V data, {int? storeTime}) async {
    _cacheBox[key] = CacheEntry(
      data,
      storeTime: storeTime ?? timestampProvider.getTimestamp(),
    );
  }

  @override
  Future<void> remove(K key) async => _cacheBox.remove(key);

  @override
  Future<void> clear() async => _cacheBox.clear();

  @override
  String toString() => 'MemoryResourceStorage<$K, $V>[$storageName]';
}
