

import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:flutter/material.dart';

class VideoApp extends StatefulWidget {

  final String url;
  VideoApp(this.url);

  @override
  _VideoAppState createState() => _VideoAppState(url);

}

class _VideoAppState extends State<VideoApp> {
  IjkMediaController _controller;

  final String url;
  _VideoAppState(this.url);

  @override
  void initState() {
    super.initState();
    print("播放:$url");
    _controller = IjkMediaController();
    _controller.setNetworkDataSource(url,autoPlay: true);

      // ..initialize().then((_) {
      //   // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      //   setState(() {
      //     _controller.play();
      //   });
      // });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        body: Center(
          child: _controller.autoRotate
              ? AspectRatio(
            aspectRatio: _controller.videoInfo.ratio,
            child: IjkPlayer(mediaController: _controller),
          )
              : Container(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Icon(
            _controller.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

