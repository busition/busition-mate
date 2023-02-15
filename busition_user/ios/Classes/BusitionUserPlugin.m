#import "BusitionUserPlugin.h"
#if __has_include(<busition_user/busition_user-Swift.h>)
#import <busition_user/busition_user-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "busition_user-Swift.h"
#endif

@implementation BusitionUserPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftBusitionUserPlugin registerWithRegistrar:registrar];
}
@end
