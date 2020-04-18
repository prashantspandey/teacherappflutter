import 'package:bodhiai_teacher_flutter/data_requests/requests.dart';
import 'package:bodhiai_teacher_flutter/pojo/basic.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class JoinRequests extends StatefulWidget {
  TeacherUser user = TeacherUser();
  JoinRequests(this.user);
  @override
  _JoinRequestsState createState() => _JoinRequestsState(user);
}

class _JoinRequestsState extends State<JoinRequests> {
  TeacherUser user = TeacherUser();
  _JoinRequestsState(this.user);

  getAllJoinRequests() async {
    var response = await getJoinRequests(user.key);
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join Requests'),
        backgroundColor: Colors.pink,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: FutureBuilder(
                future: getAllJoinRequests(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data != null) {
                    var joinRequests = snapshot.data['joinRequests'];
                    return ListView.builder(
                      itemCount: joinRequests.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                                                    child: ListTile(
                              leading: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset('assets/user.png'),
                              ),
                              title: Text(joinRequests[index]['student']['name'],style: TextStyle(fontSize: 20),),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('phone: '+joinRequests[index]['student']['username']),
                                ],
                              ),
                              onTap: (){
                                print('batches list first ${joinRequests[index]["batches"].toString()}');
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return JoinRequestBatchDialog(user,joinRequests[index]['batches'],joinRequests[index]['id']
                                         );
                                    })
                                .then((_) => setState(() {}));

                              },
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class JoinRequestBatchDialog extends StatefulWidget {
  TeacherUser user = TeacherUser();
  var batchesList;
  int requestId;
  JoinRequestBatchDialog(this.user,this.batchesList, this.requestId);
  @override
  _JoinRequestBatchDialogState createState() =>
      _JoinRequestBatchDialogState(user,batchesList, requestId);
}

class _JoinRequestBatchDialogState extends State<JoinRequestBatchDialog> {
  TeacherUser user = TeacherUser();
  var batchesList;
  int requestId;
  var batches = [];
  _JoinRequestBatchDialogState(this.user,this.batchesList, this.requestId);

  initBatches() {
    print('batch list ${batchesList.toString()}');
    for (var bl in batchesList) {
      setState(() {
        var blDict = {'id': bl['id'], 'name': bl['name'], 'value': false};
        batches.add(blDict);
      });
    }
  }
showLoader(context){
  return showDialog(context: context,barrierDismissible: false,builder:(context){
    return AlertDialog(content: Container(height:100,child: Center(child: CircularProgressIndicator(),)),);
  });
}

  @override
  void initState() {
    super.initState();
    initBatches();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        children: <Widget>[
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
              RaisedButton(
                color: Colors.black,
                child: Text('Accept',style: TextStyle(color: Colors.white),),
                onPressed: () async{
                  var finalBatches = [];
                  for (var bat in batches){
                    if(bat['value']==true){
                      finalBatches.add(bat['id']);
                    }
                  }
                  if(finalBatches.length == 0){
                    Fluttertoast.showToast(msg: "Please select atleast one batch or deny the request.");
                  }
                  else{
                  showLoader(context);
                     var response = await acceptJoinRequest(user.key, requestId, finalBatches);
                     Navigator.pop(context);
                     if (response['status']=='Success'){
                     Navigator.pop(context);

                       Fluttertoast.showToast(msg: response['message']);
                     }
                     else{
                     Navigator.pop(context);
                       Fluttertoast.showToast(msg: response['message']);

                     }
                  }
                },
              ),
              RaisedButton(
                color: Colors.orange,
                child: Text('Deny'),
                onPressed: () {
                  Navigator.pop(context);
                  print('denied');
                },
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
