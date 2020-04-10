import 'package:bodhiai_teacher_flutter/pojo/basic.dart';
import 'package:bodhiai_teacher_flutter/screens/HomeScreen.dart';
import 'package:bodhiai_teacher_flutter/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
 Future<SharedPreferences> preferences = SharedPreferences.getInstance();

  getPreferences() async{
  bool isLoggedIn;
  TeacherUser teacherUser;

    SharedPreferences prefs = await preferences;
    var key = prefs.getString('userkey');
    var institute = prefs.getString('institute');
    var username = prefs.getString('username');
    var name = prefs.getString('name');
    if (key != null){
        isLoggedIn =true;
        var userJson = {'key':key,'institute':institute,'username':username,'name':name};
        teacherUser = TeacherUser.fromJson(userJson);

    }
    else{
      isLoggedIn = false;
    }
  return [isLoggedIn,teacherUser];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bodhi AI Teacher',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(future: getPreferences(), builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.data !=null){
              bool loggedIn = snapshot.data[0];
              var user = snapshot.data[1];
              return loggedIn?HomeScreen(user):Login();
          }
          else{
            return Center(child: CircularProgressIndicator(),);
          }
        },));
  }
}

