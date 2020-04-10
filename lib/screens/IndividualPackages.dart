import 'package:bodhiai_teacher_flutter/data_requests/requests.dart';
import 'package:bodhiai_teacher_flutter/pojo/basic.dart';
import 'package:bodhiai_teacher_flutter/screens/SeeVideos.dart';
import 'package:bodhiai_teacher_flutter/screens/SingleVideoPlayer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class IndividualPackages extends StatefulWidget {
  TeacherUser user = TeacherUser();
  var packageId;
  IndividualPackages(this.user, this.packageId);

  @override
  State<StatefulWidget> createState() {
    return _IndividualPackages();
  }
}

class _IndividualPackages extends State<IndividualPackages> {
  getPackageDetails(key, packageId) async {
    var packageDetails = await getIndividualPackage(key, packageId);
    print('individual package ${packageDetails.toString()}');
    return packageDetails;
  }

  @override
  void initState() {
    super.initState();
    getPackageDetails(widget.user.key, widget.packageId);
  }

  addTestDialogBox(BuildContext context, tests) {
    return showDialog(
        context: context,
        builder: (context) {
          return Container(
            height: 300,
            width: 200,
            child: AlertDialog(
              title: Text('Tests'),
              content: Container(
                height: MediaQuery.of(context).size.height - 20,
                width: MediaQuery.of(context).size.width - 20,
                child: ListView.builder(
                    itemCount: tests.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: Icon(Icons.check),
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              tests[index]['published'].split('T')[0] +
                                  '(' +
                                  tests[index]['numberQuestions'].toString() +
                                  ')',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Subject: ' +
                                  tests[index]['subjects']
                                      .toString()
                                      .replaceAll('[', '')
                                      .replaceAll(']', '')),
                              Text('Chapter: ' +
                                  tests[index]['chapters']
                                      .toString()
                                      .replaceAll('[', '')
                                      .replaceAll(']', '')),
                              Divider(
                                height: 5,
                                color: Colors.orange,
                              )
                            ],
                          ),
                          onTap: () async {
                            var testsAdded = await packageAddTest(
                                widget.user.key,
                                [tests[index]['id']],
                                widget.packageId);
                            print('is video added ${testsAdded.toString()}');
                            Navigator.pop(context);
                            Fluttertoast.showToast(
                                msg: 'Test Added Successfully');
                          },
                        ),
                      );
                    }),
              ),
              actions: <Widget>[
                RaisedButton(
                  child: Text(
                    'Close',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.black.withOpacity(0.95),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          );
        });
  }

  addVideoDialogBox(BuildContext context, videos) {
    return showDialog(
        context: context,
        builder: (context) {
          return Container(
            height: 300,
            width: 200,
            child: AlertDialog(
              title: Text('Videos'),
              content: Container(
                height: MediaQuery.of(context).size.height - 20,
                width: MediaQuery.of(context).size.width - 20,
                child: ListView.builder(
                    itemCount: videos.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: Icon(Icons.video_call),
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              videos[index]['title'],
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Subject: ' + videos[index]['subject']),
                              Text('Chapter: ' + videos[index]['chapter']),
                              Divider(
                                height: 5,
                                color: Colors.orange,
                              )
                            ],
                          ),
                          onTap: () async {
                            var videoAdded = await packageAddVideo(
                                widget.user.key,
                                [videos[index]['id']],
                                widget.packageId);
                            print('is video added ${videoAdded.toString()}');
                            Navigator.pop(context);
                            Fluttertoast.showToast(
                                msg: 'Video Added Successfully');
                          },
                        ),
                      );
                    }),
              ),
              actions: <Widget>[
                RaisedButton(
                  child: Text(
                    'Close',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.black.withOpacity(0.95),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          );
        });
  }

// show list of notes in a dialogbox when clicked on Add Notes button
  addNotesDialogBox(BuildContext context, notes) {
    return showDialog(
        context: context,
        builder: (context) {
          return Container(
            height: 300,
            width: 200,
            child: AlertDialog(
              title: Text('Notes'),
              content: Container(
                height: MediaQuery.of(context).size.height - 20,
                width: MediaQuery.of(context).size.width - 20,
                child: ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: Icon(Icons.border_color),
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              notes[index]['title'],
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Subject: ' + notes[index]['subject_name']),
                              Text('Chapter: ' + notes[index]['chapter_name']),
                              Divider(
                                height: 5,
                                color: Colors.orange,
                              )
                            ],
                          ),
                          onTap: () async {
                            var videoAdded = await packageAddNote(
                                widget.user.key,
                                [notes[index]['id']],
                                widget.packageId);
                            print('is note added ${videoAdded.toString()}');
                            Navigator.pop(context);
                            Fluttertoast.showToast(
                                msg: 'Note Added Successfully');
                          },
                        ),
                      );
                    }),
              ),
              actions: <Widget>[
                RaisedButton(
                  child: Text(
                    'Close',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.black.withOpacity(0.95),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          );
        });
  }

  dialogNoteDelete(BuildContext context, noteId) {
    return showDialog(
        context: context,
        builder: (context) {
          return Container(
            height: 300,
            width: 200,
            child: AlertDialog(
              title: Text('Delete this Note?'),
              content: Text(
                  'Are you sure you want to remove this note from the package?'),
              actions: <Widget>[
                RaisedButton(
                  child: Text(
                    'Yes',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.black.withOpacity(0.95),
                  onPressed: () async {
                    var deleteNote = await packageRemoveNote(
                        widget.user.key, noteId, widget.packageId);
                    print('dete note ? ${deleteNote.toString()}');
                    Navigator.pop(context);
                    Fluttertoast.showToast(msg: deleteNote['message']);
                  },
                ),
                RaisedButton(
                  child: Text(
                    'No',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.black.withOpacity(0.95),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          );
        });
  }

  dialogTestDelete(BuildContext context, testId) {
    return showDialog(
        context: context,
        builder: (context) {
          return Container(
            height: 300,
            width: 200,
            child: AlertDialog(
              title: Text('Delete this Test?'),
              content: Text(
                  'Are you sure you want to remove this test from the package?'),
              actions: <Widget>[
                RaisedButton(
                  child: Text(
                    'Yes',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.black.withOpacity(0.95),
                  onPressed: () async {
                    var deleteTest = await packageRemoveTest(
                        widget.user.key, testId, widget.packageId);
                    print('dete note ? ${deleteTest.toString()}');
                    Navigator.pop(context);
                    Fluttertoast.showToast(msg: deleteTest['message']);
                  },
                ),
                RaisedButton(
                  child: Text(
                    'No',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.black.withOpacity(0.95),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          );
        });
  }

  dialogVideoDelete(BuildContext context, videoId) {
    return showDialog(
        context: context,
        builder: (context) {
          return Container(
            height: 300,
            width: 200,
            child: AlertDialog(
              title: Text('Delete this Video?'),
              content: Text(
                  'Are you sure you want to remove this video from the package?'),
              actions: <Widget>[
                RaisedButton(
                  child: Text(
                    'Yes',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.black.withOpacity(0.95),
                  onPressed: () async {
                    var deleteNote = await packageRemoveVideo(
                        widget.user.key, videoId, widget.packageId);
                    print('delete video ? ${deleteNote.toString()}');
                    Navigator.pop(context);
                    Fluttertoast.showToast(msg: deleteNote['message']);
                  },
                ),
                RaisedButton(
                  child: Text(
                    'No',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.black.withOpacity(0.95),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Package'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RaisedButton(
                  color: Colors.white,
                  onPressed: () async {
                    var notes = await getUploadedNotes(widget.user.key);
                    print(notes['notes']);
                    if (notes != null) {
                      addNotesDialogBox(context, notes['notes'])
                          .then((_) => setState(() {}));
                    }
                  },
                  child: Text('Add notes'),
                ),
                RaisedButton(
                  color: Colors.white,
                  onPressed: () async {
                    var videos = await getUploadedVideos(widget.user.key);
                    print(videos['videos']);
                    if (videos != null) {
                      addVideoDialogBox(context, videos['videos'])
                          .then((_) => setState(() {}));
                    }
                  },
                  child: Text('Add Videos'),
                ),
                RaisedButton(
                  color: Colors.white,
                  onPressed: () async {
                    var tests = await getUploadedTests(widget.user.key);
                    print(tests['tests']);
                    if (tests != null) {
                      addTestDialogBox(context, tests['tests'])
                          .then((_) => setState(() {}));
                    }
                  },
                  child: Text('Add Tests'),
                )
              ],
            ),
          ),
        ),
        backgroundColor: Color(0xFFFF4700).withOpacity(0.95),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: getPackageDetails(widget.user.key, widget.packageId),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.data == null) {
              return CircularProgressIndicator();
            } else {
              var packageDetails = snapshot.data['package'];
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Text(
                      'Name:' + packageDetails['title'].replaceAll('\"', ''),
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        'Price:' + packageDetails['price'].toString(),
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                          'Duration:' +
                              packageDetails['duration'].toString() +
                              ' days',
                          style: TextStyle(fontSize: 15)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                          'Videos:' + packageDetails['numberVideos'].toString(),
                          style: TextStyle(fontSize: 15)),
                      Text('Notes:' + packageDetails['numberNotes'].toString(),
                          style: TextStyle(fontSize: 15)),
                    ],
                  ),
                  Center(
                      child: Text(
                    'Details:' + packageDetails['details'],
                    style: TextStyle(fontSize: 20),
                  )),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Videos',
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      height: 100,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: packageDetails['videos'].length,
                          itemBuilder: (context, index) {
                            return Container(
                              height: 100,
                              width: MediaQuery.of(context).size.width / 2,
                              child: Card(
                                elevation: 2,
                                child: ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: Text(packageDetails['videos'][index]
                                        ['title']),
                                  ),
                                  leading: Icon(Icons.video_call),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Divider(
                                          thickness: 2, color: Colors.orange),
                                      Text('Subject ' +
                                          packageDetails['videos'][index]
                                              ['subject']),
                                      Text('Chapter ' +
                                          packageDetails['videos'][index]
                                              ['chapter']),
                                    ],
                                  ),
                                  onTap: () async {
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SingleVideoPlayer(
                                                  packageDetails['videos']
                                                      [index]['title'],
                                                  packageDetails['videos']
                                                      [index]['url'],
                                                )));
                                  },
                                  onLongPress: () {
                                    print(packageDetails['videos'][index]
                                        ['video_id']);
                                    dialogVideoDelete(
                                            context,
                                            packageDetails['videos'][index]
                                                ['video_id'])
                                        .then((_) => setState(() {}));
                                  },
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Notes',
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      height: 100,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: packageDetails['notes'].length,
                          itemBuilder: (context, index) {
                            return Container(
                              height: 100,
                              width: MediaQuery.of(context).size.width / 2,
                              child: Card(
                                elevation: 2,
                                child: ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: Text(packageDetails['notes'][index]
                                        ['title']),
                                  ),
                                  leading: Icon(Icons.border_color),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Divider(
                                          thickness: 2, color: Colors.orange),
                                      Text('Subject ' +
                                          packageDetails['notes'][index]
                                              ['subject']),
                                      Text('Chapter ' +
                                          packageDetails['notes'][index]
                                              ['chapter']),
                                    ],
                                  ),
                                  onTap: () {
                                    print('note');
                                  },
                                  onLongPress: () {
                                    print(packageDetails['notes'][index]
                                        ['note_id']);
                                    dialogNoteDelete(
                                            context,
                                            packageDetails['notes'][index]
                                                ['note_id'])
                                        .then((_) => setState(() {}));
                                  },
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Tests',
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      height: 100,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: packageDetails['tests'].length,
                          itemBuilder: (context, index) {
                            return Container(
                              height: 100,
                              width: MediaQuery.of(context).size.width / 2,
                              child: Card(
                                elevation: 2,
                                child: ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: Text(packageDetails['tests'][index]
                                            ['publisehd']
                                        .split('T')[0]),
                                  ),
                                  leading: Icon(Icons.check_box),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Divider(
                                            thickness: 2, color: Colors.orange),
                                        Text(
                                            packageDetails['tests'][index]
                                                    ['subject']
                                                .toString()
                                                .replaceAll('[', '')
                                                .replaceAll(']', '')),
                                        Text('Questions: ' +
                                            packageDetails['tests'][index]
                                                    ['numberQuestions']
                                                .toString()),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    print('test');
                                  },
                                  onLongPress: () {
                                    print(packageDetails['tests'][index]['id']);
                                    dialogTestDelete(
                                            context,
                                            packageDetails['tests'][index]
                                                ['id'])
                                        .then((_) => setState(() {}));
                                  },
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                  Container(
                    height: 20,
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
