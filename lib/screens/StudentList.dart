import 'package:bodhiai_teacher_flutter/data_requests/requests.dart';
import 'package:bodhiai_teacher_flutter/pojo/basic.dart';
import 'package:bodhiai_teacher_flutter/screens/StudentProfile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class StudentList extends StatefulWidget {
  TeacherUser user = TeacherUser();
  ListStudents studentList = ListStudents();
  StudentList(this.studentList,this.user);

  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
   showDeleteDialog(context,studentId){
    return showDialog(context: context,barrierDismissible: false,builder:(context){
      return AlertDialog(content: Container(height: 500,child: Column(children: <Widget>[
        Text('Are you sure you want to delete this student?',style: TextStyle(fontSize:20)),
        Spacer(),
        Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween, 
          children: <Widget>[
          RaisedButton(color: Colors.black,child: Text('Remove',style:TextStyle(color: Colors.white)), onPressed: ()async {
                    var response = await deleteStudent(widget.user.key,studentId);
                    if (response['status']=='Success'){
                      Fluttertoast.showToast(msg: response['message']);
            Navigator.pop(context);
                    }
                    else{
                      Fluttertoast.showToast(msg: response['message']);
            Navigator.pop(context);

                    }

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
        backgroundColor: Colors.pink,
        title: Text("Student List"),
      ),
      body:  Container(
            color: Colors.white,
          child: ListView.builder(
          itemCount: widget.studentList.students.length,
          itemBuilder: (context, index ) {
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Card(
                  shape: RoundedRectangleBorder(
              side: new BorderSide(color: Colors.pink, width: 0),
              borderRadius: BorderRadius.circular(10.0)),
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        widget.studentList.students[index].name,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    leading: Container(
                      height: 50,
                      width: 50,
                      child: CachedNetworkImage(
        imageUrl: widget.studentList.students[index].details['photo'],
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Image.asset('assets/user.png'),
     )), 

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Phone: ' +
                            widget.studentList.students[index].details['phone']),
                        Text('Batches:'),
                        Container(
                          
                          width: MediaQuery.of(context).size.width,
                          // height:  MediaQuery.of(context).size.height *1,
                          height:50,
                          child: ListView.builder(
                            itemCount:
                                widget.studentList.students[index].batches.length,
                            itemBuilder: (context, batchIndex) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(widget.studentList.students[index]
                                      .batches[batchIndex].name),
                                      
                                      
                                ],
                              );
                            },
                          ),
                        )
                      ],
                    ),
                    onTap: (){
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StudentProfile(widget.user,widget.studentList.students[index].id)));

                    },
                    onLongPress: (){
                        showDeleteDialog(context, widget.studentList.students[index].id).then((_)=>setState((){}));
;
                    },
                  ),
                )
                );
              },
            ),
    )
    );
      
  }
}
