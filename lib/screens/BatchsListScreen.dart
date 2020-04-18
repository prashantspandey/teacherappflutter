import 'dart:math';

import 'package:bodhiai_teacher_flutter/data_requests/requests.dart';
import 'package:bodhiai_teacher_flutter/pojo/basic.dart';
import 'package:bodhiai_teacher_flutter/providers/TeacherOptionsSeleted.dart';
import 'package:bodhiai_teacher_flutter/screens/SeeAttendance.dart';
import 'package:bodhiai_teacher_flutter/screens/StudentList.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import './MarkAttendance.dart';

class BatchListScreen extends StatelessWidget {
  TeacherUser user = TeacherUser();
  var screenName;
  var extraInfo;
  BatchListScreen(this.user, this.screenName, {this.extraInfo});

  getBatches(key) {
    var batches = getAllBatches(key);
    return batches;
  }

  bool isExtraInfo(extraInfo) {
    if (extraInfo != null) {
      return true;
    } else {
      return false;
    }
  }

  whichScreen(extraInfo) {
    if (extraInfo != null) {
      var screen = extraInfo['screen'];
      return screen;
    } else {
      return false;
    }
  }
showLoader(context){
  return showDialog(context: context,barrierDismissible: false,builder:(context){
    return AlertDialog(content: Container(height:100,child: Center(child: CircularProgressIndicator(),)),);
  });
}


  redirectMarkAttendance(context, students) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MarkAttendance(user, students,
                isExtraInfo(extraInfo) ? extraInfo['date'] : null)));
  }

  redirectSeeAttendance(context, students) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SeeAttendance(user, students,
                isExtraInfo(extraInfo) ? extraInfo['date'] : null)));
  }
  showDeleteDialog(context,batchId){
    return showDialog(context: context,barrierDismissible: false,builder:(context){
      return AlertDialog(content: Container(height: 500,child: Column(children: <Widget>[
        Text('Are you sure you want to delete this batch?',style: TextStyle(fontSize:20)),
        Spacer(),
        Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween, 
          children: <Widget>[
          RaisedButton(color: Colors.black,child: Text('Delete',style:TextStyle(color: Colors.white)), onPressed: ()async {
            var response = await deleteBatch(user.key, batchId);
            Fluttertoast.showToast(msg: response['message']);
            Navigator.pop(context);
          },),
          RaisedButton(color: Colors.white,child: Text('Cancel',style:TextStyle(color: Colors.black)), onPressed: () {Navigator.pop(context);},)
        ],)
      ],),),);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Batches'),
        backgroundColor: Colors.pink
      ),
      body: FutureBuilder(
        future: getBatches(user.key),
        builder: (context, AsyncSnapshot snapshot) {
          if(snapshot.data != null){
          var batchList = snapshot.data;
          return ListView.builder(
            itemCount: batchList.batches.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  batchList.batches[index].name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                leading: Container(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 100),
                         height: MediaQuery.of(context).size.height*0.06,
                        // width: 50,
                        child: Image(
                          image: AssetImage("assets/class1.png"),
                        )),
                        subtitle: Column(children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                            RaisedButton(child: Text('Student List'), onPressed: () async{
                        showLoader(context);
                        ListStudents students = ListStudents();
                        students = await getBatchStudents(user.key,batchList.batches[index].id);
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StudentList(
                                      students,user
                                    )));



                            },),
                            Text('|'),
                            RaisedButton(child: Text('Subjects'), onPressed: () {},)
                          ],),
                          Divider(color: Colors.orange),
                        ],),


                onLongPress: () async {
                  if (screenName != null) {
                    print(
                        'batch clicked ${batchList.batches[index].name.toString()}');
                    ListStudents students = ListStudents();
                    students = await getBatchStudents(
                        user.key, batchList.batches[index].id);
                    if (extraInfo['screen'] == 'mark') {
                      redirectMarkAttendance(context, students);
                    } else if (extraInfo['screen'] == 'see') {
                      redirectSeeAttendance(context, students);
                    }
                  }
                  else{
                  await showDeleteDialog(context, batchList.batches[index].id);
                  Navigator.pop(context);
                  }
                },
              );
            },
          );
          }
          else{
            return Center(child: CircularProgressIndicator());
          }

        },
      ),
    );
  }
}
