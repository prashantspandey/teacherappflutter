import 'dart:io';

import 'package:bodhiai_teacher_flutter/pojo/basic.dart';
import 'package:flutter/material.dart';
import 'package:bodhiai_teacher_flutter/data_requests/requests.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class UploadVideo extends StatefulWidget {
  TeacherUser user = TeacherUser();
  UploadVideo(this.user);
  @override
  State<StatefulWidget> createState() {
    return _UploadVideo(this.user);
  }
}

class _UploadVideo extends State<UploadVideo> {
  TeacherUser user = TeacherUser();
  _UploadVideo(this.user);
  String defaultSubject = 'General Video';
  int groupSub = -1;
  int groupChap = -1;
  bool chaptersVisible = false;
  File _image;
  bool uploadingProgress = true;
  final titleTextController = TextEditingController();
  bool buttonDisabled = true;
  String subjectStringDrop = 'Select Subject';
  String chapterStringDrop = 'Select Subject';
  static const aws_platform = const MethodChannel('s3integration');
  static const uploadStream = const EventChannel('uploadEvents');
  var _uploadInfo;
  double progressUp = 0;
  var finalState;
  int subjectId;
  int chapterId;
  String subjectText = 'Choose a subject';
  String chapterText = 'First choose a subject';

  showSubjectDialog(subjects) {
    return showDialog(
        context: context,
        builder: (context) {
          return Container(
            height: 300,
            width: 200,
            child: AlertDialog(
              title: Text('Subjects'),
              content: Container(
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  itemCount: subjects.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(subjects[index]['name']),
                      leading: Icon(Icons.border_outer),
                      onTap: () {
                        setState(() {
                          subjectId = subjects[index]['id'];
                          subjectText = subjects[index]['name'];
                          chapterText = 'Choose a chapter';
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              actions: <Widget>[
                RaisedButton(
                  child: Text(
                    'Close',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.black.withOpacity(0.95),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  showChapterDialog(chapters) {
    return showDialog(
        context: context,
        builder: (context) {
          return Container(
            height: 300,
            width: 200,
            child: AlertDialog(
              title: Text('Chapters'),
              content: Container(
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  itemCount: chapters.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(chapters[index]['name']),
                      leading: Icon(Icons.border_outer),
                      onTap: () {
                        setState(() {
                          chapterId = chapters[index]['id'];
                          chapterText = chapters[index]['name'];
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              actions: <Widget>[
                RaisedButton(
                  child: Text(
                    'Close',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.black.withOpacity(0.95),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }
 
  retrieveSubjects(key) async {
    var subjects = await getAllSubjects(key);
    return subjects;
  }

  retrieveChapters(key, subject) async {
    var chapters = await getSubjectChapters(key, subject);
    return chapters;
  }

  getImage() async {
    var image = await ImagePicker.pickVideo(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }
  uploadedTotalProgress(progressUpload){
    print('progress Upload ${progressUpload.toString()}');
      setState(() {
        progressUp = progressUpload;
      });
  }
  uploadImageS3(imagePath) async {
    // setState(() {
      // uploadingProgress = false;
    // });
    print(imagePath.path.toString());



    String title = titleTextController.text;
    String path = imagePath.path;
    String fileName = imagePath.path.toString().split('/').last.toString();
    try{
      var res = await aws_platform.invokeMethod('uploadFiles',{'path':path,'fileName':fileName});
      if(_uploadInfo == null){
        _uploadInfo = uploadStream.receiveBroadcastStream().listen(uploadedTotalProgress);
      }
    bool generalVideo = false;
    if(res['status']=='Success'){
      String finalUrl = res['url'];
    var response = postUploadVideo(
        user.key, title, subjectId, chapterId, finalUrl, generalVideo);
    print('response ${response.toString()}');

    }
    else{
      Fluttertoast.showToast(msg: 'Upload failed. Please try again.');
    }
   
    }
    on PlatformException catch(e){
      print('platform error ${e.toString()}');

    }

    // String uploadedImageUrl = await AmazonS3Cognito.upload(
        // imagePath.path,
        // 'instituteimages',
        // 'us-east-1:c5dd200c-3cfc-44da-a1e1-7a5fc1f4a6e8',
        // title + user.key.toString() + '.mp4',
        // AwsRegion.US_EAST_1,
        // AwsRegion.US_EAST_1);
    //print('uploaded url ${uploadedImageUrl.toString()}');

  }

  Widget ChaptersWidget(key, subject) {
    return FutureBuilder(
      future: retrieveChapters(key, subject),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.data != null) {
          List chaptersList = snapshot.data['chapters'];
          return Expanded(
            child: Card(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: chaptersList.asMap().entries.map((var chap) {
                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(chap.value['name']),
                        ),
                        Radio(
                          value: chap.value['id'],
                          groupValue: groupChap,
                          onChanged: (var val) {
                            setState(() {
                              groupChap = val;
                            });
                          },
                        )
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        }
        return SizedBox(
          height: 0,
        );
      },
    );
  }

  Widget UploaderProgress() {
    return Center(
      child: Container(
          height: 300,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Uploading Video ..',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Center(child: CircularProgressIndicator()),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: Text('Upload Video'), backgroundColor: Colors.green),
        body: uploadingProgress
            ? Column(
              children: <Widget>[
                                Padding(
              padding: const EdgeInsets.all(20.0),
              child: ButtonTheme(
            minWidth: MediaQuery.of(context).size.width,
            child: RaisedButton(
               shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
              ),
                color: Colors.lightBlue,
                onPressed: () async {
                  var subjectsResponse = await getAllSubjects(user.key);
                  var subjects = subjectsResponse['subjects'];
                  showSubjectDialog(subjects);
                },
                child: Text(
                  subjectText,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ButtonTheme(
            minWidth: MediaQuery.of(context).size.width,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
              ),
                color: Colors.lightBlue,
                onPressed: () async {
                  if (subjectId == null) {
                    var subjectsResponse = await getAllSubjects(user.key);
                    var subjects = subjectsResponse['subjects'];
                    showSubjectDialog(subjects);
                  } else {
                    var chaptersResponse =
                        await getSubjectChapters(user.key, subjectId);
                    var chapters = chaptersResponse['chapters'];
                    showChapterDialog(chapters);
                  }
                },
                child: Text(
                  chapterText,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )),
              ),
            ),
 
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: TextField(decoration: InputDecoration(hintText: 'Title of Video'),controller: titleTextController,),
      ),
      Spacer(),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: ButtonTheme(minWidth: MediaQuery.of(context).size.width,child: RaisedButton(child: Text('Upload Video'), onPressed: () async{
          if( titleTextController.text == null || titleTextController.text == ''){
            Fluttertoast.showToast(msg: 'Please enter title');
          }
          else{
            selectImageCall();
 
          }
           
        },),),

      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LinearProgressIndicator(value: progressUp/100,backgroundColor: Colors.black,valueColor: AlwaysStoppedAnimation<Color> (Colors.orange),),
                    ),
                    Text('Uploaded:'+progressUp.toStringAsFixed(2)+' %'),



             ],
            )
            : UploaderProgress());
  }

  void selectImageCall() async {
    await getImage();
    uploadImageS3(_image);
  }
}
