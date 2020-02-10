import 'package:aliyun_video_example/video_play_page.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:aliyun_video/aliyun_video.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<PermissionGroup> permissions = [
    PermissionGroup.camera,
    PermissionGroup.microphone,
    PermissionGroup.storage,
  ];

  bool hasPermissions = false;

  AliyunResult res;

  @override
  void initState() {
    super.initState();
    checkPermission();
  }

  Future<bool> checkPermission() async {
    List<PermissionGroup> p = [];
    if (await PermissionHandler().checkPermissionStatus(permissions[0]) !=
        PermissionStatus.granted) p.add(permissions[0]);

    if (await PermissionHandler().checkPermissionStatus(permissions[1]) !=
        PermissionStatus.granted) p.add(permissions[1]);
    if (await PermissionHandler().checkPermissionStatus(permissions[2]) !=
        PermissionStatus.granted) p.add(permissions[2]);

    if (p.length != 0) {
      await PermissionHandler().requestPermissions(p);
      return false;
    }
    hasPermissions = true;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Builder(
          builder: (context) => ListView(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            children: <Widget>[
              RaisedButton(
                onPressed: () async {
                  if (hasPermissions) {
                    AliyunVideo.startCamera(mCreateType: 0).then((res) {
                      this.res = res;
                    });
                  } else {
                    checkPermission();
                  }
                },
                child: Text('take'),
              ),
              RaisedButton(
                onPressed: () async {
                  if (res != null) {
                    if (res.fileType == 0) {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (_) => VideoPlayerPage(res.filePath)));
                    } else {
                      setState(() {});
                    }
                  }
                },
                child: Text('play'),
              ),
              if (res != null && res.fileType == 1)
                Container(
                  child: Image.file(
                    File(
                      res.filePath,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
