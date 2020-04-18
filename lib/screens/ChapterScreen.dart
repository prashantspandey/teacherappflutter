import 'package:bodhiai_teacher_flutter/data_requests/requests.dart';
import 'package:bodhiai_teacher_flutter/pojo/basic.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class ChaptersScreen extends StatefulWidget {
  TeacherUser user = TeacherUser();
  int subjectId;
  ChaptersScreen(this.user, this.subjectId);
  @override
  State<StatefulWidget> createState() {
    return _ChaptersScreen(user, subjectId);
  }
}
class _ChaptersScreen extends State<ChaptersScreen> {
  TeacherUser user = TeacherUser();
  int subjectId;
  _ChaptersScreen(this.user, this.subjectId);
  bool cancel;
  TextEditingController chapterName = TextEditingController();
  addChaptersDialog(context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Do you want to add chapter?"),
                  ),
                  TextField(
                      controller: chapterName,
                      decoration: InputDecoration(
                          hintText: "Please enter chapter name")),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                        color: Colors.white,
                        child:
                            Text('Cancel', style: TextStyle(color: Colors.red)),
                        onPressed: () {
                          setState(() {
                            cancel = true;
                          });
                          Navigator.pop(context);
                        },
                      ),
                      RaisedButton(
                        color: Colors.green,
                        child: Text('Add chapter',
                            style: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          if (chapterName.text == null ||
                              chapterName.text == "") {
                            Fluttertoast.showToast(
                                msg: "Please enter chapter name.");
                          } else {
                            var response = await postAddChapters(
                                widget.user.key, subjectId, chapterName.text);
                            if (response['status'] == 'Success') {
                              Fluttertoast.showToast(msg: response['message']);
                              Navigator.pop(context);
                            } 
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
  chapterDeleteDialog(context, chapterId, chaptername) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Column(
                children: <Widget>[
                  Text('Are you sure you want to delete this chapter? $chaptername',
                      style: TextStyle(fontSize: 20)),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RaisedButton(
                        color: Colors.white,
                        child:
                            Text('Cancel', style: TextStyle(color: Colors.red)),
                        onPressed: () async {
                          setState(() {
                            cancel = true;
                            Navigator.pop(context);
                          });
                        },
                      ),
                      RaisedButton(
                        color: Colors.green,
                        child: Text('Delete',
                            style: TextStyle(color: Colors.white)),
                        onPressed: ()  async {
                          var response = await postDeleteChapter(widget.user.key, chapterId);
                             Fluttertoast.showToast(msg: response['message']);
                          Navigator.pop(context);
                        }
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
  showEditDialog(context, chapterId, chaptername) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Column(
                children: <Widget>[
                  Text(chaptername),
                  TextField(
                      controller: chapterName,
                      decoration: InputDecoration(hintText: "")),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RaisedButton(
                        color: Colors.white,
                        child:
                            Text('Cancel', style: TextStyle(color: Colors.red)),
                        onPressed: () {
                          setState(() {
                            cancel = true;
                          });
                          Navigator.pop(context);
                        },
                      ),
                      RaisedButton(
                        color: Colors.green,
                        child: Text("Update chapter",
                            style: TextStyle(color: Colors.white)),
                        onPressed: () async {},
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chapters'),
        backgroundColor: Colors.green,
        actions: <Widget>[
          Center(
            child: IconButton(
              icon: Icon(
                Icons.add_box,
                color: Colors.white,
              ),
              onPressed: () {
                addChaptersDialog(context)
                                  .then((_) => setState(() {}));
              },
            ),
          )
        ],
      ),
      body: Container(
          child: Column(
        children: <Widget>[
          Expanded(
            child: FutureBuilder(
              future: getSubjectChapters(user.key, subjectId),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.data != null) {
                  var chapters = snapshot.data['chapters'];
                  return ListView.builder(
                    itemCount: chapters.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(
                          chapters[index]['name'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Divider(
                          color: Colors.green,
                        ),
                        leading: Image.asset(
                          'assets/book.png',
                          height: MediaQuery.of(context).size.height * 0.04,
                        ),
                        trailing: GestureDetector(
                            onTap: () async {
                              showEditDialog(context, chapters[index]["id"],
                                  chapters[index]['name']);
                            },
                            child: Icon(
                              Icons.edit,
                              color: Colors.green,
                            )),
                        onLongPress: () {
                          chapterDeleteDialog(context, chapters[index]['id'],chapters[index]['name'])
                                  .then((_) => setState(() {}));
                        },
                      );
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      )),
    );
  }
}