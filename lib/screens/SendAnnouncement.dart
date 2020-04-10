import 'package:bodhiai_teacher_flutter/data_requests/requests.dart';
import 'package:bodhiai_teacher_flutter/pojo/basic.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class SendAnnouncement extends StatefulWidget{
  TeacherUser user = TeacherUser();
  SendAnnouncement(this.user);
  @override
  _SendAnnouncementState createState() => _SendAnnouncementState(user);
}

class _SendAnnouncementState extends State<SendAnnouncement> {
  TeacherUser user = TeacherUser();
  _SendAnnouncementState(this.user);
  TextEditingController messageText = TextEditingController();
  List batchValues = List();
getBatch() async{
  if (batchValues.length == 0){
  var response = await getAllBatches(user.key);
  var batches = response;
  for(var batch in batches.batches){
    var batchVal = {'id':batch.id,'name':batch.name,'value':false};
  setState(() {
    
    batchValues.add(batchVal);
  });    
  }

  }
}

showLoader(context){
  return showDialog(context: context,barrierDismissible: false,builder:(context){
    return AlertDialog(content: Center(child: CircularProgressIndicator(),),);
  });
}
@override
void initState() {
    super.initState();
    getBatch();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Send Announcement'),backgroundColor: Colors.black.withOpacity(0.95),
      ),
      body: Container(child: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: TextField(controller: messageText,decoration: InputDecoration(hintText: 'Enter Message here'),),
        ),
        Text('Select Batches to send announcement to',style: TextStyle(fontSize:15)),
                   Expanded(
                                        child: ListView.builder(itemCount:batchValues.length, itemBuilder: (BuildContext context, int index) {
                      return CheckboxListTile(title:Text(batchValues[index]['name']),value:batchValues[index]['value'] ,
                      onChanged: (bool value) {
                        setState(() {
                          batchValues[index]['value'] = value;
                        });
                      },);
                  },),
                   ),
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: ButtonTheme(
                       minWidth: MediaQuery.of(context).size.width-30,
                                          child: RaisedButton(color:Colors.black,child: Text('Send Announcement',style: TextStyle(color: Colors.white),), onPressed: ()async {
                                              String text = messageText.text.replaceAll("\"", "");
                                            print('message text${messageText.text}d');
                                            if(text != null || text != '' || text != ' '){
                                            print('message text inside${messageText.text}d');
                                              showLoader(context);
                                            List batchList = [];
                                            for(var vals in batchValues){
                                              if(vals['value'] == true){
                                                batchList.add(vals['id']);
                                              }
                                            }
                                            var response = await sendAnnouncement(user.key, text, batchList);
                                            if(response['status']=='Success'){
                                              Fluttertoast.showToast(msg: response['message']);
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            }
                                            else{
                                              Fluttertoast.showToast(msg: response['message']);
                                              Navigator.pop(context);
                                            }

                                            }
                                            else if (messageText.text == null || messageText.text == ''){
                                              print('here');
                                              Fluttertoast.showToast(msg: "Please enter the message you want to send .");
                                            }

                       }),
                     ),
                   ),



      ],),),
    );
  }
}
  
