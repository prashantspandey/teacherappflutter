import 'package:bodhiai_teacher_flutter/pojo/basic.dart';
import 'package:bodhiai_teacher_flutter/data_requests/requests.dart';
import 'package:bodhiai_teacher_flutter/screens/HomePageBackground.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class StudentProfile extends StatefulWidget {
  TeacherUser user = TeacherUser();
  int studentId;
  StudentProfile(this.user,this.studentId);
  @override
  _StudentProfileState createState() => _StudentProfileState(user,studentId);
}

class _StudentProfileState extends State<StudentProfile> {
  TeacherUser user = TeacherUser();
  int studentId;
  _StudentProfileState(this.user,this.studentId);

  showDeleteDialog(context,studentId,batchId){
    return showDialog(context: context,barrierDismissible: false,builder:(context){
      return AlertDialog(content: Container(height: 500,child: Column(children: <Widget>[
        Text('Are you sure you want to remove student from this batch?',style: TextStyle(fontSize:20)),
        Spacer(),
        Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween, 
          children: <Widget>[
          RaisedButton(color: Colors.black,child: Text('Remove',style:TextStyle(color: Colors.white)), onPressed: ()async {
                    var response = await removeStudentBatch(user.key,studentId,batchId);
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

  getStudentProfile()async{
    var response = await studentProfile(user.key,studentId);
    return response;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text('Student Profile'),backgroundColor: Colors.pink,),
     body: Container(child: Column(children: <Widget>[
       
FutureBuilder(
  future: getStudentProfile(), builder: (BuildContext context, AsyncSnapshot snapshot) {
    if(snapshot.data != null){
      var student = snapshot.data;
        return SingleChildScrollView(
                  child: Column(children: <Widget>[
 Center(child:
           Column(
             children: <Widget>[
               Stack(children: <Widget>[
                 HomePageBackground(screenHeight: MediaQuery.of(context).size.height-100,color: Colors.pink,),
               Padding(
                 padding: const EdgeInsets.only(top:50.0),
                 child: Center(
                   child: Column(
                     children: <Widget>[
                       Container(
                                      height: 70,
                                      width: 70,
                                      child: CachedNetworkImage(
                        imageUrl: student['details']['details']['photo']== null? 'https://miro.medium.com/max/560/1*MccriYX-ciBniUzRKAUsAw.png':student['details']['details']['photo'],
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Image.asset('assets/user.png'),
       )),
       Padding(
         padding: const EdgeInsets.all(8.0),
         child: Text(student['details']['name'],style: TextStyle(fontSize: 20),),
       ),
                     ],
                   ),
                 ),
               ),

               ],),
             ],
           ), 

  
           ),
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: <Widget>[
                 Padding(
                   padding: const EdgeInsets.only(left:20.0),
                   child: Text('Batches',style: TextStyle(fontSize: 15),),
                 ),
                 Padding(
                   padding: const EdgeInsets.only(right:20),
                   child: GestureDetector(onTap: (){
                      showDialog(context: context,builder: (context){
                          return AddBatchWidget(user,studentId);
                      }).then((_)=>setState((){})) ;
                     
                     },
                   child: Icon(Icons.add),),
                 )
               ],
             ),
           ),
           Padding(
             padding: const EdgeInsets.all(20.0),
             child: Container(
               decoration: BoxDecoration(border: Border.all(width: 0.1)),
               height: 200,
                        child: ListView.builder(itemCount:student['details']['batches'].length, itemBuilder: (BuildContext context, int index) {
                 return ListTile(leading: Image.asset('assets/class1.png',height: 30,),
                      title: Text(student['details']['batches'][index]['name']),
                      subtitle: Divider(color: Colors.pink,),
                  onLongPress: () async{
                        print('student id ${studentId}, batches ${student["details"]["batches"][index]["id"]}');
                    await showDeleteDialog(context, studentId,student['details']['batches'][index]['id']).then((_)=>setState((){}));
                  }, 
                 );
               },),
             ),
           ),
           Text('Attendance',style: TextStyle(fontSize: 15),),
           Padding(
             padding: const EdgeInsets.all(20.0),
             child: Container(
               decoration: BoxDecoration(border: Border.all(width:0.1)),
               height: 200,
                        child: ListView.builder(itemCount:student['attendance_details'].length, itemBuilder: (BuildContext context, int index) {
                          if(student['attendance_details'].length == 0){
                            return Text('No attendance yet.');
                          }
                          else{
                 return ListTile(leading: Image.asset('assets/workshop.png',height: 40,),
                      title: Text(student['attendance_details'][index]['type']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(student['attendance_details'][index]['date'].toString().split('T')[0].toString()),
                          Divider(color: Colors.pink,)
                        ],
                      ),
                  onTap: (){
                    print('batch pressed');
                  }, 
                 );
 
                          }
              },),
             ),
           ),
           Text('Test Performance',style: TextStyle(fontSize: 15),),
           Padding(
             padding: const EdgeInsets.all(20.0),
             child: Container(
               decoration: BoxDecoration(border: Border.all(width:0.1)),
               height: 200,
                        child: ListView.builder(itemCount:student['test_details'].length, itemBuilder: (BuildContext context, int index) {
                          if(student['test_details'].length == 0){
                            return Text('No test taken yet.');
                          }
                          else{
                 return ListTile(leading: Image.asset('assets/workshop.png',height: 40,),
                      title: Text(student['test_details'][index]['type']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(student['attendance_details'][index]['date'].toString().split('T')[0].toString()),
                          Divider(color: Colors.pink,)
                        ],
                      ),
                  onTap: (){
                    print('batch pressed');
                  }, 
                 );
 
                          }
              },),
             ),
           ),




          ],),
        );
    }
    else{
      return Center(child: CircularProgressIndicator(),);
    }
  }, )
     ],),), 
    );
  }
}


class AddBatchWidget extends StatefulWidget {
  TeacherUser user = TeacherUser();
  int studentId;
  AddBatchWidget(this.user,this.studentId);
  @override
  _AddBatchWidgetState createState() => _AddBatchWidgetState();
}

class _AddBatchWidgetState extends State<AddBatchWidget> {
  var batches = [];
  
  getStudentBatches()async{
    var response = await getAllBatches(widget.user.key);
    var batches_list = response.batches;
    for (var bat in batches_list){
        var batDict = {'id':bat.id,'name':bat.name,'value':false};
        setState(() {
          
        batches.add(batDict);
        });
    }
  }
@override
void initState() {
    super.initState();
    getStudentBatches();
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(children: <Widget>[
          Text('Select Batch to add to'),
          batches.length == 0?Center(child: CircularProgressIndicator(),):
           Expanded(
                        child: ListView.builder(itemCount:batches.length, itemBuilder: (BuildContext context, int index) {
                return ListTile(title: Text(batches[index]['name']),
                        trailing: Checkbox(
                          value: batches[index]['value'],
                          onChanged: (bool value) {
                            setState(() {
                              batches[index]['value'] = value;
                            });
                          },
                        ),
 
                );
          },),
           ),
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: ButtonTheme(
               minWidth: MediaQuery.of(context).size.width-100,
                          child: RaisedButton(child: Text('Add'), onPressed: () async{
                 var finalBatch = [];
                 for (var bat in batches){
                   if(bat['value'] == true){
                     finalBatch.add(bat['id']);
                   }
                 }
                 if (finalBatch.length != 0){
                   var response = await addBatchStudent(widget.user.key,widget.studentId,finalBatch);
                   if(response['status']=='Success'){
                      Fluttertoast.showToast(msg: 'Batch Added');
                      Navigator.pop(context);
                   }
                   else{
                     Fluttertoast.showToast(msg: response['message']);
                      Navigator.pop(context);
                   }
                 }
               },),
             ),
           )
      ],),
      
    );
  }
}