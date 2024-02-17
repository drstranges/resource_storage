// Copyright 2024 The Cached Resource Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';

import '../resource_storage.dart';
import 'resource_logger.dart';

/// Helper class for toJson/fromJson conversion using provided [executor]
/// and [decode].
class JsonStorageAdapter<V> {
  /// Creates [JsonStorageAdapter] using provided [executor].
  /// [decode] should be provided outside as in Dart for Flutter there is no way
  /// to decode json to concrete class without knowing about the class.
  const JsonStorageAdapter({
    required StorageDecoder<V> decode,
    required StorageExecutor executor,
    ResourceLogger? logger,
  })  : _decode = decode,
        _executor = executor,
        _logger = logger;

  final StorageDecoder<V> _decode;
  final StorageExecutor _executor;
  final ResourceLogger? _logger;

  /// Converts [value] to a JSON string using [executor].
  ///
  /// If [value] contains objects that are not directly encodable to a JSON
  /// string (a value that is not a number, boolean, string, null, list or a map
  /// with string keys), the `value.toJson()` function is called to convert it
  /// to an object that must be directly encodable.
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

  /// Parses the string to JSON and then using [_decode] returns the resulting
  /// object with type [V].
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
