
import 'dart:async';
import 'package:flutter/services.dart';

class InstagramShareApi {
  static const MethodChannel _channel =
  const MethodChannel('instagram_share_api');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<void> sharePhoto(String path) async {
    return await _channel.invokeMethod('sharePhoto', <String, dynamic>{
      'path': path,
    });
  }

  static Future<void> shareVideo(String path) async {
    return await _channel.invokeMethod('shareVideo', <String, dynamic>{
      'path': path,
    });
  }

  static Future<void> shareFeed(String path) async {
    return await _channel.invokeMethod('shareFeed', <String, dynamic>{
      'path' : path,
    });
  }

}