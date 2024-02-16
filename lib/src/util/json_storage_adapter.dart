// Copyright 2024 The Cached Resource Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';

import '../resource_storage.dart';
import 'logger.dart';

class JsonStorageAdapter<V> {
  const JsonStorageAdapter({
    required StorageDecoder<V> decode,
    required StorageExecutor executor,
    Logger? logger,
  })  : _decode = decode,
        _executor = executor,
        _logger = logger;

  final StorageDecoder<V> _decode;
  final StorageExecutor _executor;
  final Logger? _logger;

  Future<String> encodeToJson(V value) async {
    return _executor(() {
      try {
        return jsonEncode(value);
      } catch (e, st) {
        _logger?.trace(LoggerLevel.error,
            'ResourceStorage: Error while jsonEncode', e, st);
        rethrow;
      }
    });
  }

  Future<V> decodeFromJson(dynamic json) async {
    return _executor(() {
      final dynamic jsonMap;
      try {
        jsonMap = jsonDecode(json);
      } catch (e, st) {
        _logger?.trace(LoggerLevel.error,
            'ResourceStorage: Error while jsonDecode', e, st);
        rethrow;
      }
      try {
        return _decode(jsonMap);
      } catch (e, st) {
        _logger?.trace(LoggerLevel.error,
            'ResourceStorage: Error while decoding stored value', e, st);
        rethrow;
      }
    });
  }
}
