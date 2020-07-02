import 'package:flutter/material.dart';
import 'package:headset_connection_event/headset_event.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  HeadsetEvent headsetPlugin = new HeadsetEvent();
  HeadsetState headsetEvent;

  @override
  void initState() {
    super.initState();

    /// if headset is plugged
    headsetPlugin.getCurrentState.then((_val) {
      setState(() {
        headsetEvent = _val;
      });
    });

    /// Detect the moment headset is plugged or unplugged
    headsetPlugin.setListener((_val) {
      setState(() {
        headsetEvent = _val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
              color: this.headsetEvent == HeadsetState.CONNECT ? Colors.green : Colors.red,
            ),
            Text('State : $headsetEvent\n'),
          ],
        )),
      ),
    );
  }
}
