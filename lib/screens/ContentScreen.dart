import 'package:bodhiai_teacher_flutter/data_requests/requests.dart';
import 'package:bodhiai_teacher_flutter/pojo/basic.dart';
import 'package:bodhiai_teacher_flutter/screens/AddSubjects.dart';
import 'package:bodhiai_teacher_flutter/screens/AddYoutubeVideo.dart';
import 'package:bodhiai_teacher_flutter/screens/FeatureHomeScreen.dart';
import 'package:bodhiai_teacher_flutter/screens/ListAllTests.dart';
import 'package:bodhiai_teacher_flutter/screens/NativeLiveVideo.dart';
import 'package:bodhiai_teacher_flutter/screens/NotesList.dart';
import 'package:bodhiai_teacher_flutter/screens/SeeVideos.dart';
import 'package:bodhiai_teacher_flutter/screens/TestQuestionsScreen.dart';
import 'package:bodhiai_teacher_flutter/screens/UploadNotes.dart';
import 'package:bodhiai_teacher_flutter/screens/UploadVideo.dart';
import 'package:bodhiai_teacher_flutter/screens/YoutubeLiveVideo.dart';
import 'package:flutter/material.dart';

class ContentScreen extends StatelessWidget {
  TeacherUser user = TeacherUser();
  ContentScreen(this.user);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.black.withOpacity(0.95),
      //   title: Text('Content'),
      // ),
      body: SafeArea(
              child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ClipPath(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.7),
                      // image: DecorationImage(
                      //   image: AssetImage("assets/background5.jpg"),
                      //   fit: BoxFit.fill,
                      // )
                      ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ListTile(
                          title: Text(
                            "Content",
                            style: TextStyle(color: Colors.white, fontSize: 30),
                          ),
                          trailing: Container(
                            height: 50,
                            width: 60,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              image: AssetImage("assets/sharing-content.png"),
                              fit: BoxFit.fill,
                            )),
                          )),
                    ],
                  ),
                  height: MediaQuery.of(context).size.height * 0.16,
                  width: MediaQuery.of(context).size.width,
                  // color: Colors.red
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
                        'Start Live Video',
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      )),
                  leading: Container(
                      // color: Colors.red,
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 100),
                      height: 110,
                      width: 50,
                      child: Image(
                        image: AssetImage("assets/live.png"),
                      )),
                  subtitle: Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 30),
                    child: Divider(
                      height: 20,
                      color: Colors.green,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NativeLiveVideo(user)));
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
                      // color: Colors.pink,
                      child: Text(
                        'Start Youtube Live Video',
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      )),
                  leading: Container(
                      // color: Colors.red,
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 100),
                      height: 110,
                      width: 50,
                      child: Image(
                        image: AssetImage("assets/live.png"),
                      )),
                  subtitle: Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 30),
                    child: Divider(
                      height: 20,
                      color: Colors.green,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => YoutubeLiveVideo(user)));
                  },
                ),
              ),

              // Container(
                // margin: EdgeInsets.only(
                    // left: MediaQuery.of(context).size.width / 30,
                    // right: MediaQuery.of(context).size.width / 30),
                // child: ListTile(
                  // title: Container(
                      // margin: EdgeInsets.only(
                          // top: MediaQuery.of(context).size.height / 30),
                      //color: Colors.pink,
                      // child: Text(
                        // 'Upload Videos',
                        // style:
                            // TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      // )),
                  // leading: Container(
                      //color: Colors.red,
                      // padding: EdgeInsets.only(
                          // top: MediaQuery.of(context).size.height / 100),
                      // height: 100,
                      // width: 40,
                      // child: Image(
                        // image: AssetImage("assets/upload1.png"),
                      // )),
                  // subtitle: Container(
                    // margin: EdgeInsets.only(
                        // top: MediaQuery.of(context).size.height / 30),
                    // child: Divider(
                      // height: 20,
                      // color: Colors.green,
                    // ),
                  // ),
                  // onTap: () {
                    // Navigator.push(
                        // context,
                        // MaterialPageRoute(
                            // builder: (context) => UploadVideo(user)));
                  // },
                // ),
              // ),
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
                        'Upload Youtube Video',
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      )),
                  leading: Container(
                      // color: Colors.red,
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 100),
                      height: 100,
                      width: 40,
                      child: Image(
                        image: AssetImage("assets/upload1.png"),
                      )),
                  subtitle: Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 30),
                    child: Divider(
                      height: 20,
                      color: Colors.green,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddYoutubeVideo(user)));
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
                        'All Videos',
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      )),
                  leading: Container(
                      // color: Colors.red,
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 100),
                      height: 50,
                      width: 50,
                      child: Image(
                        image: AssetImage("assets/music.png"),
                      )),
                  subtitle: Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 30),
                    child: Divider(
                      height: 20,
                      color: Colors.green,
                    ),
                  ),
                  onTap: () async {
                    var videos = await getUploadedVideos(user.key);
                    // print("all videos $videos");

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SeeVideos(user, videos['videos'])));
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
                        'Upload Notes',
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      )),
                  leading: Container(
                      // color: Colors.red,
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 100),
                      height: 100,
                      width: 50,
                      child: Image(
                        image: AssetImage("assets/upload2.png"),
                      )),
                  subtitle: Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 30),
                    child: Divider(
                      height: 20,
                      color: Colors.green,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UploadNotes(user)));
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
                        'All Notes',
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      )),
                  leading: Container(
                      // color: Colors.red,
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 100),
                      height: 110,
                      width: 50,
                      child: Image(
                        image: AssetImage("assets/paper.png"),
                      )),
                  subtitle: Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 30),
                    child: Divider(
                      height: 20,
                      color: Colors.green,
                    ),
                  ),
                  onTap: () async {
                    var response = await getUploadedNotes(user.key);
                    var notes = response['notes'];
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotesList(user,notes)));
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
                        'Create Test',
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      )),
                  leading: Container(
                      // color: Colors.red,
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 100),
                      height: 110,
                      width: 50,
                      child: Image(
                        image: AssetImage("assets/test.png"),
                      )),
                  subtitle: Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 30),
                    child: Divider(
                      height: 20,
                      color: Colors.green,
                    ),
                  ),
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TestQuestionsScreen(user)));
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
                        'See All Tests',
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      )),
                  leading: Container(
                      // color: Colors.red,
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 100),
                      height: 110,
                      width: 50,
                      child: Image(
                        image: AssetImage("assets/testing.png"),
                      )),
                  subtitle: Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 30),
                    child: Divider(
                      height: 20,
                      color: Colors.green,
                    ),
                  ),
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ListAllTests(user)));
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
                        'Add Subject',
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      )),
                  leading: Container(
                      // color: Colors.red,
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 100),
                      height: 110,
                      width: 50,
                      child: Image(
                        image: AssetImage("assets/testing.png"),
                      )),
                  subtitle: Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 30),
                    child: Divider(
                      height: 20,
                      color: Colors.green,
                    ),
                  ),
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddSubjects(user)));
                  },
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0.0, size.height - 50);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2.25, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint =
        Offset(size.width - (size.width), size.height - 65);
    var secondEndPoint = Offset(size.width, size.height);

    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
