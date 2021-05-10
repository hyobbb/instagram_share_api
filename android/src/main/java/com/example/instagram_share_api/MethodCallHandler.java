package com.example.instagram_share_api;

import java.io.IOException;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MethodCallHandler implements MethodChannel.MethodCallHandler {

    private InstagramShare instagramShare;

    MethodCallHandler(InstagramShare instagramShare) {
        this.instagramShare = instagramShare;
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        if (call.method.equals("getPlatformVersion")) {
            result.success(String.format("Android %s", android.os.Build.VERSION.RELEASE));
        } else if (call.method.equals("sharePhoto")) {
            String path = call.argument("path");
            try {
                instagramShare.sharePhoto(path);
                result.success(null);
            } catch (IOException e) {
                result.error("IOException", e.getMessage(), null);
            }
        } else if (call.method.equals("shareVideo")) {
            String path = call.argument("path");
            try {
                instagramShare.shareVideo(path);
                result.success(null);
            } catch (IOException e) {
                result.error("IOException", e.getMessage(), null);
            }
        } else if (call.method.equals("shareFeed")) {
            String path = call.argument("path");
            String type = call.argument("type");
            try {
                instagramShare.shareFeed(path, type);
                result.success(null);
            } catch (IOException e) {
                result.error("IOException", e.getMessage(), null);
            }
        } else {
            result.notImplemented();
        }
    }

}
