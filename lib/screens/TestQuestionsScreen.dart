import 'dart:math';

import 'package:bodhiai_teacher_flutter/data_requests/requests.dart';
import 'package:bodhiai_teacher_flutter/pojo/basic.dart';
import 'package:bodhiai_teacher_flutter/screens/CreateTestFinal.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TestQuestionsScreen extends StatefulWidget {
  TeacherUser user = TeacherUser();
  TestQuestionsScreen(this.user);
  @override
  State<StatefulWidget> createState() {
    return _TestQuestionsScreen(user);
  }
}

class _TestQuestionsScreen extends State<TestQuestionsScreen> {
  int subjectId;
  int chapterId;
  String subjectText = 'Choose a subject';
  String chapterText = 'First choose a subject';
  bool callQuestions = false;
  List seletedQuestionsList = [];
  int selected = 0;
  double totalMarks = 0;
  Color selectedColor = Colors.white;
  List finalQuestionsList = [];
  TeacherUser user = TeacherUser();
  _TestQuestionsScreen(this.user);

  showSubjectDialog(subjects) {
    return showDialog(
        context: context,
        builder: (context) {
          return Container(
            height: 300,
            width: 200,
            child: AlertDialog(
              title: Text('Subjects'),
              content: Container(
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  itemCount: subjects.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(subjects[index]['name']),
                      leading: Icon(Icons.border_outer),
                      onTap: () {
                        setState(() {
                          subjectId = subjects[index]['id'];
                          subjectText = subjects[index]['name'];
                          chapterText = 'Choose a chapter';
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
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
                ),
              ],
            ),
          );
        });
  }

  showChapterDialog(chapters) {
    return showDialog(
        context: context,
        builder: (context) {
          return Container(
            height: 300,
            width: 200,
            child: AlertDialog(
              title: Text('Chapters'),
              content: Container(
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  itemCount: chapters.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(chapters[index]['name']),
                      leading: Icon(Icons.border_outer),
                      onTap: () {
                        setState(() {
                          chapterId = chapters[index]['id'];
                          chapterText = chapters[index]['name'];
                          callQuestions = true;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
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
                ),
              ],
            ),
          );
        });
  }

  showChapterQuestions(key, chapterId) async {
    var questionsResponse = await getChaperQuestions(key, chapterId);
    return questionsResponse['questions'];
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

  isQuestionInPaper(questionId) {
    if (seletedQuestionsList.contains(questionId)) {
      return Colors.green.withOpacity(0.2);
    } else {
      return Colors.white;
    }
  }

  isTestPaperEmpty() {
    if (seletedQuestionsList.length == 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Test'),
        backgroundColor: Colors.green
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ButtonTheme(
                minWidth: MediaQuery.of(context).size.width,
                child: RaisedButton(
                   shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                    color: Colors.lightBlue,
                    onPressed: () async {
                      var subjectsResponse = await getAllSubjects(user.key);
                      var subjects = subjectsResponse['subjects'];
                      showSubjectDialog(subjects);
                    },
                    child: Text(
                      subjectText,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ButtonTheme(
                minWidth: MediaQuery.of(context).size.width,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                    color: Colors.lightBlue,
                    onPressed: () async {
                      if (subjectId == null) {
                        var subjectsResponse = await getAllSubjects(user.key);
                        var subjects = subjectsResponse['subjects'];
                        showSubjectDialog(subjects);
                      } else {
                        var chaptersResponse =
                            await getSubjectChapters(user.key, subjectId);
                        var chapters = chaptersResponse['chapters'];
                        showChapterDialog(chapters);
                      }
                    },
                    child: Text(
                      chapterText,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text('Selected: ' + selected.toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                  Text('Total Marks: ' + totalMarks.toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                ],
              ),
            ),
            Divider(
              height: sqrt1_2,
              color: Colors.green,
            ),
            callQuestions
                ? FutureBuilder(
                    future: showChapterQuestions(user.key, chapterId),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.data != null) {
                        var questions = snapshot.data;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                              itemCount: questions.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      int questionIndex =
                                          questions[index]['id'];
                                      if (!seletedQuestionsList
                                          .contains(questionIndex)) {
                                        seletedQuestionsList
                                            .add(questions[index]['id']);
                                        selected = seletedQuestionsList.length;
                                        selectedColor = Colors.orange;
                                        totalMarks += questions[index]['marks'];
                                        finalQuestionsList
                                            .add(questions[index]);
                                      } else {
                                        seletedQuestionsList
                                            .remove(questionIndex);
                                        selected = seletedQuestionsList.length;
                                        selectedColor = Colors.white;
                                        totalMarks -= questions[index]['marks'];
                                        finalQuestionsList
                                            .remove(questions[index]);
                                      }
                                    });
                                  },
                                  child: Container(
                                    color: isQuestionInPaper(
                                        questions[index]['id']),
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Text('+' +
                                                  questions[index]['marks']
                                                      .toString()),
                                              Text('-' +
                                                  questions[index]
                                                          ['negativeMarks']
                                                      .toString()),
                                            ],
                                          ),
                                        ),
                                        isQuestionText(questions[index]['text'])
                                            ? Text(questions[index]['text'])
                                            : Container(
                                                height: 0,
                                              ),
                                        isQuestionPicture(
                                                questions[index]['picture'])
                                            ? CachedNetworkImage(
                                                imageUrl: questions[index]
                                                    ['picture'],
                                                placeholder: (context, url) {
                                                  return CircularProgressIndicator();
                                                },
                                              )
                                            : Container(
                                                height: 0,
                                              ),
                                        Divider(
                                          color: Colors.orange,
                                        ),
                                        SizedBox(
                                          height: 20,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      } else {
                        return Center(child: CircularProgressIndicator(backgroundColor: Colors.red,));
                      }
                    },
                  )
                : Container(
                    height: 0,
                  ),
            isTestPaperEmpty()
                ? Container(
                    height: 0,
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ButtonTheme(
                      minWidth: MediaQuery.of(context).size.width,
                      child: RaisedButton(
                        color: Colors.green,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateTestFinal(
                                      user, finalQuestionsList)));
                        },
                        child: Text(
                          'Create Test',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
