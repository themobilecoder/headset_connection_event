import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headset_connection_event/headset_event.dart';
import 'package:mockito/mockito.dart';

typedef DetectPluggedCallback = Function(HeadsetState payload);

void main() {
  MockMethodChannel methodChannel;
  HeadsetEvent he;

  setUp(() {
    methodChannel = MockMethodChannel();
    he = HeadsetEvent.private(methodChannel);
  });

  test('getCurrentState', () async {
    when(methodChannel.invokeMethod<int>('getCurrentState')).thenAnswer((Invocation invoke) => Future<int>.value(0));
    expect(await he.getCurrentState, HeadsetState.DISCONNECT);

    when(methodChannel.invokeMethod<int>('getCurrentState')).thenAnswer((Invocation invoke) => Future<int>.value(1));
    expect(await he.getCurrentState, HeadsetState.CONNECT);

    when(methodChannel.invokeMethod<int>('getCurrentState')).thenAnswer((Invocation invoke) => Future<int>.value(-1));
    expect(await he.getCurrentState, HeadsetState.DISCONNECT);
  });
}

class MockMethodChannel extends Mock implements MethodChannel {}
