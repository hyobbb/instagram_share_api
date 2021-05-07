import Flutter
import UIKit
import Photos

public class SwiftInstagramShareApiPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "instagram_share_api", binaryMessenger: registrar.messenger())
        let instance = SwiftInstagramShareApiPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? Dictionary<String, Any>
        switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        case "sharePhoto":
            let path = args!["path"] as! String
            self.sharePhotoStory(path,result)
        case "shareVideo":
            let path = args!["path"] as! String
            self.shareVideoStory(path,result)
        case "shareFeed":
            let path = args!["path"] as! String
            self.shareFeed(path, result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func shareFeed(_ path:String, _ result: FlutterResult) {
        let fileUrl = URL(fileURLWithPath: path);
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",ascending: false)]
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d || mediaType = %d", PHAssetMediaType.image.rawValue, PHAssetMediaType.video.rawValue)
        fetchOptions.fetchLimit = 1
        
        let fetchResult = PHAsset.fetchAssets(with: fetchOptions)
        if let asset = fetchResult.firstObject{
            let localIdentifier = asset.localIdentifier
            let u = "instagram://library?LocalIdentifier=" + localIdentifier
            let url = NSURL(string: u)!
            if UIApplication.shared.canOpenURL(url as URL) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: u)!, options: [:], completionHandler: nil)
                }
            } else {
                result(FlutterError(code: "", message: "instagram is not installed", details: nil))
            }
        }
    }
    
    private func sharePhotoStory(_ path:String, _ result: FlutterResult) {
        let url = NSURL(string: "instagram-stories://share")!
        if UIApplication.shared.canOpenURL(url as URL) {
            let data = NSData(contentsOfFile: path)
            let pasteboardItems = [["com.instagram.sharedSticker.backgroundImage": data]]
            if #available(iOS 10.0, *) {
                UIPasteboard.general.setItems(pasteboardItems)
                UIApplication.shared.openURL(url as URL)
            }
        } else {
            result(FlutterError(code: "", message: "instagram is not installed", details: nil))
        }
    }
    
    private func shareVideoStory(_ path:String, _ result: FlutterResult) {
        let url = NSURL(string: "instagram-stories://share")!
        if UIApplication.shared.canOpenURL(url as URL) {
            let data = NSData(contentsOfFile: path)
            let pasteboardItems = [["com.instagram.sharedSticker.backgroundVideo": data]]
            if #available(iOS 10.0, *) {
                UIPasteboard.general.setItems(pasteboardItems)
                UIApplication.shared.openURL(url as URL)
            }
        } else {
            result(FlutterError(code: "", message: "instagram is not installed", details: nil))
        }
    }
}
