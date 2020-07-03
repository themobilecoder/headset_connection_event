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
  static HeadsetEvent _instance;
  final MethodChannel _channel;
  DetectPluggedCallback detectPluggedCallback;

  factory HeadsetEvent() {
    if (_instance == null) {
      final MethodChannel methodChannel = const MethodChannel('flutter.moum/headset_event');
      _instance = HeadsetEvent.private(methodChannel);
    }
    return _instance;
  }

  HeadsetEvent.private(this._channel);

  Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<HeadsetState> get getCurrentState async {
    final int state = await _channel.invokeMethod('getCurrentState');
    switch (state) {
      case 0:
        return Future.value(HeadsetState.DISCONNECT);
      case 1:
        return Future.value(HeadsetState.CONNECT);
      case -1:
        return Future.value(HeadsetState.DISCONNECT);
    }
    return Future.value(HeadsetState.DISCONNECT);
  }

  setListener(DetectPluggedCallback onPlugged) {
    detectPluggedCallback = onPlugged;
    _channel.setMethodCallHandler(_handleMethod);
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case "connect":
        return detectPluggedCallback(HeadsetState.CONNECT);
      case "disconnect":
        return detectPluggedCallback(HeadsetState.DISCONNECT);
      case "nextButton":
        return detectPluggedCallback(HeadsetState.NEXT);
      case "prevButton":
        return detectPluggedCallback(HeadsetState.PREV);
      default:
        print('No idea');
        return detectPluggedCallback(HeadsetState.DISCONNECT);
    }
  }
}
