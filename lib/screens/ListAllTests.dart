import 'package:bodhiai_teacher_flutter/data_requests/requests.dart';
import 'package:bodhiai_teacher_flutter/pojo/basic.dart';
import 'package:bodhiai_teacher_flutter/screens/IndividualTestDetail.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ListAllTests extends StatefulWidget {
  TeacherUser user = TeacherUser();
  ListAllTests(this.user);
  @override
  State<StatefulWidget> createState() {
    return _ListAllTests(user);
  }
}

class _ListAllTests extends State<ListAllTests> {
  TeacherUser user = TeacherUser();
  _ListAllTests(this.user);
  double listSize;
  final GlobalKey _testList = GlobalKey();

  getListSize() {
    RenderBox _listBox = _testList.currentContext.findRenderObject();
    setState(() {
      listSize = _listBox.size.width;
      print(listSize);
    });
  }

  showDeleteDialog(context, testId) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 200,
              child: Column(
                children: <Widget>[
                  Text('Are you sure you want to delete this test?',
                      style: TextStyle(fontSize: 20)),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RaisedButton(
                        color: Colors.black,
                        child: Text('Delete',
                            style: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          var response =
                              await postDeleteTests(widget.user.key, testId);
                          Fluttertoast.showToast(msg: response['message']);
                          Navigator.pop(context);
                        },
                      ),
                      RaisedButton(
                        color: Colors.white,
                        child: Text('Cancel',
                            style: TextStyle(color: Colors.black)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getListSize());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Tests'),
        backgroundColor: Colors.black.withOpacity(0.95),
      ),
      body: Column(
        children: <Widget>[
          FutureBuilder(
            future: getAllCreatedTests(user.key),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.data != null) {
                var tests = snapshot.data['tests'];
                return Expanded(
                  key: _testList,
                  child: ListView.builder(
                    itemCount: tests.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onLongPress: () {
                          showDeleteDialog(context, tests[index]['id'])
                              .then((_) => setState(() {}));
                        },
                        child: ListTile(
                          title: Center(
                            child: Text(tests[index]['publisehd']
                                .toString()
                                .split('T')[0]
                                .toString()),
                          ),
                          leading: Icon(Icons.theaters),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text('Number Questions:' +
                                      tests[index]['numberQuestions']
                                          .toString()),
                                  Divider(),
                                  Text('Test length:' +
                                      tests[index]['time'].toString() +
                                      ' min')
                                ],
                              ),
                              Container(
                                height: 30,
                                width: 200,
                                child: ListView.builder(
                                  itemCount: tests[index]['subjects'].length,
                                  itemBuilder:
                                      (BuildContext context, int subIndex) {
                                    return Text(
                                      "Subjects:" +
                                          tests[index]['subjects'][subIndex]
                                              ['name'],
                                      style: TextStyle(fontSize: 15),
                                    );
                                  },
                                ),
                              ),
                              Container(
                                height: 30,
                                width: 200,
                                child: ListView.builder(
                                  itemCount: tests[index]['chapters'].length,
                                  itemBuilder:
                                      (BuildContext context, int subIndex) {
                                    return Text(
                                      "Chapters:" +
                                          tests[index]['chapters'][subIndex]
                                              ['name'],
                                      style: TextStyle(fontSize: 15),
                                    );
                                  },
                                ),
                              ),
                              Divider(
                                color: Colors.orangeAccent,
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => IndividualTestDetail(
                                        user, tests[index]['id'])));
                          },
                        ),
                      );
                    },
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          )
        ],
      ),
    );
  }
}
