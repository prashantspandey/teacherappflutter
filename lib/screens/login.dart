import 'package:bodhiai_teacher_flutter/data_requests/requests.dart';
import 'package:bodhiai_teacher_flutter/pojo/basic.dart';
import 'package:bodhiai_teacher_flutter/screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatelessWidget {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  TeacherUser teacheruser = TeacherUser();
 Future<SharedPreferences> preferences = SharedPreferences.getInstance();

 showLoader(context){
   return showDialog(context: context,barrierDismissible: false,builder: (context){
     return AlertDialog(content: Container(height: 500,color: Colors.transparent,child: Center(child: CircularProgressIndicator()),));
   });
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: <Widget>[
        ClipPath(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              Image.asset(
                  "assets/logo.webp",
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.4,
            width: double.infinity,
            color: Color(0xFFFF4700).withOpacity(0.95),
          ),
          clipper: MyClipper(),
        ),
        Container(
              margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.04,
              right: MediaQuery.of(context).size.width * 0.04,
              top: MediaQuery.of(context).size.height * 0.06),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                   width: MediaQuery.of(context).size.width * 0.85,
                child: TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                        labelText: "Username",
                        prefixIcon: Icon(Icons.person),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50)))),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              Container(
                   width: MediaQuery.of(context).size.width * 0.85,
                child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.vpn_key),
                        labelText: "Password",
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50)))),
              ),

              Padding(padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.04)),
              Container(
                child: MaterialButton(
                    height: MediaQuery.of(context).size.height * 0.06,
                    minWidth: MediaQuery.of(context).size.width * 0.85,
                    color: Color(0xFFFF4700).withOpacity(0.95),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    onPressed: () async {
                      showLoader(context);
                      String username = usernameController.text;
                      String password = passwordController.text;
                      try{
                       teacheruser =
                          await teacherLogin(username,password);

                      }
                      on Exception catch(e){
                        Fluttertoast.showToast(msg: e.toString());
                        teacheruser = null;
                      }
                      //user,studentsprint('teacher key ${teacheruser.key}');
                      //print('teacher name ${teacheruser.name}');
                      if (teacheruser == null) {
                        Navigator.pop(context);
                        Fluttertoast.showToast(
                            msg: "invalid user name and password",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIos: 2,
                            textColor: Colors.red,
                            fontSize: 20.0);
                      }
                               else if (usernameController.text.isEmpty ||
                                 passwordController.text.isEmpty) {
                        Navigator.pop(context);
                               Fluttertoast.showToast(
                                  msg: "all fields are required",
                                 toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.CENTER,
                               timeInSecForIos: 2,
                              textColor: Colors.red,
                             fontSize: 20.0);
                       }
                      else {
                        SharedPreferences prefs = await preferences;
                          prefs.setString('userkey',teacheruser.key);
                           prefs.setString('institute',teacheruser.institute);
                           prefs.setString('username',teacheruser.username);
                          prefs.setString('name',teacheruser.name);
                          prefs.setBool('mainTeacher',teacheruser.mainTeacher);
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen(teacheruser)));
                            
                      }

                      // print(respone);
                    }),
              ),
              Padding(
                padding: EdgeInsets.only(top: 100),
              ),
            ],
          ),
        )
      ],
    ));
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    var controllpoint = Offset(50, size.height);
    var endpoint = Offset(size.width / 2, size.height);
    path.quadraticBezierTo(
        controllpoint.dx, controllpoint.dy, endpoint.dx, endpoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
