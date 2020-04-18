import 'package:bodhiai_teacher_flutter/data_requests/requests.dart';
import 'package:bodhiai_teacher_flutter/pojo/basic.dart';
import 'package:bodhiai_teacher_flutter/screens/CheweiList.dart';
import 'package:bodhiai_teacher_flutter/screens/NativeVideoWebView.dart';
import 'package:bodhiai_teacher_flutter/screens/NoteWebView.dart';
import 'package:bodhiai_teacher_flutter/screens/SingleVideoPlayer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:video_player/video_player.dart';

class SeeVideos extends StatefulWidget {
  TeacherUser user = TeacherUser();
  var videos;
  SeeVideos(this.user, this.videos);
  @override
  State<StatefulWidget> createState() {
    return _SeeVideos(user, this.videos);
  }
}

class _SeeVideos extends State<SeeVideos> {
  TeacherUser user = TeacherUser();
  var videos;
  _SeeVideos(this.user, this.videos);
  showDeleteDialog(context,videoId){
    return showDialog(context: context,barrierDismissible: false,builder:(context){
      return AlertDialog(content: Container(height: 500,child: Column(children: <Widget>[
        Text('Are you sure you want to delete this video?',style: TextStyle(fontSize:20)),
        Spacer(),
        Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween, 
          children: <Widget>[
          RaisedButton(color: Colors.black,child: Text('Delete',style:TextStyle(color: Colors.white)), onPressed: ()async {
            var response = await postDeleteVideo(user.key, videoId);
            Fluttertoast.showToast(msg: response['message']);
            Navigator.pop(context);
          },),
          RaisedButton(color: Colors.white,child: Text('Cancel',style:TextStyle(color: Colors.black)), onPressed: () {Navigator.pop(context);},)
        ],)
      ],),),);
    });
  }
  @override
  Widget build(BuildContext context) {
    print(videos.toString());
    return Scaffold(
        appBar: AppBar(
          title: Text('Uploaded Videos'),
          backgroundColor: Colors.green
        ),
        body: ListView.builder(
            itemCount: videos.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Container(
                      // color: Colors.red,
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 100),
                      height: 50,
                      width: 50,
                      child: Image(
                        image: AssetImage("assets/music.png"),
                      )),
                title: Padding(
                  padding: const EdgeInsets.symmetric(vertical:8.0),
                  child: Text(videos[index]['title'],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                ),
                subtitle: Text(videos[index]['subject']+'('+videos[index]['chapter']+')',style: TextStyle(fontWeight: FontWeight.bold),),
                trailing: Text(videos[index]['publishDate'].split('T')[0].toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                
                onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NoteWebView(videos[index]['url'])));

                        // Navigator.push(
                            // context,
                            // MaterialPageRoute(
                                // builder: (context) => SingleVideoPlayer(videos[index]['title'],videos[index]['url'])));

                },
                onLongPress: ()async{
                    await showDeleteDialog(context, videos[index]['id']).then((_)=>setState((){}));
                    Navigator.pop(context);
                },
              );
            }));
  }
}
