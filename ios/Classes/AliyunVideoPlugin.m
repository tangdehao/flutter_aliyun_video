#import "AliyunVideoPlugin.h"
#if __has_include(<aliyun_video/aliyun_video-Swift.h>)
#import <aliyun_video/aliyun_video-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "aliyun_video-Swift.h"
#endif

@implementation AliyunVideoPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAliyunVideoPlugin registerWithRegistrar:registrar];
}
@end
