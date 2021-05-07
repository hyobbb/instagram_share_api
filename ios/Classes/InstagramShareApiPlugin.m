#import "InstagramShareApiPlugin.h"
#if __has_include(<instagram_share_api/instagram_share_api-Swift.h>)
#import <instagram_share_api/instagram_share_api-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "instagram_share_api-Swift.h"
#endif

@implementation InstagramShareApiPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftInstagramShareApiPlugin registerWithRegistrar:registrar];
}
@end
