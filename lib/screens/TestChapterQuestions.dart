import 'package:bodhiai_teacher_flutter/pojo/basic.dart';
import 'package:flutter/material.dart';

class TestChapterQuestions extends StatefulWidget {
  TeacherUser user = TeacherUser();
  int chapterId;
  TestChapterQuestions(this.user, this.chapterId);
  @override
  State<StatefulWidget> createState() {
    return _TestChapterQuestions(user, chapterId);
  }
}

class _TestChapterQuestions extends State<TestChapterQuestions> {
  TeacherUser user = TeacherUser();
  int chapterId;
  _TestChapterQuestions(this.user, this.chapterId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Questions'),
      ),
    );
  }
}
