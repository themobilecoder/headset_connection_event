import 'package:flutter/material.dart';
import 'package:headset_connection_event/headset_event.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _headsetPlugin = HeadsetEvent();
  HeadsetState? _headsetState;

  @override
  void initState() {
    super.initState();

    ///Request Permissions (Required for Android 12)
    _headsetPlugin.requestPermission();

    /// if headset is plugged
    _headsetPlugin.getCurrentState.then((value) {
      setState(() {
        _headsetState = value;
      });
    });

    /// Detect the moment headset is plugged or unplugged
    _headsetPlugin.setListener((value) {
      setState(() {
        _headsetState = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Headset Event Plugin'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.headset,
                  color: _headsetState == HeadsetState.CONNECT
                      ? Colors.green
                      : Colors.red,
                ),
                Text('State : $_headsetState\n'),
              ],
            ),
          ),
        ),
      );
}
