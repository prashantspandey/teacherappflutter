import 'package:bodhiai_teacher_flutter/pojo/basic.dart';
import 'package:bodhiai_teacher_flutter/screens/FeatureHomeScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bodhiai_teacher_flutter/data_requests/requests.dart';

class IndividualFeesDetail extends StatefulWidget {
  TeacherUser user = TeacherUser();
  var feesDetails;
  IndividualFeesDetail(this.user, this.feesDetails);
  @override
  State<StatefulWidget> createState() {
    return _IndividualFeesDetail(user, feesDetails);
  }
}

class _IndividualFeesDetail extends State<IndividualFeesDetail> {
  TeacherUser user = TeacherUser();
  var feesDetails;
  double dueAmount;
  _IndividualFeesDetail(this.user, this.feesDetails);
  @override
  Widget build(BuildContext context) {
    dueAmount = feesDetails['totalFees'] - feesDetails['totalPaid'];
    return Scaffold(
      appBar: AppBar(
        title: Text('Fees Detail'),
        backgroundColor: Colors.black.withOpacity(0.95),
      ),
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              FeatureHomeScreen(
                screenHeight: MediaQuery.of(context).size.height,
                screenName: '',
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: CachedNetworkImageProvider(
                            feesDetails['student']['photo']),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          feesDetails['student']['name'],
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
                      feesDetails['history'][index]['amountPaid'].toString()),
                  trailing: Text(feesDetails['history'][index]['date']
                      .toString()
                      .split('T')[0]
                      .toString()),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ButtonTheme(
              minWidth: MediaQuery.of(context).size.width,
              child: RaisedButton(
                color: Colors.black,
                onPressed: () {
                  Fluttertoast.showToast(msg: 'Add payment pressed');
                  showDialog(
                      context: context,
                      builder: (context) {
                        return FeesAddPayment(user, feesDetails['id']);
                      }).then((_) => setState(() {}));
                },
                child: Text(
                  'Add Payment',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class FeesAddPayment extends StatefulWidget {
  TeacherUser user = TeacherUser();
  int feesId;
  FeesAddPayment(this.user, this.feesId);
  @override
  State<StatefulWidget> createState() {
    return _FeesAddPayment(user, feesId);
  }
}

class _FeesAddPayment extends State<FeesAddPayment> {
  TeacherUser user = TeacherUser();
  DateTime _dateTime = DateTime.now();
  TextEditingController paymentController = TextEditingController();
  int feesId;
  _FeesAddPayment(this.user, this.feesId);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        children: <Widget>[
          TextField(
            controller: paymentController,
            decoration: InputDecoration(hintText: 'Payment Amount'),
            keyboardType: TextInputType.number,
          ),
          Text(_dateTime.toString().split(' ')[0].toString()),
          RaisedButton(
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
            child: Text('Pick Date'),
          ),
          RaisedButton(
            color: Colors.black,
            onPressed: () async {
              var response = await feesAddPayment(user.key, feesId,
                  double.parse(paymentController.text), _dateTime.toString());
              if (response['status'] == 'Success') {
                Fluttertoast.showToast(msg: response['message']);
                Navigator.pop(context);
              }
            },
            child: Text(
              'Add payment',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
