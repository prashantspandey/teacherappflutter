import 'package:bodhiai_teacher_flutter/pojo/basic.dart';
import 'package:flutter/material.dart';
import 'package:bodhiai_teacher_flutter/data_requests/requests.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreateFees extends StatefulWidget {
  TeacherUser user = TeacherUser();
  var student;
  CreateFees(this.user, this.student);
  @override
  _CreateFeesState createState() => _CreateFeesState(user, student);
}

class _CreateFeesState extends State<CreateFees> {
  TeacherUser user = TeacherUser();
  var student;
  TextEditingController totalFeesController = TextEditingController();
  TextEditingController paidFeesController = TextEditingController();
  TextEditingController courseDuration = TextEditingController();
  DateTime _dateTime = DateTime.now();
  _CreateFeesState(this.user, this.student);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Fees'),
        backgroundColor: Colors.black.withOpacity(0.95),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text(student.name),
            TextField(
              keyboardType: TextInputType.number,
              controller: totalFeesController,
              decoration:
                  InputDecoration(hintText: 'Total Fees of student in Rs.'),
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: paidFeesController,
              decoration: InputDecoration(hintText: 'Fees Paid in Rs.'),
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: courseDuration,
              decoration:
                  InputDecoration(hintText: 'Duration of course in days'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_dateTime.toString().split(' ')[0].toString()),
            ),
            RaisedButton(
              color: Colors.orange,
              onPressed: () {
                showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2015),
                        lastDate: DateTime(2025))
                    .then((value) {
                  setState(() {
                    _dateTime = value;
                  });
                });
              },
              child: Text(
                'Select date',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ButtonTheme(
                minWidth: MediaQuery.of(context).size.width,
                child: RaisedButton(
                  child: Text(
                    'Create Fees',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.black.withOpacity(0.95),
                  onPressed: () async {
                    var response = await teacherCreateFees(
                        user.key,
                        student.id,
                        double.parse(totalFeesController.text),
                        double.parse(paidFeesController.text),
                        _dateTime.toString().split(' ')[0].toString());
                    if (response['status'] == 'Success') {
                      Fluttertoast.showToast(msg: response['message']);
                      Navigator.pop(context, () {
                        setState(() {});
                      });
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
