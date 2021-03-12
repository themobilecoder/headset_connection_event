import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headset_connection_event/headset_event.dart';
import 'package:mockito/mockito.dart';

typedef DetectPluggedCallback = Function(HeadsetState payload);

class MockMethodChannel extends Mock implements MethodChannel {}

void main() {
  late final MockMethodChannel _methodChannel;
  late final HeadsetEvent _he;

  setUp(() {
    _methodChannel = MockMethodChannel();
    _he = HeadsetEvent.private(_methodChannel);
  });

  test('getCurrentState', () async {
    when(_methodChannel.invokeMethod<int>('getCurrentState')).thenAnswer((Invocation invoke) => Future<int>.value(0));
    expect(await _he.getCurrentState, HeadsetState.DISCONNECT);

    when(_methodChannel.invokeMethod<int>('getCurrentState')).thenAnswer((Invocation invoke) => Future<int>.value(1));
    expect(await _he.getCurrentState, HeadsetState.CONNECT);

    when(_methodChannel.invokeMethod<int>('getCurrentState')).thenAnswer((Invocation invoke) => Future<int>.value(-1));
    expect(await _he.getCurrentState, HeadsetState.DISCONNECT);
  });
}
