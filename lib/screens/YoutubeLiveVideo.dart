import 'package:bodhiai_teacher_flutter/data_requests/requests.dart';
import 'package:bodhiai_teacher_flutter/pojo/basic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class YoutubeLiveVideo extends StatefulWidget {
  TeacherUser user = TeacherUser();
  YoutubeLiveVideo(this.user);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _YoutubeLiveVideo();
  }
}

class _YoutubeLiveVideo extends State<YoutubeLiveVideo> {
  static const platform = const MethodChannel('youtube');
  var _youtubeStart;
  static String key = 'AIzaSyDOW6Nt-1jpzxcEbypSpJ-ObCsZHjYBjPA';

  TextEditingController urlController = TextEditingController();
  canVideoStart() async {
    var youtubeStart;
    try {
      var res = await platform.invokeMethod('canStartStream');
      youtubeStart = res.toString();
    } on PlatformException catch (e) {
      youtubeStart = e.toString();
    }
    setState(() {
      _youtubeStart = youtubeStart;
    });
  }
  showLoadingDialog(context){
    return showDialog(context: context,
    barrierDismissible: false,
    builder: (context){
      return AlertDialog(content: Center(child:CircularProgressIndicator()),);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('YouTube Live'),
        backgroundColor: Colors.red
      ),
      body: Container(
        child: Column(
          children: <Widget>[

            Spacer(),
            TextField(controller:urlController,decoration: InputDecoration(hintText: 'Live Video URL'),),
            RaisedButton(
             child: Text('Send Notification'), 
              onPressed: () async {
                showLoadingDialog(context);
                  String url = urlController.text;
                  var response = await publishLiveVideoLink(widget.user.key, url);
                  if(response['status']=='Success'){
                    Fluttertoast.showToast(msg: 'Video Link shared successfully');
                    Navigator.pop(context);
                  }
                  else{
                    Fluttertoast.showToast(msg: 'Error - ${response['message'].toString()}');
                    Navigator.pop(context);
                  }
            },),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ButtonTheme(
                minWidth: MediaQuery.of(context).size.width,
                            child: RaisedButton(
                              color: Colors.red,
                  child: Text('Go Live',style: TextStyle(fontSize: 20,color: Colors.white)),
                  onPressed: () {
                    canVideoStart();
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
