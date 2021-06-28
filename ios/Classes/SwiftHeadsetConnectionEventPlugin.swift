import Flutter
import UIKit
import AVFoundation


public class SwiftHeadsetConnectionEventPlugin: NSObject, FlutterPlugin {
    var channel : FlutterMethodChannel?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter.moum/headset_connection_event", binaryMessenger: registrar.messenger())
        let instance = SwiftHeadsetConnectionEventPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        instance.channel = channel
    }
    
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (call.method == "getCurrentState"){
            result(HeadsetIsConnect())
        }
    }
    
    public override init() {
        super.init()
        registerAudioRouteChangeBlock()
    }
    
    // AVAudioSessionRouteChange notification is Detaction Headphone connection status
    //(https://developer.apple.com/documentation/avfoundation/avaudiosession/responding_to_audio_session_route_changes)
    // When the AVAudioSessionRouteChange is called from notification center , the blcoking code detect the headphone connection.
    // Regular notification center work on the main UI thread but in this case it works on a particular thread.
    // So we should using blcoking.
    /////////////////////////////////////////////////////////////
    func registerAudioRouteChangeBlock(){
        NotificationCenter.default.addObserver( forName:AVAudioSession.routeChangeNotification, object: AVAudioSession.sharedInstance(), queue: nil) { notification in
            guard let userInfo = notification.userInfo,
                  let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
                  let reason = AVAudioSession.RouteChangeReason(rawValue:reasonValue) else {
                return
            }
            switch reason {
            case .newDeviceAvailable:
                self.channel!.invokeMethod("connect",arguments: "true")
            case .oldDeviceUnavailable:
                self.channel!.invokeMethod("disconnect",arguments: "true")
            default: ()
            }
        }
    }
    
    func HeadsetIsConnect() -> Int  {
        let currentRoute = AVAudioSession.sharedInstance().currentRoute
        for output in currentRoute.outputs {
            let portType = output.portType
            if portType == AVAudioSession.Port.headphones || portType == AVAudioSession.Port.bluetoothA2DP || portType == AVAudioSession.Port.bluetoothHFP {
                return 1
            } else {
                return 0
            }
        }
        return 0
    }
}
