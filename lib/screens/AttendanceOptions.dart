import 'package:bodhiai_teacher_flutter/pojo/basic.dart';
import 'package:bodhiai_teacher_flutter/screens/CalenderWidget.dart';
import 'package:bodhiai_teacher_flutter/screens/FeatureHomeScreen.dart';
import 'package:bodhiai_teacher_flutter/screens/QRCodeAttendance.dart';
import 'package:flutter/material.dart';

class AttendanceOptions extends StatelessWidget {
  TeacherUser user = TeacherUser();
  AttendanceOptions(this.user);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.black.withOpacity(0.95),
      //   title: Text('Attendance'),
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            FeatureHomeScreen(
              screenHeight: MediaQuery.of(context).size.height,
              screenName: 'Attendance',
            ),
            Container(
              margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width / 30,
                  right: MediaQuery.of(context).size.width / 30),
              child: ListTile(
                title: Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 30),
                    child: Text('QR Code')),
                leading: Container(
                    // color: Colors.red,
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 100),
                    height: 50,
                    width: 50,
                    child: Image(
                      image: AssetImage("assets/qrcode.png"),
                    )),
                subtitle: Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 30),
                  child: Divider(
                    height: 20,
                    color: Colors.orange,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => QRCodeAttendance()));
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
                    child: Text('Mark Attendance')),
                leading: Container(
                          // color: Colors.red,
                           padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/100),
                          height: 50,
                          width: 50,
                          child: Image(image:  AssetImage("assets/marks.png"),)),
                subtitle: Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 30),
                  child: Divider(
                    height: 20,
                    color: Colors.orange,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CalenderWidget(
                                user,
                                screenName: 'mark',
                              )));
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
                  child: Text('Attendance Records')),
                leading: Container(
                    // color: Colors.red,
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 100),
                    height: 50,
                    width: 50,
                    child: Image(image:  AssetImage("assets/record.png"),)
                    ),
                subtitle: Container(
                     margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 30),
                  child: Divider(
                    height: 20,
                    color: Colors.orange,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CalenderWidget(
                                user,
                                screenName: 'see',
                              )));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
