import 'package:bodhiai_teacher_flutter/data_requests/requests.dart';
import 'package:bodhiai_teacher_flutter/pojo/basic.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddStudents extends StatefulWidget {
  TeacherUser user = TeacherUser();
  AddStudents(this.user);
  @override
  _AddStudentsState createState() => _AddStudentsState(user);
}

class _AddStudentsState extends State<AddStudents> {
  TeacherUser user = TeacherUser();
  _AddStudentsState(this.user);
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  var batches = [];

showLoader(context){
  return showDialog(context: context,barrierDismissible: false,builder:(context){
    return AlertDialog(content: Container(height:100,child: Center(child: CircularProgressIndicator(),)),);
  });
}

  teacherGetBatches()async{
    var response = await getAllBatches(user.key);
    var batchesList = response.batches;
    for(var bl in batchesList){
      print(bl.id);
      var blDict = {'id':bl.id,'name':bl.name,'value':false};
      setState(() {
      batches.add(blDict);
      });
    }

  }
  @override
  void initState() {
    super.initState();
    teacherGetBatches();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Students'),backgroundColor: Colors.pink,),
   body: Container(child: Column(children: <Widget>[
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Container(
                     width: MediaQuery.of(context).size.width * 0.85,
                child: TextField(
                      controller: phoneNumberController,
                    keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: "Student Phone",
                          prefixIcon: Icon(Icons.person),
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50)))),
              ),
                   ),
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Container(
                     width: MediaQuery.of(context).size.width * 0.85,
                child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                          labelText: "Student Name",
                          prefixIcon: Icon(Icons.person),
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50)))),
              ),
                   ),

          batches.length == 0
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: batches.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CheckboxListTile(
                        title: Text(batches[index]['name']),
                        value: batches[index]['value'],
                        onChanged: (bool value) {
                          setState(() {
                            batches[index]['value'] = value;
                          });
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ButtonTheme(
                    height: 50,
                    minWidth: MediaQuery.of(context).size.width,
                                    child: RaisedButton(color:Colors.pink,child: Text('Add Student',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),), onPressed: () async{
                                      if(phoneNumberController.text.length <10 || phoneNumberController.text.length> 10){
                                        Fluttertoast.showToast(msg: "Please enter valid number");
                                      }
                                      else{
                                        if(nameController.text.length > 2){
                                          var finalBatches = [];
                                          for (var bat in batches){
                                            if(bat['value'] == true){
                                              finalBatches.add(bat['id']);
                                            }
                                          }
                                          if(finalBatches.length == 0){
                                            Fluttertoast.showToast(msg: 'Please select atleast one batch');
                                          }
                                          else{
                                          showLoader(context);
                                             var response = await teacherRegisterStudent(user.key, phoneNumberController.text, nameController.text,finalBatches); 
                                             Navigator.pop(context);
                                             if (response['status'] == 'Success'){
                                               Fluttertoast.showToast(msg: 'Student successfully registered.');
                                             }
                                             else{
                                               Fluttertoast.showToast(msg: response['message']);
                                             }

                                          }
                                        }
                                        else{
                                        Fluttertoast.showToast(msg: "Please enter proper name for student.");
                                        }

                                      }
                      print('added');
                    },),
                  ),
                )
   ],),),  
    );
    
  }
}