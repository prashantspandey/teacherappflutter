import 'package:bodhiai_teacher_flutter/pojo/basic.dart';
import 'package:bodhiai_teacher_flutter/screens/HomeScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bodhiai_teacher_flutter/data_requests/requests.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreateBatch extends StatefulWidget {
  TeacherUser user = TeacherUser();
  CreateBatch(this.user);
  @override
  State<StatefulWidget> createState() {
    return _CreateBatch(user);
  }
}

class _CreateBatch extends State<CreateBatch> {
  TeacherUser user = TeacherUser();
  TextEditingController batchNameController = TextEditingController();
  _CreateBatch(this.user);
showLoader(context){
  return showDialog(context: context,barrierDismissible: false,builder:(context){
    return AlertDialog(content: Container(height:100,child: Center(child: CircularProgressIndicator(),)),);
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Batch'),
        backgroundColor: Colors.black.withOpacity(0.95),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: TextField(
                controller: batchNameController,
                decoration: InputDecoration(hintText: 'Name of Batch'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                'Existing Batches: ',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                  future: getAllBatches(user.key),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.data != null) {
                      var batches = snapshot.data.batches;
                      print(batches[1].name);
                      return ListView.builder(
                        itemCount: batches.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: ListTile(
                              leading: Icon(Icons.class_),
                              title: Text(batches[index].name),
                              subtitle: Column(
                                children: <Widget>[
                                  Text('Click to add students'),
                                  Divider(
                                    color: Colors.orangeAccent,
                                  ),
                                ],
                              ),
                              onTap: () async {
                                showLoader(context);
                                var students = await getAllStudents(user.key);
                                Navigator.pop(context);
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AddStudentBatch(user,
                                          students.students, batches[index].id);
                                    });
                              },
                            ),
                          );
                        },
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ButtonTheme(
                minWidth: MediaQuery.of(context).size.width,
                child: RaisedButton(
                  color: Colors.black,
                  onPressed: () async {
                    var response = await teacherCreateBatch(
                        user.key, batchNameController.text);

                    Fluttertoast.showToast(msg: response['message']);
                  },
                  child: Text(
                    'Create Batch',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AddStudentBatch extends StatefulWidget {
  TeacherUser user = TeacherUser();
  var students;
  int batchId;

  AddStudentBatch(this.user, this.students, this.batchId);
  @override
  State<StatefulWidget> createState() {
    return _AddStudentBatch(user, students, batchId);
  }
}

class _AddStudentBatch extends State<AddStudentBatch> {
  TeacherUser user = TeacherUser();
  var students;
  int batchId;
  Map<int, bool> studentValues = {};
  _AddStudentBatch(this.user, this.students, this.batchId);
  studentCheckBox(batches) {
    setState(() {
      for (var student in students) {
        studentValues[student.id] = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    studentCheckBox(students);
  }

  @override
  Widget build(BuildContext context) {
    print('students list ${students.toString()}');
    return Dialog(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                child: Text(
              'Select Students to add to this batch',
              style: TextStyle(fontSize: 20),
            )),
          ),
          Divider(color: Colors.black),
          Expanded(
            child: Container(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ListTile(
                      title: Text(students[index].name),
                      leading: CachedNetworkImage(
        imageUrl: students[index].details['photo'],
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Image.asset('assets/user.png'),
     ), 
     subtitle: Container(
       height: 50,
       width: 30,
            child: ListView.builder(itemCount:students[index].batches.length, itemBuilder: (BuildContext context, int batchindex) {
         return Text(students[index].batches[batchindex].name);
       },),
     ),

                      trailing: Checkbox(
                        value: studentValues[students[index].id],
                        onChanged: (bool value) {
                          setState(() {
                            studentValues[students[index].id] = value;
                          });
                        },
                      ),
                      onTap: () {
                        setState(() {
                          //batches.add(batches[index].id);
                        });
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              color: Colors.black,
              onPressed: () async {
                List<int> studentsToAdd = [];
                for (var student in students) {
                  if (studentValues[student.id] == true) {
                    studentsToAdd.add(student.id);
                  }
                }
                if (studentsToAdd.length == 0) {
                  Fluttertoast.showToast(msg: 'No student added.');
                  Navigator.pop(context);
                } else {
                  var response = await teacherAddStudentsBatch(
                      user.key, batchId, studentsToAdd);
                  if (response['status'] == 'Success') {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeScreen(user)));
                    Fluttertoast.showToast(
                        msg: 'Students successfullly added !!');
                  } else {
                    Fluttertoast.showToast(
                        msg: 'Failed ! ' + response['message'].toString());
                  }
                }
              },
              child: Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
