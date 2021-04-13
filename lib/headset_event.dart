import 'dart:async';

import 'package:flutter/services.dart';

typedef DetectPluggedCallback = Function(HeadsetState payload);

enum HeadsetState {
  CONNECT,
  DISCONNECT,
  NEXT,
  PREV,
}

class HeadsetEvent {
  static HeadsetEvent? _instance;

  final MethodChannel _channel;

  DetectPluggedCallback? _detectPluggedCallback;

  HeadsetEvent.private(this._channel);

  factory HeadsetEvent() {
    if (_instance == null) {
      final methodChannel = const MethodChannel('flutter.moum/headset_connection_event');
      _instance = HeadsetEvent.private(methodChannel);
    }

    return _instance!;
  }

  Future<HeadsetState?> get getCurrentState async {
    final state = await _channel.invokeMethod<int?>('getCurrentState');

    switch (state) {
      case 0:
        return HeadsetState.DISCONNECT;
      case 1:
        return HeadsetState.CONNECT;
      default:
        return null;
    }
  }

  void setListener(DetectPluggedCallback onPlugged) {
    _detectPluggedCallback = onPlugged;
    _channel.setMethodCallHandler(_handleMethod);
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    final callback = _detectPluggedCallback;
    if (callback == null) {
      return;
    }

    switch (call.method) {
      case "connect":
        return callback(HeadsetState.CONNECT);
      case "disconnect":
        return callback(HeadsetState.DISCONNECT);
      case "nextButton":
        return callback(HeadsetState.NEXT);
      case "prevButton":
        return callback(HeadsetState.PREV);
    }
  }
}
