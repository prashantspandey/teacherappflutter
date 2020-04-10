import 'package:bodhiai_teacher_flutter/pojo/basic.dart';
import 'package:flutter/material.dart';


class PackageAddVideo extends StatefulWidget{
  TeacherUser user = TeacherUser();
  int packageId;
  PackageAddVideo(this.user,this.packageId);
  @override
  State<StatefulWidget> createState() {
    return _PackageAddVideo();
  }

}


class _PackageAddVideo extends State<PackageAddVideo>{
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text('Video in Package'),),
      body: Column(children: <Widget>[
        Text('hello'),
      ],),
    );
  }

}