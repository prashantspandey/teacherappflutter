import 'package:bodhiai_teacher_flutter/data_requests/requests.dart';
import 'package:bodhiai_teacher_flutter/pojo/basic.dart';
import 'package:bodhiai_teacher_flutter/screens/CheweiList.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SingleVideoPlayer extends StatefulWidget {
  String title;
  String link;
  SingleVideoPlayer(this.title, this.link);
  @override
  State<StatefulWidget> createState() {
    return _SingleVideoPlayer(title, link);
  }
}

class _SingleVideoPlayer extends State<SingleVideoPlayer> {
  String title;
  String link;
  _SingleVideoPlayer(this.title, this.link);
  @override
  Widget build(BuildContext context) {
    print('link single video ${link.toString()}');
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          backgroundColor: Colors.green
        ),
        body:
            Container(child: CheweiList(link.replaceAll("\"", ''))));
  }
}
