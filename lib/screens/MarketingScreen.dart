import 'package:bodhiai_teacher_flutter/data_requests/requests.dart';
import 'package:bodhiai_teacher_flutter/pojo/basic.dart';
import 'package:bodhiai_teacher_flutter/screens/BannerScreen.dart';
import 'package:bodhiai_teacher_flutter/screens/Pacakges.dart';
import 'package:bodhiai_teacher_flutter/screens/StudentList.dart';
import 'package:flutter/material.dart';

class MarketingScreen extends StatelessWidget {
  TeacherUser user = TeacherUser();
  MarketingScreen(this.user);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Marketing'),
      //   backgroundColor: Colors.black.withOpacity(0.8),
      // ),
      body: SafeArea(
              child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ClipPath(
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage("assets/background5.png"),
                    fit: BoxFit.fill,
                  )),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ListTile(
                          title: Text(
                            "Marketing",
                            style: TextStyle(color: Colors.white, fontSize: 30),
                          ),
                          trailing: Container(
                            height: 50,
                            width: 60,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              image: AssetImage("assets/marketing1.png"),
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
                      child: Text(
                        'Packages',
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
                        image: AssetImage("assets/pakage.png"),
                      )),
                  subtitle: Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 30),
                      child: Divider(height: 20, color: Color(0xFFFF4700))),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Packages(
                                  user,
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
                      child: Text(
                        'Banners',
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
                        image: AssetImage("assets/pakage.png"),
                      )),
                  subtitle: Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 30),
                      child: Divider(height: 20, color: Color(0xFFFF4700))),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BannerScreen(
                                  user,
                                )));
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
