// Copyright 2024 The Cached Resource Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:developer';

/// The severity level for log entry
enum LoggerLevel { debug, warning, error }

/// Base interface of Logger with default implementation
interface class ResourceLogger {
  const ResourceLogger();

  void trace(
    LoggerLevel level,
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    var logLevel = switch (level) {
      LoggerLevel.debug => 0,
      LoggerLevel.warning || LoggerLevel.error => 900,
    };
    log(message, error: error, level: logLevel, stackTrace: stackTrace);
  }
}
