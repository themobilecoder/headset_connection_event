package flutter.moum.headset_event;

import android.bluetooth.BluetoothAdapter;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.view.KeyEvent;

public class HeadsetBroadcastReceiver extends BroadcastReceiver {
    private static final String TAG = "log";

    HeadsetEventListener headsetEventListener;

    public HeadsetBroadcastReceiver(HeadsetEventListener listener) {
        this.headsetEventListener = listener;
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        if (intent.getAction().equals(Intent.ACTION_HEADSET_PLUG)) {
            int state = intent.getIntExtra("state", -1);
            HeadsetEventPlugin.currentState = state;
            switch (state) {
                case 0:
                    headsetEventListener.onHeadsetDisconnect();
                    break;
                case 1:
                    headsetEventListener.onHeadsetConnect();
                    break;
                default:
                    Log.d(TAG, "I have no idea what the headset state is");
            }
        } else if (intent.getAction().equals(BluetoothAdapter.ACTION_CONNECTION_STATE_CHANGED)) {
            int connectionState = intent.getExtras().getInt(BluetoothAdapter.EXTRA_CONNECTION_STATE);
            switch (connectionState) {
                case BluetoothAdapter.STATE_CONNECTED:
                    headsetEventListener.onHeadsetConnect();
                    break;
                case BluetoothAdapter.STATE_DISCONNECTED:
                    headsetEventListener.onHeadsetDisconnect();
                    break;
                default:
                    break;
            }
        } else if (intent.getAction().equals(BluetoothAdapter.ACTION_STATE_CHANGED)) {
            int connectionState = intent.getExtras().getInt(BluetoothAdapter.EXTRA_STATE);
            if (connectionState == BluetoothAdapter.STATE_OFF) {
                headsetEventListener.onHeadsetDisconnect();
            }
        } else {
            abortBroadcast();

            KeyEvent key = (KeyEvent) intent.getParcelableExtra(Intent.EXTRA_KEY_EVENT);
            if (key.getAction() == KeyEvent.ACTION_UP) {

                int keycode = key.getKeyCode();
                Log.d(TAG, "onReceive: " + keycode);
                switch (keycode) {
                    case KeyEvent.KEYCODE_MEDIA_NEXT:
                        headsetEventListener.onNextButtonPress();
                        break;
                    case KeyEvent.KEYCODE_MEDIA_PREVIOUS:
                        headsetEventListener.onPrevButtonPress();
                        break;

                }
            }
        }
    }
}
