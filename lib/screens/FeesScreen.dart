import 'package:bodhiai_teacher_flutter/data_requests/requests.dart';
import 'package:bodhiai_teacher_flutter/pojo/basic.dart';
import 'package:bodhiai_teacher_flutter/screens/CreateFees.dart';
import 'package:bodhiai_teacher_flutter/screens/IndividualFeesDetail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FeesScreen extends StatefulWidget {
  TeacherUser user = TeacherUser();
  FeesScreen(this.user);
  @override
  State<StatefulWidget> createState() {
    return _FeesScreen(user);
  }
}

class _FeesScreen extends State<FeesScreen> {
  TeacherUser user = TeacherUser();
  _FeesScreen(this.user);
  var currentStudent;
  selectStudent(BuildContext context, students) {
    return showDialog(
        context: context,
        builder: (context) {
          return Container(
            height: 500,
            width: 200,
            child: AlertDialog(
              title: Text('Students'),
              content: Container(
                height: MediaQuery.of(context).size.height - 20,
                width: MediaQuery.of(context).size.width - 20,
                child: ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                                students[index].details['photo']),
                          ),
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              students[index].name,
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  'Phone: ' + students[index].details['phone']),
                              Divider(
                                height: 5,
                                color: Colors.orange,
                              )
                            ],
                          ),
                          onTap: () async {
                            currentStudent = students[index];
                            Navigator.pop(context);
                            Fluttertoast.showToast(
                                msg: '${students[index].name} Create Fees');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CreateFees(user, currentStudent)));
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

  feesDetailsDialog(BuildContext context, feesDetails) {
    double dueAmount = feesDetails['totalFees'] - feesDetails['totalPaid'];
    return showDialog(
        context: context,
        builder: (context) {
          return Container(
            height: 500,
            width: 200,
            child: AlertDialog(
              title: Text('Fees Details'),
              content: Container(
                  height: MediaQuery.of(context).size.height - 20,
                  width: MediaQuery.of(context).size.width - 20,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                                feesDetails['student']['photo']),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(feesDetails['student']['name']),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text("Total Fees "),
                                Divider(
                                  height: 5,
                                  color: Colors.black,
                                ),
                                Text(
                                  '₹' + feesDetails['totalFees'].toString(),
                                  style: TextStyle(fontSize: 20),
                                )
                              ],
                            ),
                            Divider(
                              color: Colors.black,
                            ),
                            Column(
                              children: <Widget>[
                                Text("Fees paid "),
                                Divider(
                                  height: 5,
                                  color: Colors.black,
                                ),
                                Text(
                                  '₹' + feesDetails['totalPaid'].toString(),
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                            Divider(
                              color: Colors.black,
                            ),
                            Column(
                              children: <Widget>[
                                Text("Due "),
                                Divider(
                                  height: 5,
                                  color: Colors.black,
                                ),
                                Text(
                                  '₹' + dueAmount.toString(),
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.black,
                      ),
                      Text('History'),
                      Expanded(
                        child: ListView.builder(
                          itemCount: feesDetails['history'].length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Text('₹' +
                                  feesDetails['history'][index]['amountPaid']
                                      .toString()),
                              trailing: Text(feesDetails['history'][index]
                                      ['date']
                                  .toString()
                                  .split('T')[0]
                                  .toString()),
                            );
                          },
                        ),
                      )
                    ],
                  )),
              actions: <Widget>[
                RaisedButton(
                  child: Text(
                    'Add Payment',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.black.withOpacity(0.95),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fees'),
        backgroundColor: Colors.black.withOpacity(0.95),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var students = await getAllStudents(user.key);
          selectStudent(context, students.students)
              .then((_) => setState(() {}));
        },
        child: Icon(Icons.add),
      ),
      body: Column(
        children: <Widget>[
          FutureBuilder(
            future: teacherGetAllFees(user.key),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.data != null) {
                var fees = snapshot.data['fees'];
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: fees.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                                fees[index]['student']['photo']),
                          ),
                          title: Text(fees[index]['student']['name'] +
                              '  (' +
                              fees[index]['duration'].toString() +
                              ' days)  ' +
                              fees[index]['history'].length.toString() +
                              ' installment'),
                          subtitle: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Fees: ₹' +
                                          fees[index]['totalFees'].toString(),
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Spacer(),
                                    Text(
                                      'Paid: ₹' +
                                          fees[index]['totalPaid'].toString(),
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                                Divider(
                                  color: Colors.orange,
                                ),
                              ],
                            ),
                          ),
                          onTap: () async {
                            var response = await getIndividualFeeDetails(
                                user.key, fees[index]['id']);
                            var feesDetails = response['fees_details'];
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => IndividualFeesDetail(
                                        user, feesDetails)));

                            //ifeesDetailsDialog(context, feesDetails)
                            //   .then((_) => setState(() {}));
                          },
                        );
                      },
                    ),
                  ),
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          )
        ],
      ),
    );
  }
}
