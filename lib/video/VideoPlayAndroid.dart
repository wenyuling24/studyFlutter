import 'package:flutter/material.dart';
import 'package:video_exo_plugin/flutter_simple_video_player.dart';

class VideoPlayAndriod extends StatefulWidget {
  final String url;

  VideoPlayAndriod(this.url);

  @override
  _VideoPlay createState() => _VideoPlay();
}

class _VideoPlay extends State<VideoPlayAndriod> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: SimpleVideoPlayer(
      widget.url,
      isLandscape: true,
      videoType: VideoType.net,
    )));
  }
}
