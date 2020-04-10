import 'package:bodhiai_teacher_flutter/data_requests/requests.dart';
import 'package:bodhiai_teacher_flutter/pojo/basic.dart';
import 'package:bodhiai_teacher_flutter/screens/AttendanceOptions.dart';
import 'package:bodhiai_teacher_flutter/screens/BatchsListScreen.dart';
import 'package:bodhiai_teacher_flutter/screens/CreateBatch.dart';
import 'package:bodhiai_teacher_flutter/screens/EditBatch.dart';
import 'package:bodhiai_teacher_flutter/screens/FeesScreen.dart';
import 'package:bodhiai_teacher_flutter/screens/StudentList.dart';
import 'package:flutter/material.dart';

class ManagementScreen extends StatelessWidget {
  TeacherUser user = TeacherUser();
  ManagementScreen(this.user);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
              child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ClipPath(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.pink,
                        //     image: DecorationImage(
                        //   image: AssetImage("assets/background4.jpg"),
                        //   fit: BoxFit.fill,
                        // )
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ListTile(
                              title: Text(
                                "Management",
                                style:
                                    TextStyle(color: Colors.white, fontSize: 30),
                              ),
                              trailing: Container(
                                height: MediaQuery.of(context).size.height*0.05,
                                width: MediaQuery.of(context).size.width*0.1,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                  image: AssetImage("assets/coins.png"),
                                  fit: BoxFit.fill,
                                )),
                              )),
                        ],
                      ),
                      height: MediaQuery.of(context).size.height * 0.17,
                      width: MediaQuery.of(context).size.width,
                      // color: Colors.pink,
                    ),
                    clipper: MyClipper(),
                  ),

                  Container(
                    margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 30,
                        right: MediaQuery.of(context).size.width / 30),
                    child: ListTile(
                      title: Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 30),
                        // color: Colors.pink,
                        child: Text(
                          'All Students',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      leading: Container(
                          // color: Colors.red,
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 100),
                          height: MediaQuery.of(context).size.height*0.07,
                          // width: 50,
                          child: Image(
                            image: AssetImage("assets/reader.png"),
                          )),
                      subtitle: Container(
                          // color: Colors.red,
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 30),
                          child: Divider(height: 20, color: Colors.pink)),
                      onTap: () async {
                        ListStudents students = ListStudents();
                        students = await getAllStudents(user.key);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StudentList(
                                      students,
                                    )));
                      },
                    ),
                  ),

                  // Divider(height: 20, color: Colors.blue),

                  Container(
                    margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 30,
                        right: MediaQuery.of(context).size.width / 30),
                    child: ListTile(
                      title: Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 30),
                        child: Text(
                          'Batches',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      leading: Container(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 100),
                           height: MediaQuery.of(context).size.height*0.06,
                          // width: 50,
                          child: Image(
                            image: AssetImage("assets/class1.png"),
                          )),
                      subtitle: Container(
                          // color: Colors.red,
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 30),
                          child: Divider(height: 20, color: Colors.pink)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    BatchListScreen(user, null)));
                      },
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 30,
                        right: MediaQuery.of(context).size.width / 30),
                    child: ListTile(
                      title: Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 30),
                        child: Text(
                          'Attendance',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      leading: Container(
                          // color: Colors.red,
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 100),
                          height: MediaQuery.of(context).size.height*0.06,
                          // width: 50,
                          child: Image(
                            image: AssetImage("assets/class2.png"),
                          )),
                      subtitle: Container(
                          // color: Colors.red,
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 30),
                          child: Divider(height: 20, color: Colors.pink)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AttendanceOptions(user)));
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 30,
                        right: MediaQuery.of(context).size.width / 30),
                    child: ListTile(
                      title: Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 30),
                        child: Text(
                          'Fees Management',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      leading: Container(
                          // color: Colors.red,
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 100),
                          height: MediaQuery.of(context).size.height*0.06,
                          // width: 50,
                          child: Image(
                            image: AssetImage("assets/rupees.png"),
                          )),
                      subtitle: Container(
                          // color: Colors.red,
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 30),
                          child: Divider(height: 20, color: Colors.pink)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FeesScreen(user)));
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 30,
                        right: MediaQuery.of(context).size.width / 30),
                    child: ListTile(
                      title: Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 30),
                        child: Text(
                          'Create Batch',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      leading: Container(
                          // color: Colors.red,
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 100),
                          height: MediaQuery.of(context).size.height*0.06,
                          // width: 50,
                          child: Image(
                            image: AssetImage("assets/workshop.png"),
                          )),
                      subtitle: Container(
                          // color: Colors.red,
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 30),
                          child: Divider(height: 20, color: Colors.pink)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateBatch(user)));
                      },
                    ),
                  ),
                  // Container(
                  //   margin: EdgeInsets.only(
                  //       left: MediaQuery.of(context).size.width / 30,
                  //       right: MediaQuery.of(context).size.width / 30),
                  //   child: ListTile(
                  //     title: Container(
                  //       margin: EdgeInsets.only(
                  //           top: MediaQuery.of(context).size.height / 30),
                  //       child: Text(
                  //         'Edit Batch',
                  //         style: TextStyle(
                  //             fontWeight: FontWeight.bold, fontSize: 18),
                  //       ),
                  //     ),
                  //     leading: Container(
                  //         // color: Colors.red,
                  //         padding: EdgeInsets.only(
                  //             top: MediaQuery.of(context).size.height / 100),
                  //         height: MediaQuery.of(context).size.height*0.06,
                  //         // width: 50,
                  //         child: Image(
                  //           image: AssetImage("assets/hand.png"),
                  //         )),
                  //     subtitle: Container(
                  //         // color: Colors.red,
                  //         margin: EdgeInsets.only(
                  //             top: MediaQuery.of(context).size.height / 30),
                  //         child: Divider(height: 20, color: Colors.pink)),
                  //     onTap: () async {
                  //       var students = await getAllStudents(user.key);
                  //       var batches = await getAllBatches(user.key);
                  //       Map<int, dynamic> studentBatches = {};
                  //       Map<String, bool> insideStudentBatches = {};

                  //       List<String> batchNames = [];
                  //       for (var batch in batches.batches) {
                  //         if (!batchNames.contains(batch.name)) {
                  //           batchNames.add(batch.name);
                  //         }
                  //       }
                  //       for (var student in students.students) {
                  //         for (var allBatch in batches.batches) {
                  //           for (var batch in student.batches) {
                  //             if (batch.name == allBatch.name) {
                  //               insideStudentBatches[batch.name] = true;
                  //             } else {
                  //               insideStudentBatches[batch.name] = false;
                  //             }
                  //           }
                  //         }
                  //         studentBatches[student.id] = insideStudentBatches;
                  //       }

                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => EditBatch(user, students,
                  //                   batches, batchNames, studentBatches)));
                  //     },
                  //   ),
                  // )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0.0, size.height - 20);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2.25, size.height - 30.0);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint =
        Offset(size.width - (size.width / 3.25), size.height - 65);
    var secondEndPoint = Offset(size.width, size.height - 40);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
