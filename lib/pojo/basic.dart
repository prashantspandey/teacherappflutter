class TeacherUser {
  String key;
  String username;
  String name;
  String institute;

  TeacherUser({this.key, this.username, this.name, this.institute});
  factory TeacherUser.fromJson(Map<String, dynamic> json) {
    return TeacherUser(
        key: json['key'],
        institute: json['institute'],
        username: json['username'],
        name: json['name']);
  }
  Map<String, dynamic> toJson() => {
        'key': key,
        'username': username,
        'name': name,
        'institute': institute,
      };
}

class Student {
  String name;
  List<Batch> batches;
  var details;
  int id;
  Student({this.id,this.name, this.batches, this.details});
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
        batches: parseBatches(json['batches']),
        id: json['id'],
        name: json['name'],
        details: parseDetails(json['details']));


  }
  static parseDetails(detailsJson) {
    print('details json ${detailsJson['phone'].toString()}');
    var details_dict = {
      'photo': detailsJson['photo'].toString(),
      'phone': detailsJson['phone'].toString(),
      'fullName': detailsJson['fullName'].toString()
    };
    return details_dict;
  }

  static List<Batch> parseBatches(batchesJson) {
    var batch_list = batchesJson as List;
    List<Batch> batchList =
        batch_list.map((data) => Batch.fromJson(data)).toList();
    return batchList;
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'batches': batches,
        'details': details,
        'id':id,
      };
}

class Batch {
  String name;
  int id;
  Batch({this.name, this.id});
  factory Batch.fromJson(Map<String, dynamic> json) {
    return Batch(id: json['id'], name: json['name']);
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}

class ListStudents {
  List<Student> students;
  ListStudents({this.students});
  factory ListStudents.fromJson(Map<String, dynamic> json) {
    return ListStudents(students: parseStudents(json['studentList']));
  }
  static List<Student> parseStudents(studentsJson) {
    var studentsList = studentsJson as List;
    List<Student> student_list =
        studentsList.map((data) => Student.fromJson(data)).toList();
    return student_list;
  }

  Map<String, dynamic> toJson() => {'students': students};
}

class ListBatches {
  List<Batch> batches;
  ListBatches({this.batches});
  factory ListBatches.fromJson(Map<String, dynamic> json) {
    return ListBatches(batches: parseBatches(json['batches']));
  }
  static List<Batch> parseBatches(batchesJson) {
    var batchList = batchesJson as List;
    List<Batch> batch_list =
        batchList.map((data) => Batch.fromJson(data)).toList();
    return batch_list;
  }

  Map<String, dynamic> toJson() => {
        'batches': batches,
      };
}

class Details {
  String photo;
  String phone;
  String email;
  String fullName;
  Details({this.photo, this.phone, this.email, this.fullName});
  factory Details.fromJson(Map<String, dynamic> json) {
    return Details(
        photo: json['photo'],
        phone: json['phone'],
        email: json['email'],
        fullName: json['fullName']);
  }
  Map<String, dynamic> toJson() => {
        'photo': photo,
        'phone': phone,
        'email': email,
        'fullName': fullName,
      };
}
