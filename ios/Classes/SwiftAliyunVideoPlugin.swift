import Flutter
import UIKit

public class SwiftAliyunVideoPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "aliyun_video", binaryMessenger: registrar.messenger())
    let instance = SwiftAliyunVideoPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    
    
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    print("start call:\(call.method)")
    
    if call.method == "startVideo" {
        self.startVideoHandle(call, result: result)
//        self.startCompositionHandle(call, result: result)
    }
    
  }
    
    public func startVideoHandle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        let currentVC = UIViewController.current()
        currentVC?.modalPresentationStyle = .fullScreen
        
        let mediaConfig = AliyunMediaConfig.default()
        guard let arguments = call.arguments as? [String: Any] else {return}
        guard let mCreateType = arguments["mCreateType"] as? Int else {return}
        if let minDuration = arguments["mMinDuration"] as? Int {
            mediaConfig?.minDuration = CGFloat.init(minDuration/1000)
        }else {
            mediaConfig?.minDuration = 2.0
        }
        if let maxDuration = arguments["mMaxDuration"] as? Int {
            mediaConfig?.maxDuration = CGFloat.init(maxDuration/1000)
        }else {
            mediaConfig?.maxDuration = 10.0*60
        }
        if let gop = arguments["mGop"] as? Int {
            mediaConfig?.gop = Int32.init(gop)
        }else {
            mediaConfig?.gop = 5
        }
        if let encodeMode = arguments["mVideoCodec"] as? String {
            if encodeMode == AliYun.CodecsMode.DEFAULT_CODECS_H264_HARDWARE {
                mediaConfig?.encodeMode = .hardH264
            }
            if encodeMode == AliYun.CodecsMode.DEFAULT_CODECS_H264_H264_SOFT_OPENH264 {
                
            }
            if encodeMode == AliYun.CodecsMode.DEFAULT_CODECS_H264_H264_SOFT_FFMPEG {
                mediaConfig?.encodeMode = .softFFmpeg
            }
        }else {
            
        }
        if let mVideoQuality = arguments["mVideoQuality"] as? String {
            switch mVideoQuality {
            case AliYun.QualityMode.DEFAULT_QUALITY_SSD:
                mediaConfig?.videoQuality = .veryHight
            case AliYun.QualityMode.DEFAULT_QUALITY_HD:
                mediaConfig?.videoQuality = .hight
            case AliYun.QualityMode.DEFAULT_QUALITY_SD:
                mediaConfig?.videoQuality = .medium
            case AliYun.QualityMode.DEFAULT_QUALITY_LD:
                mediaConfig?.videoQuality = .low
            case AliYun.QualityMode.DEFAULT_QUALITY_PD:
                mediaConfig?.videoQuality = .poor
            case AliYun.QualityMode.DEFAULT_QUALITY_EPD:
                mediaConfig?.videoQuality = .extraPoor
            default:
                print("default")
            }
        }else {
            
        }
        if let mFrame = arguments["mFrame"] as? Int {
            
        }else {
            
        }
        if let mResolutionMode = arguments["mResolutionMode"] as? Int {
            
        }else {
            
        }
        if let mRatioMode = arguments["mRatioMode"] as? Int {
            
        }else {
            
        }
        mediaConfig?.fps = 25
        mediaConfig?.cutMode = .scaleAspectFill
        mediaConfig?.videoOnly = false
        mediaConfig?.backgroundColor = UIColor.black

        let cameraVC = AliyunMagicCameraViewController()
        cameraVC.modalPresentationStyle = .fullScreen
        if mCreateType == 0 {
            cameraVC.touchMode = .click
        }else {
            cameraVC.touchMode = .longPress
        }
        cameraVC.setValue(mediaConfig, forKey: "quVideo")
        cameraVC.finishBlock = { (path) -> () in
            let dict = ["fileType": "0", "filePath": path]
            result(dict)
        }
        
        currentVC?.present(cameraVC, animated: false, completion: {
            
        })
    }
    
    public func startCompositionHandle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let currentVC = UIViewController.current()
        currentVC?.modalPresentationStyle = .fullScreen
        
//        let mediaConfig = AliyunMediaConfig.default()
//        mediaConfig?.videoOnly = true
//        let compositionVC = AliyunCompositionViewController()
//        compositionVC.controllerType = .videoMix
//        compositionVC.isOriginal = true
//        compositionVC.compositionConfig = mediaConfig
//        let navc = UINavigationController(rootViewController: compositionVC)
//        currentVC?.present(navc, animated: false, completion: {
//
//        })
    }
}

extension UIViewController {
    class func current(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return current(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return current(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return current(base: presented)
        }
        return base
    }
}

struct AliYun {
    struct QualityMode {
        static let DEFAULT_QUALITY_SSD = "SSD"
        static let DEFAULT_QUALITY_HD = "HD"
        static let DEFAULT_QUALITY_SD = "SD"
        static let DEFAULT_QUALITY_LD = "LD"
        static let DEFAULT_QUALITY_PD = "PD"
        static let DEFAULT_QUALITY_EPD = "EPD"
    }
    
    struct CodecsMode {
        static let DEFAULT_CODECS_H264_HARDWARE = "H264_HARDWARE"
        static let DEFAULT_CODECS_H264_H264_SOFT_OPENH264 =
            "H264_SOFT_OPENH264"
        static let DEFAULT_CODECS_H264_H264_SOFT_FFMPEG = "H264_SOFT_FFMPEG"
    }
    struct RatioMode {
        static let DEFAULT_RATIO_MODE_3_4 = 0
        static let DEFAULT_RATIO_MODE_1_1 = 1
        static let DEFAULT_RATIO_MODE_9_16 = 2
    }
    
}
