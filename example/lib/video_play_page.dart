import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPage extends StatefulWidget {
  final String filePath;

  VideoPlayerPage(this.filePath);

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  VideoPlayerController playerController;

  @override
  void initState() {
    playerController = VideoPlayerController.file(File(widget.filePath))
      ..setLooping(true)
      ..initialize().then((_) {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    playerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: playerController.value.initialized
            ? AspectRatio(
                aspectRatio: playerController.value.aspectRatio,
                child: VideoPlayer(playerController),
              )
            : Container(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            playerController.value.isPlaying
                ? playerController.pause()
                : playerController.play();
          });
        },
        child: Icon(
          playerController.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
