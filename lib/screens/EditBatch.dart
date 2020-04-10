import 'package:bodhiai_teacher_flutter/data_requests/requests.dart';
import 'package:bodhiai_teacher_flutter/pojo/basic.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class EditBatch extends StatefulWidget {
  TeacherUser user = TeacherUser();
  var students;
  var batches;
  List<String> batchNames = [];
  Map<int, dynamic> studentBatches = {};

  EditBatch(this.user, this.students, this.batches, this.batchNames,
      this.studentBatches);

  @override
  State<StatefulWidget> createState() {
    return _EditBatch(user, students, batches, batchNames, studentBatches);
  }
}

class _EditBatch extends State<EditBatch> {
  TeacherUser user = TeacherUser();
  var students;
  var batches;
  List<String> batchNames = [];
  Map<int, dynamic> studentBatches = {};

  _EditBatch(this.user, this.students, this.batches, this.batchNames,
      this.studentBatches);
  @override
  Widget build(BuildContext context) {
    var studs = students.students;
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Batch'),
          backgroundColor: Colors.black.withOpacity(0.95),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView.builder(
            itemCount: studs.length,
            itemBuilder: (context, index) {
              print(
                  'all student batches ${studentBatches[studs[index].id]['Inner']}');
              return ListTile(
                title: Text(studs[index].name),
                leading: CircleAvatar(
                  radius: 20,
                  backgroundImage: CachedNetworkImageProvider(
                    studs[index].details['photo'],
                  ),
                ),
                subtitle: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: batchNames.asMap().entries.map((var att) {
                        return Column(
                          children: <Widget>[
                            Text(att.value),
                            Checkbox(
                              onChanged: (newValue) {
                                setState(() {
                                  print('new value ${newValue.toString()}');
                                  print(
                                      'student batches ${studentBatches[studs[index].id][att.value]}');
                                  print(
                                      'click student batches ${studentBatches[studs[index].id]}');
                                  print(
                                      'click student batches all ${studentBatches.toString()}');

                                  studentBatches[studs[index].id][att.value] =
                                      newValue;
                                });
                              },
                              value: studentBatches[studs[index].id][att.value],
                            ),
                          ],
                        );
                      }).toList()),
                ),
                onTap: () {
                  setState(() {});
                  Navigator.pop(context);
                },
              );
            },
          ),
        ));
  }
}
