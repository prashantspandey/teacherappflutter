import 'package:bodhiai_teacher_flutter/pojo/basic.dart';
import 'package:bodhiai_teacher_flutter/providers/TeacherOptionsSeleted.dart';
import 'package:bodhiai_teacher_flutter/screens/BatchsListScreen.dart';
import 'package:bodhiai_teacher_flutter/screens/MarkAttendance.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderWidget extends StatefulWidget {
  TeacherUser user = TeacherUser();
  var screenName;
  CalenderWidget(this.user,{this.screenName});
  @override
  State<StatefulWidget> createState() {
    return _CalenderWidget(user,screenName:this.screenName);
  }
}

class _CalenderWidget extends State<CalenderWidget> {
  CalendarController calenderController;
  var screenName;
  TeacherUser user = TeacherUser();
  _CalenderWidget(this.user,{this.screenName});
  Map<String,dynamic> extraInfo = {};

  @override
  void initState() {
    super.initState();
    calenderController = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    //final selectedOptions = Provider.of<TeacherOptionsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose a date'),
        backgroundColor: Colors.black.withOpacity(0.95),
      ),
      body: ChangeNotifierProvider<TeacherOptionsProvider>(
        create: (context)=>TeacherOptionsProvider(),
              child: ListView(
          children: <Widget>[
            TableCalendar(
              calendarStyle: CalendarStyle(
                  selectedColor: Colors.black,
                  todayStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.white)),
              headerStyle: HeaderStyle(formatButtonShowsNext: false),
              calendarController: calenderController,
              onDaySelected: (date, events) {
                //selectedOptions.setSelectedDate(date);
                    TeacherOptionsProvider selectionOptions = TeacherOptionsProvider();
                    selectionOptions.setSelectedDate(date);
                print(date.runtimeType.toString());
                print(date.toString());
                extraInfo['screen'] = screenName;
                extraInfo['date'] = date;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BatchListScreen(
                              user,
                              MarkAttendance,
                              extraInfo:extraInfo ,
                            )));
              },
            ),
          ],
        ),
      ),
    );
  }
}
