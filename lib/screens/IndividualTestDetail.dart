import 'package:bodhiai_teacher_flutter/pojo/basic.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bodhiai_teacher_flutter/data_requests/requests.dart';

class IndividualTestDetail extends StatefulWidget {
  TeacherUser user = TeacherUser();
  int testId;
  IndividualTestDetail(this.user, this.testId);
  @override
  State<StatefulWidget> createState() {
    return _IndividualTestDetail(user, testId);
  }
}

class _IndividualTestDetail extends State<IndividualTestDetail> {
  TeacherUser user = TeacherUser();
  int testId;
  var testDetails;
  _IndividualTestDetail(this.user, this.testId);

  getTestDetails(key) async {
    var response = await getIndividualTestDetails(key, testId);
    setState(() {
      testDetails = response;
    });
  }

  isQuestionText(text) {
    if (text == null || text == 'null') {
      return false;
    } else {
      return true;
    }
  }

  isQuestionPicture(picture) {
    if (picture == null) {
      return false;
    } else {
      return true;
    }
  }

  isQuestionDirectionText(directionText) {
    if (directionText == null) {
      return false;
    } else {
      return true;
    }
  }

  @override
  void initState() {
    super.initState();
    getTestDetails(user.key);
  }

  @override
  Widget build(BuildContext context) {
    print(testDetails.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Details'),
        backgroundColor: Colors.black.withOpacity(0.95),
      ),
      body: testDetails == null? Center(child:CircularProgressIndicator()):Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  testDetails['test']['published']
                      .toString()
                      .split('T')[0]
                      .toString(),
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Subjects: '),
                    ),
                    Container(
                      height: 100,
                      width: 100,
                      child: ListView.builder(
                        itemCount: testDetails['test']['subjects'].length,
                        itemBuilder: (BuildContext context, int index) {
                          return Text(
                              testDetails['test']['subjects'][index]['name']);
                        },
                      ),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Chapters:',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    Container(
                      height: 100,
                      width: 100,
                      child: ListView.builder(
                        itemCount: testDetails['test']['chapters'].length,
                        itemBuilder: (BuildContext context, int index) {
                          return Text(testDetails['test']['chapters'][index]
                                  ['name'] +
                              ',');
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: testDetails['test']['questions'].length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: <Widget>[
                      testDetails['test']['questions'][index]['text'] == null
                          ? Container(
                              height: 0,
                            )
                          : Text(testDetails['test']['questions'][index]
                              ['text']),
                      testDetails['test']['questions'][index]['picture'] !=
                              null
                          ? CachedNetworkImage(
                              imageUrl: testDetails['test']['questions']
                                  [index]['picture'])
                          : Container(
                              height: 0,
                            ),
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
