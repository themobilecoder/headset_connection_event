# Headset Connection Event Flutter Plugin

A Flutter plugin to get a headset event.

*This is a clone of [headset_event](https://github.com/flutter-moum/flutter_headset_event), but with fix on swift errors and bluetooth connection events for Android*

Migrated to AndroidX

## Current Status

| Platform    | Physical Headset | Bluetooth |
| ----------- | ---------------- | --------- |
| iOS         | ✅               | ✅        |
| Android     | ✅               | ✅        |


## Usage
To use this plugin, add `headset_connection_event` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

### Example

``` dart
    // Import package
    import 'package:headset_connection_event/headset_event.dart';

    // Instantiate it
    HeadsetEvent headsetPlugin = new HeadsetEvent();
    HeadsetState headsetEvent;

    /// if headset is plugged
    headsetPlugin.getCurrentState.then((_val){
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
```
