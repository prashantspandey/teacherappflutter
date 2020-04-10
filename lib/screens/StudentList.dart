import 'package:bodhiai_teacher_flutter/data_requests/requests.dart';
import 'package:bodhiai_teacher_flutter/pojo/basic.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class StudentList extends StatelessWidget {
  ListStudents studentList = ListStudents();
  StudentList(this.studentList);
   
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
          itemCount: studentList.students.length,
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
                        studentList.students[index].name,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    leading: Container(
                      height: 50,
                      width: 50,
                      child: CachedNetworkImage(
        imageUrl: studentList.students[index].details['photo'],
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Image.asset('assets/user.png'),
     )), 

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Phone: ' +
                            studentList.students[index].details['phone']),
                        Text('Batches:'),
                        Container(
                          
                          width: MediaQuery.of(context).size.width,
                          // height:  MediaQuery.of(context).size.height *1,
                          height:30,
                          child: ListView.builder(
                            itemCount:
                                studentList.students[index].batches.length,
                            itemBuilder: (context, batchIndex) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(studentList.students[index]
                                      .batches[batchIndex].name),
                                      
                                      
                                ],
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                )
                );
              },
            ),
    )
    );
      
  }
}
