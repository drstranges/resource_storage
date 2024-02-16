// Copyright 2024 The Cached Resource Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// Helper class to provide timestamp in milliseconds from the Unix epoch
/// Can be used to define custom timestamp logic in tests
interface class TimestampProvider {
  const TimestampProvider();

  factory TimestampProvider.from(int Function() provider) =>
      _TimestampProvider(provider);

  /// Returns timestamp in milliseconds from the Unix epoch
  int getTimestamp() => DateTime.now().millisecondsSinceEpoch;
}

class _TimestampProvider implements TimestampProvider {
  _TimestampProvider(this.delegate);

  final int Function() delegate;

  @override
  int getTimestamp() => delegate();
}
