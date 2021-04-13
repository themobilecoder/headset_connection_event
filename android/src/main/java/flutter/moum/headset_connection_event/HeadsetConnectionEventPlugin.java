package flutter.moum.headset_connection_event;

import android.bluetooth.BluetoothAdapter;
import android.content.Intent;
import android.content.IntentFilter;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * HeadsetConnectionEventPlugin
 */
public class HeadsetConnectionEventPlugin implements FlutterPlugin, MethodCallHandler {
    public static int currentState = -1;

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;

    private final HeadsetEventListener headsetEventListener = new HeadsetEventListener() {
        @Override
        public void onHeadsetConnect() {
            channel.invokeMethod("connect", "true");
        }

        @Override
        public void onHeadsetDisconnect() {
            channel.invokeMethod("disconnect", "true");
        }

        @Override
        public void onNextButtonPress() {
            channel.invokeMethod("nextButton", "true");
        }

        @Override
        public void onPrevButtonPress() {
            channel.invokeMethod("prevButton", "true");
        }
    };

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter.moum/headset_connection_event");
        channel.setMethodCallHandler(this);

        final HeadsetBroadcastReceiver hReceiver = new HeadsetBroadcastReceiver(headsetEventListener);
        final IntentFilter filter = new IntentFilter();
        filter.addAction(Intent.ACTION_HEADSET_PLUG);
        filter.addAction(BluetoothAdapter.ACTION_CONNECTION_STATE_CHANGED);
        filter.addAction(BluetoothAdapter.ACTION_STATE_CHANGED);
        flutterPluginBinding.getApplicationContext().registerReceiver(hReceiver, filter);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("getCurrentState")) {
            result.success(currentState);
        } else {
            result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }
}
