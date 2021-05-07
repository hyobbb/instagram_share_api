package com.example.instagram_share_api;

import android.app.Activity;
import android.content.Context;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;

/**
 * InstagramShareApiPlugin
 */
public class InstagramShareApiPlugin implements FlutterPlugin, ActivityAware {

    private static final String CHANNEL = "instagram_share_api";
    private MethodCallHandler handler;
    private InstagramShare instagramShare;
    private MethodChannel methodChannel;

    @SuppressWarnings("deprecation")
    public static void registerWith(io.flutter.plugin.common.PluginRegistry.Registrar registrar) {
        InstagramShareApiPlugin plugin = new InstagramShareApiPlugin();
        plugin.setUpChannel(registrar.context(), registrar.activity(), registrar.messenger());
    }

    @Override
    public void onAttachedToEngine(FlutterPluginBinding binding) {
        setUpChannel(binding.getApplicationContext(), null, binding.getBinaryMessenger());
    }

    @Override
    public void onDetachedFromEngine(FlutterPluginBinding binding) {
        methodChannel.setMethodCallHandler(null);
        methodChannel = null;
        instagramShare = null;
    }

    @Override
    public void onAttachedToActivity(ActivityPluginBinding binding) {
        instagramShare.setActivity(binding.getActivity());
    }

    @Override
    public void onDetachedFromActivity() {
        tearDownChannel();
    }

    @Override
    public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
        onAttachedToActivity(binding);
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity();
    }


    private void setUpChannel(Context context, Activity activity, BinaryMessenger messenger) {
        methodChannel = new MethodChannel(messenger, CHANNEL);
        instagramShare = new InstagramShare(context, activity);
        handler = new MethodCallHandler(instagramShare);
        methodChannel.setMethodCallHandler(handler);
    }

    private void tearDownChannel() {
        instagramShare.setActivity(null);
        methodChannel.setMethodCallHandler(null);
    }
}
