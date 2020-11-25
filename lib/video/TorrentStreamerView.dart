import 'package:flutter_torrent_streamer/flutter_torrent_streamer.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TorrentStreamerView extends StatefulWidget {
  final String url;

  TorrentStreamerView(this.url);

  @override
  _TorrentStreamerViewState createState() => _TorrentStreamerViewState(url);
}

class _TorrentStreamerViewState extends State<TorrentStreamerView> {
  bool isStreamReady = false;
  int progress = 0;

  final String url;

  _TorrentStreamerViewState(this.url);

  @override
  void initState() {
    super.initState();
    print("播放:$url");
    _addTorrentListeners();
    _startDownload();
  }

  @override
  void dispose() {
    TorrentStreamer.stop();
    TorrentStreamer.removeEventListeners();
    super.dispose();
  }

  void _addTorrentListeners() {
    TorrentStreamer.addEventListener('progress', (data) {
      setState(() => progress = data['progress']);
    });

    TorrentStreamer.addEventListener('ready', (_) {
      setState(() => isStreamReady = true);
    });
  }

  Future<void> _startDownload() async {
    await TorrentStreamer.stop();
    await TorrentStreamer.start(url);
  }

  Future<void> _openVideo(BuildContext context) async {
    if (progress == 100) {
      await TorrentStreamer.launchVideo();
    } else {
      showDialog(
          builder: (BuildContext context) {
            return AlertDialog(
                title: new Text('Are You Sure?'),
                content: new Text(
                    'Playing video while it is still downloading is experimental and only works on limited set of apps.'),
                actions: <Widget>[
                  FlatButton(
                      child: new Text("Cancel"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                  FlatButton(
                      child: new Text("Yes, Proceed"),
                      onPressed: () async {
                        await TorrentStreamer.launchVideo();
                        Navigator.of(context).pop();
                      })
                ]);
          },
          context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
            children: <Widget>[
              RaisedButton(
                  child: Text('Start Download'),
                  onPressed: ()
                      // _startDownload
                      async {
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  }),
              Container(height: 8),
              RaisedButton(
                  child: Text('Play Video'),
                  onPressed: () => _openVideo(context))
            ],
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max),
        padding: EdgeInsets.all(16));
  }
}
