import 'package:bodhiai_teacher_flutter/data_requests/requests.dart';
import 'package:bodhiai_teacher_flutter/pojo/basic.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class AddYoutubeVideo extends StatefulWidget{
  TeacherUser user = TeacherUser();
  AddYoutubeVideo(this.user);
  @override
  State<StatefulWidget> createState() {
    return _AddYoutubeVideo(user);
  }
}


class _AddYoutubeVideo extends State<AddYoutubeVideo>{
  TextEditingController urlController = TextEditingController();
  TextEditingController titleController = TextEditingController();

 int subjectId;
  int chapterId;
  String subjectText = 'Choose a subject';
  String chapterText = 'First choose a subject';
  bool callQuestions = false;
  List seletedQuestionsList = [];
  int selected = 0;
  double totalMarks = 0;
  Color selectedColor = Colors.white;
  List finalQuestionsList = [];
  TeacherUser user = TeacherUser();
  _AddYoutubeVideo(this.user);

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
  uploadYoutubeVideo(link,chapterId,title) async{
    
    var response = await uploadYoutubeVideoServer(widget.user.key, link,chapterId,title);
    return response;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Add Youtube Video'),),
    body: Container(child: Column(children: <Widget>[
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
 
      TextField(decoration: InputDecoration(hintText: 'Title of Video'),controller: titleController,),
      TextField(decoration: InputDecoration(hintText: 'Youtube Video Link'),controller: urlController,),
      ButtonTheme(minWidth: MediaQuery.of(context).size.width,child: RaisedButton(child: Text('Upload Video'), onPressed: () async{
        if(urlController.text == null || urlController.text == '' || titleController.text == null || titleController.text == ''){
          Fluttertoast.showToast(msg: 'Please enter title and url ');
        }
        else{
         var response = await uploadYoutubeVideo(urlController.text,chapterId,titleController.text);
         if(response['status']=='Success'){
           Fluttertoast.showToast(msg: response['message']);
           Navigator.pop(context);
         }
         else{
           Fluttertoast.showToast(msg: response['message']);
         }
 
        }

         
      },),)
    ],),), 
    
    );
  }

}