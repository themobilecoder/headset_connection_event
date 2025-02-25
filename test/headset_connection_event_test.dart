import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headset_connection_event/headset_event.dart';
import 'package:mockito/mockito.dart';

typedef DetectPluggedCallback = Function(HeadsetState payload);

class MockMethodChannel extends Mock implements MethodChannel {
  @override
  Future<T?> invokeMethod<T>(String method, [dynamic arguments]) {
    return super.noSuchMethod(Invocation.getter(#invokeMethod),
        returnValue: Future.value(0));
  }
}

void main() {
  late final MockMethodChannel methodChannel;
  late final HeadsetEvent headsetEvent;

  setUp(() {
    log('setting up');
    methodChannel = MockMethodChannel();
    log('setting headset');
    headsetEvent = HeadsetEvent.private(methodChannel);
  });

  test('getCurrentState', () async {
    when(methodChannel.invokeMethod<int>('getCurrentState'))
        .thenAnswer((Invocation invoke) => Future<int?>.value(0));

    expect(await headsetEvent.getCurrentState, HeadsetState.DISCONNECT);

    when(methodChannel.invokeMethod<int>('getCurrentState'))
        .thenAnswer((Invocation invoke) => Future<int>.value(1));
    expect(await headsetEvent.getCurrentState, HeadsetState.CONNECT);

    when(methodChannel.invokeMethod<int>('getCurrentState'))
        .thenAnswer((Invocation invoke) => Future<int>.value(-1));
    expect(await headsetEvent.getCurrentState, HeadsetState.DISCONNECT);
  });
}
