import 'package:bodhiai_teacher_flutter/data_requests/requests.dart';
import 'package:bodhiai_teacher_flutter/pojo/basic.dart';
import 'package:bodhiai_teacher_flutter/screens/StudentList.dart';
import 'package:bodhiai_teacher_flutter/screens/SuccessDialogBox.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MarkAttendance extends StatefulWidget {
  TeacherUser user = TeacherUser();
  ListStudents students = ListStudents();
  var date;
  MarkAttendance(this.user, this.students, this.date);
  @override
  State<StatefulWidget> createState() {
    return _MarkAttendance(user, students, date);
  }
}

class _MarkAttendance extends State<MarkAttendance> {
  TeacherUser user = TeacherUser();
  ListStudents studentList = ListStudents();
  var date;
  _MarkAttendance(this.user, this.studentList, this.date);
  List<String> attLabels = ['P', 'AB', 'H', 'HD'];
  Map<String, String> attendance = {};
  callAlreadyAttendance(studentList) async {
    List<int> student_ids = [];
    for (var st in studentList.students) {
      student_ids.add(st.id);
    }
    var alreadyAttendance =
        await getAlreadyAttendance(user.key, date, student_ids);
    for (var at in alreadyAttendance['students_list']) {
      if (at['attendace_type'] != null) {
        attendance[at['student_id'].toString()] = at['attendance_type'];
      } else {
        attendance[at['student_id'].toString()] = null;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    //callAlreadyAttendance(studentList);
    for (var st in studentList.students) {
      attendance[st.id.toString()] = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size.height - 200;
    return Scaffold(
        appBar: AppBar(
          title: Text('Mark Attendance'),
          backgroundColor: Colors.black.withOpacity(0.95),
        ),
        body: Column(children: <Widget>[
          SingleChildScrollView(
            child: Container(
              height: screenSize,
              child: ListView.builder(
                itemCount: studentList.students.length,
                itemBuilder: (context, index) {
                  print(studentList.students[index]);
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 5,
                      child: ListTile(
                          leading: CachedNetworkImage(
        imageUrl: studentList.students[index].details['photo'],
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Image.asset('assets/user.png'),
     ), 

                          title: Text(
                            studentList.students[index].name,
                          ),
                          subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children:
                                  attLabels.asMap().entries.map((var att) {
                                return Column(
                                  children: <Widget>[
                                    Text(att.value),
                                    Radio(
                                      groupValue: attendance[studentList
                                          .students[index].id
                                          .toString()],
                                      value: att.value,
                                      onChanged: (newValue) {
                                        setState(() {
                                          attendance[studentList
                                              .students[index].id
                                              .toString()] = newValue;
                                        });
                                      },
                                    ),
                                  ],
                                );
                              }).toList())),
                    ),
                  );
                },
              ),
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ButtonTheme(
              minWidth: MediaQuery.of(context).size.width,
              child: RaisedButton(
                color: Colors.black,
                elevation: 5,
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  var response =
                      await submitAttendance(user.key, date, attendance);
                  if (response['status'] == 'Success') {
                    print('this is success');
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SuccessDialogBox(
                                'Attendace marked successfully',
                                MediaQuery.of(context).size.height,
                                MediaQuery.of(context).size.width)));
                  } else {
                    print(response['message']);
                    print('something failed');
                  }
                  print(attendance.toString());
                },
              ),
            ),
          )
        ]));
  }
}
