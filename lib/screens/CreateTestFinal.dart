import 'package:bodhiai_teacher_flutter/data_requests/requests.dart';
import 'package:bodhiai_teacher_flutter/pojo/basic.dart';
import 'package:bodhiai_teacher_flutter/screens/HomeScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreateTestFinal extends StatefulWidget {
  TeacherUser user = TeacherUser();
  var questions;
  CreateTestFinal(this.user, this.questions);
  @override
  State<StatefulWidget> createState() {
    return _CreateTestFinal(user, questions);
  }
}

class _CreateTestFinal extends State<CreateTestFinal> {
  TeacherUser user = TeacherUser();
  var questions;
  List<int> finalQuestions = [];
  Map<int, bool> batchValues = {};
  TextEditingController timeController = TextEditingController();
  _CreateTestFinal(this.user, this.questions);
  testGetBatches(key) async {
    var batches = await getAllBatches(key);
    return batches;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Test'),
        backgroundColor: Colors.black.withOpacity(0.95),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            TextField(
              controller: timeController,
              decoration: InputDecoration(hintText: 'Enter Timing of the test'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text('+' + questions[index]['marks'].toString()),
                            Text('-' +
                                questions[index]['negativeMarks'].toString()),
                          ],
                        ),
                        isQuestionText(questions[index]['text'])
                            ? Text(questions[index]['text'])
                            : Container(
                                height: 0,
                              ),
                        isQuestionPicture(questions[index]['picture'])
                            ? CachedNetworkImage(
                                imageUrl: questions[index]['picture'],
                                placeholder: (context, url) {
                                  return CircularProgressIndicator();
                                },
                              )
                            : Container(
                                height: 0,
                              ),
                        Divider(
                          color: Colors.orange,
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ButtonTheme(
                minWidth: MediaQuery.of(context).size.width,
                child: RaisedButton(
                  child: Text(
                    'Create Test',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.black.withOpacity(0.95),
                  onPressed: () async {
                    if (timeController.text == null ||
                        timeController.text == '') {
                      Fluttertoast.showToast(
                          msg: 'Please select timnig of the test');
                    } else {
                      var batches = await testGetBatches(user.key);

                      for (var quest in questions) {
                        finalQuestions.add(quest['id']);
                      }
                      showDialog(
                          context: context,
                          builder: (context) {
                            return TestBatchSelection(user, batches.batches,
                                finalQuestions, int.parse(timeController.text));
                          });
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TestBatchSelection extends StatefulWidget {
  TeacherUser user = TeacherUser();
  var batches;
  List<int> questions;
  int timing;

  TestBatchSelection(this.user, this.batches, this.questions, this.timing);
  @override
  State<StatefulWidget> createState() {
    return _TestBatchSelection(user, batches, questions, timing);
  }
}

class _TestBatchSelection extends State<TestBatchSelection> {
  TeacherUser user = TeacherUser();
  var batches;
  List<int> questions;
  int timing;
  Map<int, bool> batchValues = {};
  _TestBatchSelection(this.user, this.batches, this.questions, this.timing);
  batchesCheckBox(batches) {
    setState(() {
      for (var batch in batches) {
        batchValues[batch.id] = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    batchesCheckBox(batches);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                child: Text(
              'Select Batches to give test to',
              style: TextStyle(fontSize: 20),
            )),
          ),
          Divider(color: Colors.black),
          Expanded(
            child: Container(
              child: ListView.builder(
                itemCount: batches.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(batches[index].name),
                    leading: Icon(Icons.border_outer),
                    trailing: Checkbox(
                      value: batchValues[batches[index].id],
                      onChanged: (bool value) {
                        setState(() {
                          batchValues[batches[index].id] = value;
                        });
                      },
                    ),
                    onTap: () {
                      setState(() {
                        batches.add(batches[index].id);
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              color: Colors.black,
              onPressed: () async {
                List<int> batchesToGive = [];
                for (var batch in batches) {
                  if (batchValues[batch.id] == true) {
                    batchesToGive.add(batch.id);
                  }
                }
                var response =  teacherCreateTest(
                    user.key, questions, batchesToGive, timing);
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomeScreen(user)));

                   Fluttertoast.showToast(msg: 'Test successfullly created !!');
                // if (response['status'] == 'Success') {
                  // Fluttertoast.showToast(msg: 'Test successfullly created !!');
                // } else {
                  // Fluttertoast.showToast(
                      // msg: 'Failed ! ' + response['message'].toString());
                // }
              },
              child: Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
