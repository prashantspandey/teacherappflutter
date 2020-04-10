
import 'package:bodhiai_teacher_flutter/pojo/basic.dart';
import 'package:bodhiai_teacher_flutter/screens/SendAnnouncement.dart';
import 'package:flutter/material.dart';

class CommunicationScreen extends StatefulWidget {
  TeacherUser user = TeacherUser();
  CommunicationScreen(this.user);
  @override
  _CommunicationScreenState createState() => _CommunicationScreenState(user);
}

class _CommunicationScreenState extends State<CommunicationScreen> {
  TeacherUser user = TeacherUser();
  _CommunicationScreenState(this.user);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ClipPath(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue[200]
                //     image: DecorationImage(
                //   image: AssetImage("assets/background.jpg"),
                //   fit: BoxFit.fill,
                // )
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ListTile(
                        title: Text(
                          "Communication",
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        ),
                        trailing: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: AssetImage("assets/computer.png"),
                            fit: BoxFit.fill,
                          )),
                        )),
                  ],
                ),
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width,
                // color: Colors.red
              ),
              clipper: MyClipper(),
            ),
            Container(
              margin:  EdgeInsets.only( left :MediaQuery.of(context).size.width/30,right: MediaQuery.of(context).size.width/30),
            ),
            SizedBox(
               width: MediaQuery.of(context).size.width - 10,
                child: ListTile(
                  title: Container(
                      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/30),
                    child: Text('Announcement',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)),
                  leading:
                      Container(
                          // color: Colors.red,
                         padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/100),
                          height: 50,
                          width: 50,
                          child: Image(image:  AssetImage("assets/chat.png"),)),
                  subtitle: Container(
                     margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/30),
                    child: Divider(height: 20, color: Color(0xFFFF4700))),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SendAnnouncement(
                                  user,
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

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0.0, size.height - 50);

    var firstControlPoint = Offset(size.width/4, size.height);
    var firstEndPoint = Offset(size.width, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint =
        Offset(size.width - (size.width / 3.25), size.height - 65);
    var secondEndPoint = Offset(size.width, size.height - 40);
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