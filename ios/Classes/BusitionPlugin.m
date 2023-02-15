#import "BusitionPlugin.h"
#if __has_include(<busition/busition-Swift.h>)
#import <busition/busition-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "busition-Swift.h"
#endif

@implementation BusitionPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftBusitionPlugin registerWithRegistrar:registrar];
}
@end
