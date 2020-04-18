import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:bodhiai_teacher_flutter/data_requests/requests.dart';
import 'package:bodhiai_teacher_flutter/pojo/basic.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wakelock/wakelock.dart';

class CallPage extends StatefulWidget {
  /// non-modifiable channel name of the page
  final String channelName;
  final String APP_ID;
  final videoId;
  final TeacherUser user;
  final qualitySelected;

  /// Creates a call page with given channel name.
  const CallPage(this.APP_ID, this.videoId, this.user, this.qualitySelected,
      {Key key, this.channelName})
      : super(key: key);

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  static final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  bool broadCaster = true;
  Timer timer;
  int numberUsers = 0;
  int totalStudents = 0;
  List<String> messages = [];
  ScrollController _scrollController = ScrollController();

showLoader(context){
  return showDialog(context: context,barrierDismissible: false,builder:(context){
    return AlertDialog(content: Container(height:100,child: Center(child: CircularProgressIndicator(),)),);
  });
}

  exitDialog(context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Do you want to exit live video?'),
            actions: <Widget>[
              RaisedButton(
                color: Colors.deepOrangeAccent,
                child: Text(
                  'End Video',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: ()  {
                  _onCallEnd(context);
                },
              ),
              RaisedButton(
                color: Colors.black,
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  getLiveStudentInformation() async{
    var response = await liveVideoStudents(widget.user.key,widget.videoId);
    var students = response['students'];
    return students;
  }

  getTotalStudents() async {
    var response = await getNumberLiveStudents(widget.user.key, widget.videoId);
    setState(() {
      totalStudents = response['live'];
    });
  }

  getMessages() async {
    var response = await getLiveVideoMessages(widget.user.key, widget.videoId);
    setState(() {
      var mes = response['messages'];
      for (var m in mes) {
        String finalMessage = m['student'] + ': ' + m['message'];
        print('final message $finalMessage');
        if (!messages.contains(finalMessage)) {
          messages.add(finalMessage);
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
          // try{
//
          // _scrollController.jumpTo(_scrollController.position.maxScrollExtent+1);
          // }
          // on Exception catch(e){
          // _scrollController.jumpTo(_scrollController.position.maxScrollExtent);

          //}
        }
      }
    });
    //return response;
  }

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
    timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // initialize agora sdk
    initialize();

    timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
 getMessages();
 getTotalStudents();

    });
    Wakelock.enable();
  }

  getVideoProfile() {
    if (widget.qualitySelected == 0) {
      VideoEncoderConfiguration config = VideoEncoderConfiguration();
      config.degradationPreference = DegradationPreference.MaintainFramerate;
      config.dimensions = Size(180, 180);
      config.frameRate = 15;
      config.orientationMode = VideoOutputOrientationMode.Adaptative;
      config.bitrate = 200;
      return config;
    } else if (widget.qualitySelected == 1) {
      VideoEncoderConfiguration config = VideoEncoderConfiguration();
      config.degradationPreference = DegradationPreference.MaintainFramerate;
      config.dimensions = Size(320, 240);
      config.frameRate = 15;
      config.orientationMode = VideoOutputOrientationMode.Adaptative;
      config.bitrate = 400;
      return config;
    } else if (widget.qualitySelected == 2){
      VideoEncoderConfiguration config = VideoEncoderConfiguration();
      config.degradationPreference = DegradationPreference.MaintainFramerate;
      config.dimensions = Size(640, 480);
      config.frameRate = 15;
      config.orientationMode = VideoOutputOrientationMode.Adaptative;
      config.bitrate = 1000;
      return config;
    }
    else{
      VideoEncoderConfiguration config = VideoEncoderConfiguration();
      config.degradationPreference = DegradationPreference.MaintainFramerate;
      config.dimensions = Size(848, 480);
      config.frameRate = 15;
      config.orientationMode = VideoOutputOrientationMode.Adaptative;
      config.bitrate = 1900;
      return config;

    }
  }

  Future<void> initialize() async {
    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await AgoraRtcEngine.enableWebSdkInteroperability(true);
    await AgoraRtcEngine.setParameters(
        '''{\"che.video.lowBitRateStreamParameter\":{\"width\":160,\"height\":120,\"frameRate\":15,\"bitRate\":130},\"che.video.highBitRateStreamParameter\":{\"width\":640,\"height\":480,\"frameRate\":30,\"bitRate\":1000}}''');
    await AgoraRtcEngine.setParameters(
        '''{\"che.audio.live_for_comm\":true}''');

    await AgoraRtcEngine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await AgoraRtcEngine.setClientRole(ClientRole.Broadcaster);
    var config = getVideoProfile();
    await AgoraRtcEngine.setVideoEncoderConfiguration(config);
    await AgoraRtcEngine.joinChannel(null, widget.channelName, null, 0);
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    await AgoraRtcEngine.create(widget.APP_ID);
    await AgoraRtcEngine.enableVideo();
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    AgoraRtcEngine.onError = (dynamic code) {
      setState(() {
        final info = 'onError: $code';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onJoinChannelSuccess = (
      String channel,
      int uid,
      int elapsed,
    ) {
      setState(() {
        final info = 'onJoinChannel: $channel, uid: $uid';
        _infoStrings.add(info);
        numberUsers += 1;
      });

      print('user joined ${numberUsers.toString()}');
    };

    AgoraRtcEngine.onLeaveChannel = () {
      setState(() {
        numberUsers -= 1;
        _infoStrings.add('onLeaveChannel');
        _users.clear();
      });
      print('user left ${numberUsers.toString()}');
    };

    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      setState(() {
        final info = 'userJoined: $uid';
        _infoStrings.add(info);
        _users.add(uid);
        print('uid  add${uid.toString()}');
        print('number users ${_users.length.toString()}');
        setState(() {
          numberUsers += 1;
        });
      });
    };

    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      setState(() {
        final info = 'userOffline: $uid';
        _infoStrings.add(info);
        _users.remove(uid);
        print('uid remove ${uid.toString()}');
        print('number users ${_users.length.toString()}');
        setState(() {
          numberUsers -= 1;
        });
      });
    };

    AgoraRtcEngine.onFirstRemoteVideoFrame = (
      int uid,
      int width,
      int height,
      int elapsed,
    ) {
      setState(() {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info);
      });
    };
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<AgoraRenderWidget> list = [
      AgoraRenderWidget(0, local: true, preview: true),
    ];
    _users.forEach((int uid) => list.add(AgoraRenderWidget(uid)));

    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[_videoView(views[0])],
        ));
      case 2:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow([views[0]]),
            _expandedVideoRow([views[1]])
          ],
        ));
      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3))
          ],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4))
          ],
        ));
      default:
    }
    return Container();
  }

  Widget _totalStudents() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Container(
          child: Row(
            children: <Widget>[
              Icon(Icons.supervised_user_circle),
              Text(totalStudents.toString()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _liveMessages() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 130.0,top:50),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            itemCount: messages.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Image.asset(
                        'assets/user.png',
                        height: 25,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child:
                          Text(messages[index], style: TextStyle(fontSize: 15)),
                    ),
                  ],
                ),
              );
            },
            controller: _scrollController,
            reverse: true,
            shrinkWrap: true,
          ),
        ),
      ),
    );
  }

  /// Toolbar layout
  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            child: Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          // RawMaterialButton(
          //   onPressed: recording?stopScreenRecord:startScreenRecord,
          //   child: Icon(
          //     Icons.videocam,
          //     color: recording?Colors.red:Colors.blue,
          //     size: 20.0,
          //   ),
          //   shape: CircleBorder(),
          //   elevation: 2.0,
          //   fillColor: Colors.white,
          //   padding: const EdgeInsets.all(12.0),
          // )
        ],
      ),
    );
  }

  /// Info panel to show logs
  Widget _panel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              if (_infoStrings.isEmpty) {
                return null;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _infoStrings[index],
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onCallEnd(BuildContext context)  {
    stopNativeLiveVideo(widget.user.key, widget.videoId);
    timer.cancel();
    Navigator.pop(context);
    dispose();
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    AgoraRtcEngine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    AgoraRtcEngine.switchCamera();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Stack(
            children: <Widget>[
              _viewRows(),
              _panel(),
              _toolbar(),
              _liveMessages(),
              GestureDetector(child: _totalStudents(),
              onTap: ()async{
                showLoader(context);
                  var students = await getLiveStudentInformation();
                  Navigator.pop(context);
                showAllStudentsDialog(context,students);
              }, 
              ),
            ],
          ),
        ),
      ),
      onWillPop: () async {
        return exitDialog(context);
      },
    );
  }

   showAllStudentsDialog(BuildContext context,students) {
     return showDialog(context: context,builder: (context){
                return AlertDialog(content:Container(
                  height: 400,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: ListView.builder(itemCount:students.length, itemBuilder: (BuildContext context, int index) {
                    if(students.length != 0){
                      var date = students[index]['joinTime'].toString().split('T')[0].toString();
                      var time = students[index]['joinTime'].toString().split('T')[1].toString();
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(title: Text(students[index]['student']),
                      leading: Image.asset('assets/user.png',height: 30,), 
                      subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                    Text(students[index]['username']),
                    Text(date),
                    Text('Join Time: '+time.split(':').sublist(0,2).toString()),
                    Divider(color: Colors.orangeAccent,)
                      ],),
                      ),
                  );

                    }
                    else{
                      return Center(child: Text('No information available.'));
                    }
                    },),
                ));
              });
  }
}
