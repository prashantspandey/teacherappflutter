import 'package:bodhiai_teacher_flutter/data_requests/requests.dart';
import 'package:bodhiai_teacher_flutter/pojo/basic.dart';
import 'package:bodhiai_teacher_flutter/screens/call.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class NativeLiveVideo extends StatefulWidget {
  TeacherUser user = TeacherUser();
  String agoraId = '485c033c5aba4ae98605f98dc821625a';
  NativeLiveVideo(this.user);
  @override
  State<StatefulWidget> createState() {
    return _NativeLiveVideo();
  }
}

class _NativeLiveVideo extends State<NativeLiveVideo> {
  String channelName;
  int videoId;
  var _radioValue = 1;
  List batchValues = List();
  bool loaded = false;
  startLoading(context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 200,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        });
  }

  getBatch() async {
    if (batchValues.length == 0) {
      var response = await getAllBatches(widget.user.key);
      setState(() {
        loaded = true;
      });
      var batches = response;
      for (var batch in batches.batches) {
        var batchVal = {'id': batch.id, 'name': batch.name, 'value': true};
        setState(() {
          batchValues.add(batchVal);
        });
      }
    }
  }

  Future<void> onJoin() async {
    startLoading(context);
    // update input validation
    // await for camera and mic permissions before pushing video page
    await _handleCameraAndMic();
    // push video page with given channel name
    var response = sendNotification(widget.user.key,
        '${widget.user.name} is about to go live. Attend live class now.');
    List batchList = [];
    for (var vals in batchValues) {
      if (vals['value'] == true) {
        batchList.add(vals['id']);
      }
    }

    var videoStart = await startNativeLiveVideo(widget.user.key, batchList);

    print('response to video start ${videoStart.toString()}');
    print('response to notification ${response.toString()}');
    if (videoStart['status'] == 'Success') {
      setState(() {
        videoId = videoStart['id'];
      });
      Navigator.pop(context);
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(
            widget.agoraId,
            videoId,
            widget.user,
            _radioValue,
            channelName: channelName,
          ),
        ),
      );
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: videoStart['message']);
    }
  }

  Future<void> _handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
        [PermissionGroup.camera, PermissionGroup.microphone]);
  }

  @override
  void initState() {
    super.initState();
    channelName = widget.user.username;
    getBatch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Video'),
        backgroundColor: Colors.black.withOpacity(0.95),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Text('Select Batches for Live Video',
                style: TextStyle(fontSize: 15)),
            Visibility(
              visible: !loaded,
              child: Center(child: CircularProgressIndicator()),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: batchValues.length,
                itemBuilder: (BuildContext context, int index) {
                  if (batchValues.length == 0) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return CheckboxListTile(
                      title: Text(batchValues[index]['name']),
                      value: batchValues[index]['value'],
                      onChanged: (bool value) {
                        setState(() {
                          batchValues[index]['value'] = value;
                        });
                      },
                    );
                  }
                },
              ),
            ),
            Text('Select Quality of Live Video:',
                style: TextStyle(fontSize: 25)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    new Radio(
                      value: 0,
                      groupValue: _radioValue,
                      onChanged: _handleRadioValueChange,
                    ),
                new Text(
                  'Low',
                  style: new TextStyle(fontSize: 16.0),
                ),

                  ],
                ),
                Column(
                  children: <Widget>[
                    new Radio(
                      value: 1,
                      groupValue: _radioValue,
                      onChanged: _handleRadioValueChange,
                    ),
                new Text(
                  'Medium',
                  style: new TextStyle(
                    fontSize: 16.0,
                  ),
                ),

                  ],
                ),
                Column(
                  children: <Widget>[
                    new Radio(
                      value: 2,
                      groupValue: _radioValue,
                      onChanged: _handleRadioValueChange,
                    ),
                new Text(
                  'High',
                  style: new TextStyle(fontSize: 16.0),
                ),

                  ],
                ),
                Column(
                  children: <Widget>[
                    new Radio(
                      value: 3,
                      groupValue: _radioValue,
                      onChanged: _handleRadioValueChange,
                    ),
                new Text(
                  'Highest',
                  style: new TextStyle(fontSize: 16.0),
                ),

                  ],
                ),

              ],
            ),
            Visibility(
              visible: loaded,
                          child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                      elevation: 20,
                      child: RaisedButton(
                        onPressed: () async {
                          onJoin();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/go_live.gif',
                            height: 150,
                          ),
                        ),
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
    });
  }
}
