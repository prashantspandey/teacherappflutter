import 'package:bodhiai_teacher_flutter/data_requests/requests.dart';
import 'package:bodhiai_teacher_flutter/pojo/basic.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddSubjects extends StatefulWidget {
  TeacherUser user = TeacherUser();
  AddSubjects(this.user);
  @override
  State<StatefulWidget> createState() {
    return _AddSubjects();
  }
}

class _AddSubjects extends State<AddSubjects> {
  TextEditingController subjectName = TextEditingController();
  bool cancel;
  showDeleteDialog(context, subjectId) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 200,
              child: Column(
                children: <Widget>[
                  Text('Are you sure you want to delete this subject?',
                      style: TextStyle(fontSize: 20)),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RaisedButton(
                        color: Colors.black,
                        child: Text('Delete',
                            style: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          var response = await postDeleteSubject(
                              widget.user.key, subjectId);
                          Fluttertoast.showToast(msg: response['message']);
                          Navigator.pop(context);
                        },
                      ),
                      RaisedButton(
                        color: Colors.white,
                        child: Text('Cancel',
                            style: TextStyle(color: Colors.black)),
                        onPressed: () {
                          setState(() {
                            cancel = true;
                          });
                          Navigator.pop(context);
                        },
                      )
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
        title: Text('Add Subjects'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: subjectName,
                decoration: InputDecoration(hintText: 'Subject Name'),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: getAllSubjects(widget.user.key),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data != null) {
                    var subjects = snapshot.data['subjects'];
                    return ListView.builder(
                      itemCount: subjects.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(
                            subjects[index]['name'],
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          leading: Image.asset('assets/test.png'),
                          subtitle: Divider(
                            color: Colors.orangeAccent,
                          ),
                          onLongPress: () async {
                            showDeleteDialog(context, subjects[index]['id'])
                                .then((_) => setState(() {}));

                            // getAllSubjects(widget.user.key);
                            //Navigator.pop(context);
                          },
                        );
                      },
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ButtonTheme(
                minWidth: MediaQuery.of(context).size.width - 50,
                child: RaisedButton(
                  color: Colors.black,
                  child: Text('Add Subject',
                      style: TextStyle(
                        color: Colors.white,
                      )),
                  onPressed: () async {
                    if (subjectName.text == null || subjectName.text == '') {
                      Fluttertoast.showToast(msg: "Please enter subject name.");
                    } else {
                      var response = await postAddSubject(
                          widget.user.key, subjectName.text);
                      if (response['status'] == 'Success') {
                        Fluttertoast.showToast(msg: response['message'])
                            .then((_) => setState(() {}));
                        //Navigator.pop(context);
                      } else {
                        Fluttertoast.showToast(msg: response['message']);
                        Navigator.pop(context);
                      }
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
