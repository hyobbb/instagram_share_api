import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:instagram_share_api/instagram_share_api.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_share_api_example/recording.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _platformVersion = 'Unknown';
  String _result = '';
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await InstagramShareApi.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Running on: $_platformVersion\n'),
            Text('$_result'),
            TextButton(
              onPressed: () async {
                try {
                  var path = await _imagePicker
                      .getImage(source: ImageSource.gallery)
                      .then((value) => value?.path);
                  if (path != null) {
                    await InstagramShareApi.sharePhotoStory(path);
                  } else {
                    setState(() {
                      _result = 'Source is not selected!';
                    });
                  }
                } on PlatformException catch (e) {
                  setState(() {
                    _result = e.message;
                  });
                }
              },
              child: Text('Select Photo'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  var path = await _imagePicker
                      .getVideo(source: ImageSource.gallery)
                      .then((value) => value?.path);
                  if (path != null) {
                    await InstagramShareApi.shareVideoStory(path);
                  } else {
                    setState(() {
                      _result = 'Source is not selected!';
                    });
                  }
                } on PlatformException catch (e) {
                  setState(() {
                    _result = e.message;
                  });
                }
              },
              child: Text('Select Video'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  var path = await _imagePicker
                      .getVideo(source: ImageSource.gallery)
                      .then((value) => value.path);
                  if (path != null) {
                    InstagramShareApi.shareVideoFeed(path);
                  }
                } on PlatformException catch (e) {
                  setState(() {
                    _result = e.message;
                  });
                }
              },
              child: Text('Feed Video From Album'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  var cameras = await availableCameras();
                  var path = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              TakePictureScreen(camera: cameras.first)));
                  if (path != null) {
                    InstagramShareApi.shareVideoFeed(path);
                  }
                } on PlatformException catch (e) {
                  setState(() {
                    _result = e.message;
                  });
                }
              },
              child: Text('Feed Video Recording'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  var path = await _imagePicker
                      .getImage(source: ImageSource.gallery)
                      .then((value) => value.path);
                  if (path != null) {
                    InstagramShareApi.sharePhotoFeed(path);
                  }
                } on PlatformException catch (e) {
                  setState(() {
                    _result = e.message;
                  });
                }
              },
              child: Text('Feed Photo'),
            ),
          ],
        ),
      ),
    );
  }
}
