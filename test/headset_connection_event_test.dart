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
  late final MockMethodChannel _methodChannel;
  late final HeadsetEvent _he;

  setUp(() {
    print('setting up');
    _methodChannel = MockMethodChannel();
    print('setting headset');
    _he = HeadsetEvent.private(_methodChannel);
  });

  test('getCurrentState', () async {
    when(_methodChannel.invokeMethod<int>('getCurrentState'))
        .thenAnswer((Invocation invoke) => Future<int?>.value(0));

    expect(await _he.getCurrentState, HeadsetState.DISCONNECT);

    when(_methodChannel.invokeMethod<int>('getCurrentState'))
        .thenAnswer((Invocation invoke) => Future<int>.value(1));
    expect(await _he.getCurrentState, HeadsetState.CONNECT);

    when(_methodChannel.invokeMethod<int>('getCurrentState'))
        .thenAnswer((Invocation invoke) => Future<int>.value(-1));
    expect(await _he.getCurrentState, HeadsetState.DISCONNECT);
  });
}
