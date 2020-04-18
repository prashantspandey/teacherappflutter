import 'package:bodhiai_teacher_flutter/data_requests/requests.dart';
import 'package:bodhiai_teacher_flutter/pojo/basic.dart';
import 'package:bodhiai_teacher_flutter/screens/StudentList.dart';
import 'package:flutter/material.dart';


class SearchStudent extends StatefulWidget {
  TeacherUser user = TeacherUser();
  SearchStudent(this.user);




  @override
  _SearchStudentState createState() => _SearchStudentState(user);
}

class _SearchStudentState extends State<SearchStudent> {
  TeacherUser user = TeacherUser();
  TextEditingController phoneController = TextEditingController();
  _SearchStudentState(this.user);
  bool isSearching = false;



searchStudent() async{
  setState(() {
    isSearching = true;
  });
  print('in search');
   var response = await searchStudentsPhoneNumber(user.key, phoneController.text);
   print(response.students.length);
   return response;
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search Students'),backgroundColor: Colors.pink,),
      body: Container(child: Column(children: <Widget>[
        TextField(decoration: InputDecoration(hintText:'Phone number'),
        controller: phoneController,),
        RaisedButton(child: Text('Search'), onPressed: () async{
          searchStudent();
          
       },),
        isSearching? 
        Expanded(
                  child: FutureBuilder(future: searchStudent(), builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data != null){
              var studentList = snapshot.data;
              if(snapshot.data.students.length !=0){
                  print('here');
               return StudentList(studentList, user);
              }
              else{
                return Center(child: Text('No students found'));
              }
            }
            else if (isSearching == true && snapshot.data == null){
              return Center(child: CircularProgressIndicator(),);
            }
            else{
              return Container(height: 0,);
            }
          },),
        ):Container(height: 0,)

 
      ],),),
      
    );
  }
}