/// Student Model
class Student {
  late String uid, name, email;

  Student(this.uid, this.email, this.name);

  Student.fromMap(Map studentData) {
    uid = studentData['student_uid'];
    email = studentData['student_email'];
    name = studentData['student_name'];
  }

  Map<String, dynamic> get toMap => {
        'student_uid': uid,
        'student_email': email,
        'student_name': name,
      };
}
