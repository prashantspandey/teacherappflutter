import 'dart:io';
import 'dart:math';
import 'package:bodhiai_teacher_flutter/data_requests/requests.dart';
import 'package:bodhiai_teacher_flutter/pojo/basic.dart';
import 'package:bodhiai_teacher_flutter/screens/ContentScreen.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfWidget;
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as imgs;

class UploadNotes extends StatefulWidget {
  TeacherUser user = TeacherUser();
  UploadNotes(this.user);
  @override
  State<StatefulWidget> createState() {
    return _UploadNotes(user);
  }
}

class _UploadNotes extends State<UploadNotes> {
  TeacherUser user = TeacherUser();
  _UploadNotes(this.user);
  TextEditingController titleTextController = TextEditingController();
  int groupSub = -1;
  int groupChap = -1;
  bool chaptersVisible = false;
  List<File> _files;
  bool uploadingProgress = true;
  pdfWidget.Document pdf = pdfWidget.Document();
  bool buttonDisabled = true;
  static const aws_platform = const MethodChannel('s3integration');
  String subjectText = 'Choose a subject';
  String chapterText = 'First choose a subject';
  int subjectId;
  int chapterId;
  var batchValues = [];


@override
initState(){
  super.initState();
  getBatch();
}
getBatch() async{
  if (batchValues.length == 0){
  var response = await getAllBatches(user.key);
  var batches = response;
  for(var batch in batches.batches){
    var batchVal = {'id':batch.id,'name':batch.name,'value':false};
  setState(() {
    
    batchValues.add(batchVal);
  });    
  }

  }
}
showSubjectDialog(subjects) {
    return showDialog(
        context: context,
        builder: (context) {
          return Container(
            height: 500,
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
            height: 500,
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


showLoadingDialog(context){
  return showDialog(context: context,barrierDismissible: false,builder:(context){
    return AlertDialog(content: Container(height:100,child: Center(child: CircularProgressIndicator(),)),);
  });
}
  getImage() async {
    List<File> files = await FilePicker.getMultiFile();
    setState(() {
      _files = files;
      for (var fi in _files){
        print('file in getimage ${fi.toString()}');
      }
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

  uploadImageS3(imagePath) async {
    setState(() {
      uploadingProgress = false;
    });
    print(imagePath.path.toString());
    String baseBucketUrl = 'https://instituteimages.s3.amazonaws.com';

    String title = titleTextController.text;
  Random random = new Random();
  int randomNumber = random.nextInt(9999999);
  String username = user.username;

     String path = imagePath.path;
    String fileName = username+'/${randomNumber.toString()}/'+imagePath.path.toString().split('/').last.toString();
    //String fileName = path;
    try{
      print('uplaod in res');
      //showLoadingDialog(context);
      var res = await aws_platform.invokeMethod('uploadFiles',{'path':path,'fileName':fileName});
      print('res s3 upload ${res.toString()}');
    //bool generalVideo = false;
//    String finalUrl = baseBucketUrl + title + user.key.toString() + '.mp4';
    if(res['status']=='Success'){
      String finalUrl = res['url'];
      print('final url ${res["url"].toString()}');
    // var response = postUploadVideo(
    //     user.key, title, groupSub, groupChap, finalUrl, generalVideo);

    //print('total response ${response.toString()}');
    //Navigator.pop(context);
    return finalUrl;
    }
    else{
      Fluttertoast.showToast(msg: 'Upload failed. Please try again.');
    }
    }
    on PlatformException catch(e){

    }
    // String uploadedImageUrl = await AmazonS3Cognito.upload(
        // imagePath.path,
        // 'instituteimages',
        // 'us-east-1:c5dd200c-3cfc-44da-a1e1-7a5fc1f4a6e8',
        // title +user.key.toString()+'.pdf',
        // AwsRegion.US_EAST_1,
        // AwsRegion.US_EAST_1);
    // print('uploaded url ${uploadedImageUrl.toString()}');

    setState(() {
      uploadingProgress = true;
    });
    return '';
    //Navigator.pop(context);
  }

  Widget ChaptersWidget(key, subject) {
    print('subject ${subject.toString()}');
    return FutureBuilder(
      future: retrieveChapters(key, subject),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.data != null) {
          List chaptersList = snapshot.data['chapters'];
          print('chapters list ${chaptersList.toString()}');
          return Row(
            children: chaptersList.asMap().entries.map((var chap) {
              return Column(
                children: <Widget>[
                  Text(chap.value['name']),
                  Radio(
                    value: chap.value['id'],
                    groupValue: groupChap,
                    onChanged: (var val) {
                      setState(() {
                        groupChap = val;
                        print(groupChap);
                      });
                    },
                  )
                ],
              );
            }).toList(),
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
                  'Uploading Note ..',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              CircularProgressIndicator(),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Notes'),
        backgroundColor: Colors.black.withOpacity(0.95),
      ),
      body: Column(
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
        child: TextField(decoration: InputDecoration(hintText: 'Title of Note'),controller: titleTextController,),
      ),
        Text('Select Batches ',style: TextStyle(fontSize:15)),
                   Expanded(
                                        child: ListView.builder(itemCount:batchValues.length, itemBuilder: (BuildContext context, int index) {
                      return CheckboxListTile(title:Text(batchValues[index]['name']),value:batchValues[index]['value'] ,
                      onChanged: (bool value) {
                        setState(() {
                          batchValues[index]['value'] = value;
                        });
                      },);
                  },),
                   ),

      Spacer(),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ButtonTheme(
              minWidth: MediaQuery.of(context).size.width,
              child: RaisedButton(
                color: Colors.black,
                onPressed: () async {
                  bool isPDF = false;
                  showLoadingDialog(context);
                  List fileDetails = [];
                  await getImage(); // get selected files in _files
                    File fileSave;
                  for (File f in _files) {
                    var extention = f.path.split(".").last;
                    if (extention == "pdf"){
                      isPDF = true;
                        fileSave = f; 
                        break;
                    }
                    else{

                    // this function creates a pdf of list of images selected
                    final img = imgs.decodeImage(f.readAsBytesSync());
                    final pdfImage = PdfImage(pdf.document,
                        image: img.data.buffer.asUint8List(),
                        height: img.height,
                        width: img.width);
                    pdf.addPage(
                        pdfWidget.Page(build: (pdfWidget.Context context) {
                      return pdfWidget.Center(
                        child: pdfWidget.Image(pdfImage),
                      );
                    }));
                    print('images successfully converted to pdf');
                    }

                  }
                                     // pdf is also saved to the device
                  var pdfUrl;
                  if(isPDF == true){
                    print('file is pdf');
                  pdfUrl = await uploadImageS3(fileSave);
                  }
                  else{
                  Directory tempDir = await getTemporaryDirectory();
                  fileSave = File(tempDir.path + '/notes.pdf');
                  await fileSave.writeAsBytes(pdf.save());
                  pdfUrl = await uploadImageS3(fileSave);
                  print('pdf url before post request ${pdfUrl.toString()}');

                  }
                  // a list of uploaded url is required by backend api
                  var gg = [pdfUrl];
                  var finalBatches = [];
                  for (var bat in batchValues){
                    if(bat['value']==true){
                      finalBatches.add(bat['id']);
                    }
                  }
                  var response = await postUploadNotes(user.key,
                      titleTextController.text, subjectId, chapterId, gg,finalBatches);
                  // if call is successfull then page is closed
                  //todo show a dialog box too
                  if (response['status'] == 'Success') {
                    Fluttertoast.showToast(msg: 'Note successfully uploaded.');
                    Navigator.pop(context);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ContentScreen(user)));

                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Select Images/PDFs',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
