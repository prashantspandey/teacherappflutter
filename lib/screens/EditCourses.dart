import 'package:bodhiai_teacher_flutter/data_requests/requests.dart';
import 'package:bodhiai_teacher_flutter/pojo/basic.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class EditCourse extends StatefulWidget {
  TeacherUser user = TeacherUser();
  int courseId;
  EditCourse(this.user,this.courseId);
  @override
  _EditCourseState createState() => _EditCourseState();
}

class _EditCourseState extends State<EditCourse> {



  showDeleteDialog(context,batchId,courseId){
    return showDialog(context: context,barrierDismissible: false,builder:(context){
      return AlertDialog(content: Container(height: 500,child: Column(children: <Widget>[
        Text('Are you sure you want to remove course from this batch?',style: TextStyle(fontSize:20)),
        Spacer(),
        Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween, 
          children: <Widget>[
          RaisedButton(color: Colors.black,child: Text('Remove',style:TextStyle(color: Colors.white)), onPressed: ()async {
                    var response = await removeBatchCourse(widget.user.key,widget.courseId,batchId);
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

  showDeleteSubjectDialog(context,subjectId,courseId){
    return showDialog(context: context,barrierDismissible: false,builder:(context){
      return AlertDialog(content: Container(height: 500,child: Column(children: <Widget>[
        Text('Are you sure you want to remove subject from this batch?',style: TextStyle(fontSize:20)),
        Spacer(),
        Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween, 
          children: <Widget>[
          RaisedButton(color: Colors.black,child: Text('Remove',style:TextStyle(color: Colors.white)), onPressed: ()async {
                    var response = await removeSubjectCourse(widget.user.key,widget.courseId,subjectId);
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
      appBar: AppBar(title:Text('Edit Course'),
      backgroundColor: Colors.pink,
      ),
      body: Container(child: Column(children: <Widget>[
FutureBuilder(
  future: courseGetBatches(widget.user.key,widget.courseId), builder: (BuildContext context, AsyncSnapshot snapshot) {
    if(snapshot.data != null){
      var batches = snapshot.data['batches'];
        return SingleChildScrollView(
                  child: Column(children: <Widget>[
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
                          return AddBatchWidget(widget.user,widget.courseId);
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
                        child: ListView.builder(itemCount:batches.length, itemBuilder: (BuildContext context, int index) {
                 return ListTile(leading: Image.asset('assets/class1.png',height: 30,),
                      title: Text(batches[index]['name']),
                      subtitle: Divider(color: Colors.pink,),
                  onLongPress: () async{
                    await showDeleteDialog(context,batches[index]['id'],widget.courseId).then((_)=>setState((){}));
                  }, 
                 );
               },),
             ),
           ),
     
      ]));
      
      }
      else{
        return Center(child: CircularProgressIndicator(),);
      }
      }),
FutureBuilder(
  future: courseGetSubjects(widget.user.key,widget.courseId), builder: (BuildContext context, AsyncSnapshot snapshot) {
    if(snapshot.data != null){
      var subjects = snapshot.data['subjects'];
        return SingleChildScrollView(
                  child: Column(children: <Widget>[
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: <Widget>[
                 Padding(
                   padding: const EdgeInsets.only(left:20.0),
                   child: Text('Subjects',style: TextStyle(fontSize: 15),),
                 ),
                 Padding(
                   padding: const EdgeInsets.only(right:20),
                   child: GestureDetector(onTap: (){
                      showDialog(context: context,builder: (context){
                          return AddSubjectWidget(widget.user,widget.courseId);
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
                        child: ListView.builder(itemCount:subjects.length, itemBuilder: (BuildContext context, int index) {
                 return ListTile(leading: Image.asset('assets/book.png',height: 30,),
                      title: Text(subjects[index]['name']),
                      subtitle: Divider(color: Colors.pink,),
                  onLongPress: () async{
                    await showDeleteSubjectDialog(context,subjects[index]['id'],widget.courseId).then((_)=>setState((){}));
                  }, 
                 );
               },),
             ),
           ),
     
      ]));
      
      }
      else{
        return Center(child: CircularProgressIndicator(),);
      }

      })

      ]
      )));

  
  }}


class AddBatchWidget extends StatefulWidget {
  TeacherUser user = TeacherUser();
  int courseId;
  AddBatchWidget(this.user,this.courseId);
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
          Text('Select Batch to add to',style: TextStyle(fontSize: 20),),
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
                   var response = await courseAddBatches(widget.user.key,widget.courseId,finalBatch);
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

class AddSubjectWidget extends StatefulWidget {
  TeacherUser user = TeacherUser();
  int courseId;
  AddSubjectWidget(this.user,this.courseId);
  @override
  _AddSubjectWidgetState createState() => _AddSubjectWidgetState();
}

class _AddSubjectWidgetState extends State<AddSubjectWidget> {
  var subjects = [];
  
  getSubjects()async{
    var response = await getAllSubjects(widget.user.key);
    var subjects_list = response['subjects'];
    for (var sub in subjects_list){
      print('subject ${sub.toString()}');
        var subDict = {'id':sub['id'],'name':sub['name'],'value':false};
        setState(() {
          
        subjects.add(subDict);
        });
    }
  }
@override
void initState() {
    super.initState();
    getSubjects();
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(children: <Widget>[
          Text('Select Subjects to add to Course',style: TextStyle(fontSize: 20),),
          subjects.length == 0?Center(child: CircularProgressIndicator(),):
           Expanded(
                        child: ListView.builder(itemCount:subjects.length, itemBuilder: (BuildContext context, int index) {
                return ListTile(title: Text(subjects[index]['name']),
                        trailing: Checkbox(
                          value: subjects[index]['value'],
                          onChanged: (bool value) {
                            setState(() {
                              subjects[index]['value'] = value;
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
                 for (var sub in subjects){
                   if(sub['value'] == true){
                     finalBatch.add(sub['id']);
                   }
                 }
                 if (finalBatch.length != 0){
                   var response = await courseAddSubjects(widget.user.key,widget.courseId,finalBatch);
                   if(response['status']=='Success'){
                      Fluttertoast.showToast(msg: 'Subject Added');
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