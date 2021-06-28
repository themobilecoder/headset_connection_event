import 'dart:async';

import 'package:flutter/services.dart';

typedef DetectPluggedCallback = Function(HeadsetState payload);

enum HeadsetState {
  CONNECT,
  DISCONNECT,
  NEXT,
  PREV,
}

/*
The HeadsetEvent class allows you to listen to different headset status changes.
These status changes include plugging in and out of physical headset to your phone,
connecting, and disconnecting of bluetooth devices.

Usage: Instantiate a [HeadsetEvent] by using a factory constructor. Under the hood,
this constructor will always return a single instance if one has been instantiated before.
*/
class HeadsetEvent {
  static HeadsetEvent? _instance;

  final MethodChannel _channel;

  DetectPluggedCallback? _detectPluggedCallback;

  HeadsetEvent.private(this._channel);

  factory HeadsetEvent() {
    if (_instance == null) {
      final methodChannel =
          const MethodChannel('flutter.moum/headset_connection_event');
      _instance = HeadsetEvent.private(methodChannel);
    }

    return _instance!;
  }

  //Reads asynchronously the current state of the headset with type [HeadsetState]
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

  //Sets a callback that is called whenever a change in [HeadsetState] happens.
  //Callback function [onPlugged] must accept a [HeadsetState] parameter.
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
