import 'package:bodhiai_teacher_flutter/pojo/basic.dart';
import 'package:bodhiai_teacher_flutter/data_requests/requests.dart';
import 'package:bodhiai_teacher_flutter/screens/EditCourses.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class CreateCourse extends StatefulWidget {
  TeacherUser user  = TeacherUser();
  CreateCourse(this.user);
  @override
  _CreateCourseState createState() => _CreateCourseState();
}

class _CreateCourseState extends State<CreateCourse> {
  TextEditingController courseName = TextEditingController();
  bool cancel = false;

  showDeleteDialog(context, courseId) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 500,
              child: Column(
                children: <Widget>[
                  Text('Are you sure you want to delete this course?',
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
                          var response = await deleteCourse(
                              widget.user.key, courseId);
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
      appBar: AppBar(title: Text('Create Course'),backgroundColor: Colors.pink,),
      body: Container(child: Column(children: <Widget>[
                      Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: courseName,
                decoration: InputDecoration(hintText: 'Course Name'),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: getAllCourses(widget.user.key),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data != null) {
                    var courses = snapshot.data['courses'];
                    return ListView.builder(
                      itemCount: courses.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(
                            courses[index]['name'],
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          leading: Image.asset('assets/test.png'),
                          subtitle: Divider(
                            color: Colors.orangeAccent,
                          ),
                          onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditCourse(widget.user,courses[index]['id'])));

                          },
                          onLongPress: () async {
                            showDeleteDialog(context, courses[index]['id'])
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
                  child: Text('Add Course',
                      style: TextStyle(
                        color: Colors.white,
                      )),
                  onPressed: () async {
                    if (courseName.text == null || courseName.text == '') {
                      Fluttertoast.showToast(msg: "Please enter course name.");
                    } else {
                      var response = await courseCreate(
                          widget.user.key, courseName.text);
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

      ],),), 
    );
  }
}