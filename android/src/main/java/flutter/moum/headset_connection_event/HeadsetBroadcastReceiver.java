package flutter.moum.headset_connection_event;

import android.bluetooth.BluetoothAdapter;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.view.KeyEvent;

public class HeadsetBroadcastReceiver extends BroadcastReceiver {
    private final HeadsetEventListener headsetEventListener;

    public HeadsetBroadcastReceiver(HeadsetEventListener listener) {
        this.headsetEventListener = listener;
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        switch (intent.getAction()) {
            case Intent.ACTION_HEADSET_PLUG:
                final int state = intent.getIntExtra("state", -1);
                HeadsetConnectionEventPlugin.currentState = state;

                switch (state) {
                    case 0:
                        headsetEventListener.onHeadsetDisconnect();
                        break;
                    case 1:
                        headsetEventListener.onHeadsetConnect();
                        break;
                }
                break;
            case BluetoothAdapter.ACTION_CONNECTION_STATE_CHANGED: {
                final int connectionState = intent.getExtras().getInt(BluetoothAdapter.EXTRA_CONNECTION_STATE);

                switch (connectionState) {
                    case BluetoothAdapter.STATE_CONNECTED:
                        headsetEventListener.onHeadsetConnect();
                        break;
                    case BluetoothAdapter.STATE_DISCONNECTED:
                        headsetEventListener.onHeadsetDisconnect();
                        break;
                }
                break;
            }
            case BluetoothAdapter.ACTION_STATE_CHANGED: {
                final int connectionState = intent.getExtras().getInt(BluetoothAdapter.EXTRA_STATE);

                if (connectionState == BluetoothAdapter.STATE_OFF) {
                    headsetEventListener.onHeadsetDisconnect();
                }
                break;
            }
            default:
                abortBroadcast();

                final KeyEvent key = intent.getParcelableExtra(Intent.EXTRA_KEY_EVENT);
                if (key.getAction() == KeyEvent.ACTION_UP) {
                    final int keycode = key.getKeyCode();

                    switch (keycode) {
                        case KeyEvent.KEYCODE_MEDIA_NEXT:
                            headsetEventListener.onNextButtonPress();
                            break;
                        case KeyEvent.KEYCODE_MEDIA_PREVIOUS:
                            headsetEventListener.onPrevButtonPress();
                            break;
                    }
                }
                break;
        }
    }
}
