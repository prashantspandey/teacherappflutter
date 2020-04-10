//import 'dart:convert';
import 'package:bodhiai_teacher_flutter/pojo/basic.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
//import 'package:http/http.dart' as http;

class TeacherOptionsProvider with ChangeNotifier {
  Batch _batch;
  var _date;

  Batch getSelectedBatch() {
    return _batch;
  }

  getSelectedDate() {
    return _date;
  }

  setSelectedBatch(Batch batch) {
    _batch = batch;
    notifyListeners();
    print('_batch ${batch.name}');
  }

  setSelectedDate(var date) {
    _date = date;
    notifyListeners();
    print('_date ${_date.toString()}');
  }
}
