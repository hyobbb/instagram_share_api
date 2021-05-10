package com.example.instagram_share_api;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.res.Resources;
import android.net.Uri;

import androidx.annotation.NonNull;
import androidx.core.content.FileProvider;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

/** InstagramShareApiPlugin */
public class InstagramShare {

  private Context context;
  private Activity activity;

  InstagramShare(Context context, Activity activity) {
    this.context = context;
    this.activity = activity;
  }

  void setActivity(Activity activity) {
    this.activity = activity;
  }

  void sharePhoto(String path) throws IOException {
    if (path == null || path.isEmpty()) {
      throw new IllegalArgumentException("Non-empty path expected");
    }

    if (!isAppInstalled("com.instagram.android")) {
      throw new Resources.NotFoundException("Instagram is not installed");
    }

    clearExternalShareFolder();
    Uri assetUri = getUriForPath(path);

    Intent intent = new Intent("com.instagram.share.ADD_TO_STORY");
    intent.setDataAndType(assetUri, "image/*");
    intent.setFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);

    startActivity(intent);
  }

  void shareVideo(String path) throws IOException  {
    if (path == null || path.isEmpty()) {
      throw new IllegalArgumentException("Non-empty path expected");
    }

    if (!isAppInstalled("com.instagram.android")) {
      throw new Resources.NotFoundException("Instagram is not installed");
    }

    clearExternalShareFolder();
    Uri assetUri = getUriForPath(path);

    Intent intent = new Intent("com.instagram.share.ADD_TO_STORY");
    intent.setDataAndType(assetUri, "video/mp4");
    intent.setFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);

    startActivity(intent);
  }

  void shareFeed(String path, String type) throws IOException {
    if (path == null || path.isEmpty()) {
      throw new IllegalArgumentException("Non-empty path expected");
    }

    if (!isAppInstalled("com.instagram.android")) {
      throw new Resources.NotFoundException("Instagram is not installed");
    }

    clearExternalShareFolder();
    Uri uri = getUriForPath(path);

    Intent intent = new Intent(Intent.ACTION_SEND);
    //image: "image/*", video: "video/*"
    intent.setType(type);
    intent.putExtra(Intent.EXTRA_STREAM, uri);

    startActivity(Intent.createChooser(intent, "Share To"));
  }

  private boolean isAppInstalled(String uri) {
    try {
      getContext().getPackageManager().getPackageInfo(uri, 0);
      return true;
    } catch (PackageManager.NameNotFoundException e) {
      return false;
    }
  }

  private void startActivity(Intent intent) {
    if (activity != null) {
      activity.startActivity(intent);
    } else if (context != null) {
      intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
      context.startActivity(intent);
    } else {
      throw new IllegalStateException("Both context and activity are null");
    }
  }

  private Uri getUriForPath(String path) throws IOException {
    File file = new File(path);
    if (!fileIsOnExternal(file)) {
      file = copyToExternalShareFolder(file);
    }

    return FileProvider.getUriForFile(
            getContext(), getContext().getPackageName() + ".flutter.share_provider", file);
  }

  private boolean fileIsOnExternal(File file) {
    try {
      String filePath = file.getCanonicalPath();
      File externalDir = context.getExternalFilesDir(null);
      return externalDir != null && filePath.startsWith(externalDir.getCanonicalPath());
    } catch (IOException e) {
      return false;
    }
  }

  @SuppressWarnings("ResultOfMethodCallIgnored")
  private void clearExternalShareFolder() {
    File folder = getExternalShareFolder();
    if (folder.exists()) {
      for (File file : folder.listFiles()) {
        file.delete();
      }
      folder.delete();
    }
  }

  @SuppressWarnings("ResultOfMethodCallIgnored")
  private File copyToExternalShareFolder(File file) throws IOException {
    File folder = getExternalShareFolder();
    if (!folder.exists()) {
      folder.mkdirs();
    }

    File newFile = new File(folder, file.getName());
    copy(file, newFile);
    return newFile;
  }

  @NonNull
  private File getExternalShareFolder() {
    return new File(getContext().getExternalCacheDir(), "share");
  }

  private Context getContext() {
    if (activity != null) {
      return activity;
    }
    if (context != null) {
      return context;
    }

    throw new IllegalStateException("Both context and activity are null");
  }

  private static void copy(File src, File dst) throws IOException {
    InputStream in = new FileInputStream(src);
    try {
      OutputStream out = new FileOutputStream(dst);
      try {
        // Transfer bytes from in to out
        byte[] buf = new byte[1024];
        int len;
        while ((len = in.read(buf)) > 0) {
          out.write(buf, 0, len);
        }
      } finally {
        out.close();
      }
    } finally {
      in.close();
    }
  }
}
