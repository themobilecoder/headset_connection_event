#import "HeadsetEventPlugin.h"
#import <headset_connection_event/headset_connection_event-Swift.h>

@implementation HeadsetEventPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftHeadsetEventPlugin registerWithRegistrar:registrar];
}
@end
