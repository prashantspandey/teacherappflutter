import 'package:bodhiai_teacher_flutter/pojo/basic.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

Future teacherLogin(username, password) async {
  TeacherUser teacherUser = TeacherUser();
  Map<String, String> body = {
    'username': username,
    'password': password,
  };
  var headers = {
    "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded"
  };
  String url = 'http://15.206.150.90/api/membership/login_teacher/';
  var data = await http.post(url, body: body, headers: headers);

  if (data.statusCode == 200 || data.statusCode == 201) {
    var response = json.decode(data.body);
    teacherUser = TeacherUser.fromJson(response);
    String key = teacherUser.key;
    return teacherUser;
  } else {
  }
}

Future instituteInformation(key) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  String url =
      'http://15.206.150.90/api/basicinformation/teacher_general_data_institute/';
  var data = await http.get(url, headers: headers);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    return response;
  }
}

Future getAllBatches(key) async {
  ListBatches batches = ListBatches();
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  String url = 'http://15.206.150.90/api/basicinformation/teacher_get_batches/';
  var data = await http.get(url, headers: headers);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    batches = ListBatches.fromJson(response);
    return batches;
  } else {
    return batches;
  }
}

Future getAllStudents(key) async {
  ListStudents students = ListStudents();
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  String url =
      'http://15.206.150.90/api/basicinformation/teacher_all_student_list/';
  var data = await http.get(url, headers: headers);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    students = ListStudents.fromJson(response);
    return students;
  } else {
    return students;
  }
}

Future getBatchStudents(key, batchId) async {
  ListStudents students = ListStudents();
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  var body = {'batch_id': batchId.toString()};
  String url =
      'http://15.206.150.90/api/basicinformation/teacher_students_batchwise/';
  var data = await http.post(url, headers: headers, body: body);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    students = ListStudents.fromJson(response);
        return students;
  } else {
    return students;
  }
}

Future getListAttendanceDateWise(key, batchId, date) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  var body = {'batch_id': batchId.toString(), 'date': date.toString()};
  String url =
      'http://15.206.150.90/api/management/teacher_list_attendance_datewise/';
  var data = await http.post(url, headers: headers, body: body);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    return response;
  } else {
    print(data.statusCode.toString());
    return null;
  }
}

Future submitAttendance(key, date, attendance) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  var body = {'date': date.toString(), 'present_type': jsonEncode(attendance)};
  //var finalData = json.encode(body);
  //print('final Data ${finalData.toString()}');
  String url = 'http://15.206.150.90/api/management/teacher_mark_attendance/';
  var data = await http.post(url, headers: headers, body: body);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    return response;
  } else {
    print(data.statusCode.toString());
    print(data.body.toString());
    return null;
  }
}

Future getAlreadyAttendance(key, date, studentList) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  var body = {'date': date.toString(), 'student_id': jsonEncode(studentList)};
  //var finalData = json.encode(body);
  //print('final Data ${finalData.toString()}');
  String url =
      'http://15.206.150.90/api/management/teacher_get_already_attendance/';
  var data = await http.post(url, headers: headers, body: body);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    return response;
  } else {
    print(data.statusCode.toString());
    print(data.body.toString());
    return null;
  }
}

Future getAllSubjects(key) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  String url = 'http://15.206.150.90/api/content/teacher_get_subjects/';
  var data = await http.get(url, headers: headers);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    print('subject ${response.toString()}');
    return response;
  } else {
    print(data.statusCode.toString());
    return data.body;
  }
}

Future getSubjectChapters(key, subject) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  var body = {'subject_id': jsonEncode(subject)};
  String url = 'http://15.206.150.90/api/content/teacher_get_chapters/';
  var data = await http.post(url, headers: headers, body: body);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    return response;
  } else {
    print(data.statusCode.toString());
    return data.body;
  }
}

Future postUploadVideo(
    key, title, subject, chapter, urlLink, generalVideo) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  var body = {
    'subject': jsonEncode(subject),
    'chapter': jsonEncode(chapter),
    'title': title,
    'generalVideo': jsonEncode(generalVideo),
    'video_link': jsonEncode(urlLink),
  };
  String url = 'http://15.206.150.90/api/content/teacher_upload_video/';
  var data = await http.post(url, headers: headers, body: body);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    return response;
  } else {
    print(data.statusCode.toString());
    return data.body;
  }
}

Future getUploadedVideos(key) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  String url = 'http://15.206.150.90/api/content/teacher_get_all_videos/';
  var data = await http.get(url, headers: headers);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    return response;
  } else {
    print(data.statusCode.toString());
    return data.body;
  }
}

Future postUploadNotes(key, title, subject, chapter, details) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  var body = {
    'subject_id': jsonEncode(subject),
    'chapter_id': jsonEncode(chapter),
    'title': title,
    'note_details': jsonEncode(details),
  };
  String url = 'http://15.206.150.90/api/content/teacher_upload_notes/';
  var data = await http.post(url, headers: headers, body: body);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    return response;
  } else {
    print(data.statusCode.toString());
    return data.body;
  }
}

Future getUploadedNotes(key) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  String url = 'http://15.206.150.90/api/content/teacher_get_all_notes/';
  var data = await http.get(url, headers: headers);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    return response;
  } else {
    print(data.statusCode.toString());
    return data.body;
  }
}

Future getUploadedTests(key) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  String url = 'http://15.206.150.90/api/content/teacher_get_all_tests/';
  var data = await http.get(url, headers: headers);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    return response;
  } else {
    print(data.statusCode.toString());
    return data.body;
  }
}

Future getCreatedPackages(key) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  String url = 'http://15.206.150.90/api/content/teacher_get_packages/';
  var data = await http.get(url, headers: headers);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    return response;
  } else {
    print(data.statusCode.toString());
    return data.body;
  }
}

Future createPackage(key, title, price, duration) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  var body = {
    'name': jsonEncode(title),
    'price': jsonEncode(double.parse(price)),
    'duration': duration,
    'details': 'test details'
  };
  String url = 'http://15.206.150.90/api/content/teacher_create_package/';
  var data = await http.post(url, headers: headers, body: body);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    return response;
  } else {
    print(data.statusCode.toString());
    return data.body;
  }
}

Future getIndividualPackage(key, packageId) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  var body = {
    'package_id': jsonEncode(packageId),
  };
  String url =
      'http://15.206.150.90/api/content/teacher_get_individual_package/';
  var data = await http.post(url, headers: headers, body: body);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    return response;
  } else {
    print(data.statusCode.toString());
    return data.body;
  }
}

Future packageAddVideo(key, videosIds, packageId) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  var body = {
    'videos_id': jsonEncode(videosIds),
    'package_id': jsonEncode(packageId),
  };
  String url = 'http://15.206.150.90/api/content/teacher_add_package_videos/';
  var data = await http.post(url, headers: headers, body: body);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    return response;
  } else {
    print(data.statusCode.toString());
    return data.body;
  }
}

Future packageAddNote(key, noteIds, packageId) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  var body = {
    'notes_id': jsonEncode(noteIds),
    'package_id': jsonEncode(packageId),
  };
  String url = 'http://15.206.150.90/api/content/teacher_add_package_notes/';
  var data = await http.post(url, headers: headers, body: body);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    return response;
  } else {
    print(data.statusCode.toString());
    return data.body;
  }
}

Future packageAddTest(key, testIds, packageId) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  var body = {
    'tests_id': jsonEncode(testIds),
    'package_id': jsonEncode(packageId),
  };
  String url = 'http://15.206.150.90/api/content/teacher_add_package_tests/';
  var data = await http.post(url, headers: headers, body: body);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    return response;
  } else {
    print(data.statusCode.toString());
    return data.body;
  }
}

Future packageRemoveVideo(key, videoId, packageId) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  var body = {
    'video_id': jsonEncode(videoId),
    'package_id': jsonEncode(packageId),
  };
  String url = 'http://15.206.150.90/api/content/teacher_package_remove_video/';
  var data = await http.post(url, headers: headers, body: body);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    return response;
  } else {
    print(data.statusCode.toString());
    return data.body;
  }
}

Future packageRemoveNote(key, noteId, packageId) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  var body = {
    'note_id': jsonEncode(noteId),
    'package_id': jsonEncode(packageId),
  };
  String url = 'http://15.206.150.90/api/content/teacher_package_remove_note/';
  var data = await http.post(url, headers: headers, body: body);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    return response;
  } else {
    print(data.statusCode.toString());
    return data.body;
  }
}

Future packageRemoveTest(key, testId, packageId) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  var body = {
    'test_id': jsonEncode(testId),
    'package_id': jsonEncode(packageId),
  };
  String url = 'http://15.206.150.90/api/content/teacher_package_remove_test/';
  var data = await http.post(url, headers: headers, body: body);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    return response;
  } else {
    print(data.statusCode.toString());
    return data.body;
  }
}

Future getChaperQuestions(key, chapterId) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  var body = {
    'chapter_id': jsonEncode(chapterId),
  };
  String url =
      'http://15.206.150.90/api/content/teacher_get_questions_chapterwise/';
  var data = await http.post(url, headers: headers, body: body);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    return response;
  } else {
    print(data.statusCode.toString());
    return data.body;
  }
}

Future teacherCreateTest(key, questionsIds, batches, time) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  var body = {
    'questions': jsonEncode(questionsIds),
    'batches': jsonEncode(batches),
    'time': time.toString(),
  };
  String url = 'http://15.206.150.90/api/content/teacher_create_test/';
  var data = await http.post(url, headers: headers, body: body);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    return response;
  } else {
    print(data.statusCode.toString());
    return data.body;
  }
}

Future teacherCreateBatch(key, batchName) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  var body = {
    'batch_name': jsonEncode(batchName),
  };
  String url =
      'http://15.206.150.90/api/basicinformation/teacher_create_batch/';
  var data = await http.post(url, headers: headers, body: body);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    return response;
  } else {
    print(data.statusCode.toString());
    return data.body;
  }
}

Future teacherAddStudentsBatch(key, batchId, studentIds) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  var body = {
    'batch_id': jsonEncode(batchId),
    'student_ids': jsonEncode(studentIds),
  };
  String url =
      'http://15.206.150.90/api/basicinformation/teacher_add_students_batch/';
  var data = await http.post(url, headers: headers, body: body);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    return response;
  } else {
    print(data.statusCode.toString());
    return data.body;
  }
}

Future teacherCreateFees(key, studentId, totalFees, paidFees, date) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  var body = {
    'student_id': jsonEncode(studentId),
    'total_amount': jsonEncode(totalFees),
    'paid': jsonEncode(paidFees),
    'date': jsonEncode(date),
  };
  String url = 'http://15.206.150.90/api/management/teacher_create_fees/';
  var data = await http.post(url, headers: headers, body: body);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    return response;
  } else {
    print(data.statusCode.toString());
    return data.body;
  }
}

Future teacherGetAllFees(key) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  String url = 'http://15.206.150.90/api/management/teacher_get_all_fees/';
  var data = await http.get(url, headers: headers);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    return response;
  } else {
    print(data.statusCode.toString());
    return data.body;
  }
}

Future getIndividualFeeDetails(key, feeId) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  var body = {
    'fee_id': jsonEncode(feeId),
  };
  String url =
      'http://15.206.150.90/api/management/teacher_get_individual_fees/';
  var data = await http.post(url, headers: headers, body: body);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    return response;
  } else {
    print(data.statusCode.toString());
    return data.body;
  }
}

Future feesAddPayment(key, feeId, payment, date) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  var body = {
    'fees_id': jsonEncode(feeId),
    'amount': jsonEncode(payment),
    'date': jsonEncode(date),
  };
  String url = 'http://15.206.150.90/api/management/teacher_fees_add_payment/';
  var data = await http.post(url, headers: headers, body: body);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    return response;
  } else {
    print(data.statusCode.toString());
    return data.body;
  }
}

Future feesDeletePayment(
  key,
  feeId,
) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  var body = {
    'payment_fees_id': jsonEncode(feeId),
  };
  String url =
      'http://15.206.150.90/api/management/teacher_fees_delete_payment/';
  var data = await http.post(url, headers: headers, body: body);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    return response;
  } else {
    print(data.statusCode.toString());
    return data.body;
  }
}

Future getAllCreatedTests(key) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  String url = 'http://15.206.150.90/api/content/teacher_see_created_tests/';
  var data = await http.get(url, headers: headers);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    return response;
  } else {
    print(data.statusCode);
    print(data.toString());
    return data.toString();
  }
}

Future getIndividualTestDetails(
  key,
  testId,
) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  var body = {
    'test_id': jsonEncode(testId),
  };
  String url = 'http://15.206.150.90/api/content/teacher_see_individual_test/';
  var data = await http.post(url, headers: headers, body: body);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    return response;
  } else {
    print(data.statusCode.toString());
    return data.body;
  }
}
Future getAllBanners(key) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  String url = 'http://15.206.150.90/api/basicinformation/teacher_get_banners/';
  var data = await http.get(url, headers: headers);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    return response;
  } else {
    print(data.statusCode);
    print(data.toString());
    return data.toString();
  }
}

Future uploadBanner(
  key,
  bannerLink,
) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  var body = {
    'link': jsonEncode(bannerLink),
  };
  String url = 'http://15.206.150.90/api/basicinformation/teacher_upload_banner/';
  var data = await http.post(url, headers: headers, body: body);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    return response;
  } else {
    print(data.statusCode.toString());
    return data.body;
  }
}
Future publishLiveVideoLink(
  key,
  link,
) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  var body = {
    'link': jsonEncode(link),
  };
  String url = 'http://15.206.150.90/api/content/teacher_live_video_share_link/';
  var data = await http.post(url, headers: headers, body: body);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    return response;
  } else {
    print(data.statusCode.toString());
    return data.body;
  }
}
Future sendNotification(
  key,
  message,
) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  var body = {
    'message': jsonEncode(message),
    'to':'all',
  };
  String url = 'http://15.206.150.90/api/basicinformation/teacher_send_notification/';
  var data = await http.post(url, headers: headers, body: body);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    return response;
  } else {
    print(data.statusCode.toString());
    return data.body;
  }
}
Future startNativeLiveVideo(
  key,
  packageIds,
) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  var body = {
    'package_ids': jsonEncode(packageIds),
    'to':'all',
  };
  String url = 'http://15.206.150.90/api/basicinformation/teacher_start_native_live_video/';
  var data = await http.post(url, headers: headers, body: body);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    return response;
  } else {
    print(data.statusCode.toString());
    return data.body;
  }
}
Future stopNativeLiveVideo(
  key,
  videoId,
) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  var body = {
    'video_id': jsonEncode(videoId),
  };
  String url = 'http://15.206.150.90/api/basicinformation/teacher_stop_native_live_video/';
  var data = await http.post(url, headers: headers, body: body);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    return response;
  } else {
    print(data.statusCode.toString());
    return data.body;
  }
}
Future uploadYoutubeVideoServer(
  key,
  urlVideo,
  chapterId,
  title
) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  var body = {
    'url': jsonEncode(urlVideo),
    'chapter_id': jsonEncode(chapterId),
    'title': jsonEncode(title),
  };
  String url = 'http://15.206.150.90/api/content/teacher_add_youtube_video/';
  var data = await http.post(url, headers: headers, body: body);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    return response;
  } else {
    print(data.statusCode.toString());
    return data.body;
  }
}
Future getLiveVideoMessages(
  key,
  videoId,
) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  var body = {
    'video_id': jsonEncode(videoId),
  };
  String url = 'http://15.206.150.90/api/content/teacher_get_live_messages/';
  var data = await http.post(url, headers: headers, body: body);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    return response;
  } else {
    print(data.statusCode.toString());
    return data.body;
  }
}
Future postDeleteBanner(
  key,
  bannerId,
) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  var body = {
    'banner_id': jsonEncode(bannerId),
  };
  String url = 'http://15.206.150.90/api/basicinformation/teacher_delete_banner/';
  var data = await http.post(url, headers: headers, body: body);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    return response;
  } else {
    print(data.statusCode.toString());
    return data.body;
  }
}
Future postDeleteVideo(
  key,
  videoId,
) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  var body = {
    'video_id': jsonEncode(videoId),
  };
  String url = 'http://15.206.150.90/api/content/teacher_delete_video/';
  var data = await http.post(url, headers: headers, body: body);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    return response;
  } else {
    print(data.statusCode.toString());
    return data.body;
  }
}
Future postDeleteNote(
  key,
  noteId,
) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  var body = {
    'note_id': jsonEncode(noteId),
  };
  String url = 'http://15.206.150.90/api/content/teacher_delete_note/';
  var data = await http.post(url, headers: headers, body: body);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    return response;
  } else {
    print(data.statusCode.toString());
    return data.body;
  }
}
Future sendAnnouncement(
  key,
  message,
  batchList,
) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  var body = {
    'message': jsonEncode(message),
    'batches_ids': jsonEncode(batchList),
  };
  String url = 'http://15.206.150.90/api/communication/teacher_announcement/';
  var data = await http.post(url, headers: headers, body: body);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    return response;
  } else {
    print(data.statusCode.toString());
    return data.body;
  }
}
Future deleteBatch(
  key,
  batchId,
) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  var body = {
    'batch_id': jsonEncode(batchId),
  };
  String url = 'http://15.206.150.90/api/basicinformation/teacher_delete_batch/';
  var data = await http.post(url, headers: headers, body: body);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    return response;
  } else {
    print(data.statusCode.toString());
    return data.body;
  }
}
Future postAddSubject(key, subjectName) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  var body = {
    'subject_name': jsonEncode(subjectName),
  };
  String url = 'http://15.206.150.90/api/basicinformation/teacher_add_subject/';
  var data = await http.post(url, headers: headers, body: body);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    print('add subject ${response.toString()}');
    return response;
  } else {
    print(data.statusCode.toString());
    return data.body;
  }
}

Future checkUpdate(key, version) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  var body = {
    'version': jsonEncode(version),
  };
  String url = 'http://15.206.150.90/api/basicinformation/teacher_check_app_version/';
  var data = await http.post(url, headers: headers, body: body);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    print('app version ${response.toString()}');
    return response;
  } else {
    print(data.statusCode.toString());
    return data.body;
  }
}

Future getNumberLiveStudents(
  key,
  videoId,
) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  var body = {
    'video_id': jsonEncode(videoId),
  };
  String url = 'http://15.206.150.90/api/basicinformation/teacher_get_number_live/';
  var data = await http.post(url, headers: headers, body: body);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    print('live numbers ${response.toString()}');
    return response;
  } else {
    print(data.statusCode.toString());
    return data.body;
  }
}
Future postDeleteSubject(key, subjectId) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  var body = {
    'subject_id': jsonEncode(subjectId),
  };
  String url =
      'http://15.206.150.90/api/basicinformation/teacher_delete_subject/';
  var data = await http.post(url, headers: headers, body: body);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    print('delete subject ${response.toString()}');
    return response;
  } else {
    print(data.statusCode.toString());
    return data.body;
  }
}
Future postDeleteTests(key, testId) async {
  var headers = {
    'Authorization': 'token $key',
    'Accept': 'application/json',
    "Content-Type": 'application/x-www-form-urlencoded'
  };
  var body = {
    'test_id': jsonEncode(testId),
  };
  String url =
      'http://15.206.150.90/api/basicinformation/teacher_delete_test/';
  var data = await http.post(url, headers: headers, body: body);

  if (data.statusCode == 200) {
    var response = json.decode(data.body);
    print('delete test ${response.toString()}');
    return response;
  } else {
    print(data.statusCode.toString());
    return data.body;
  }
}