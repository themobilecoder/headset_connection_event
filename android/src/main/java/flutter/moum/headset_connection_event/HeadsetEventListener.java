package flutter.moum.headset_connection_event;

public interface HeadsetEventListener {
    void onHeadsetConnect();

    void onHeadsetDisconnect();

    void onNextButtonPress();

    void onPrevButtonPress();
}
