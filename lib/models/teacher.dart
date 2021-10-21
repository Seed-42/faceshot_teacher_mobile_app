/// Teacher Model
class Teacher {
  late String uid, name, email;

  Teacher(this.uid, this.email, this.name);
  
  Teacher.formMap(Map teacherData) {
    uid = teacherData['teacher_uid'];
    email = teacherData['teacher_email'];
    name = teacherData['teacher_name'];
  }

  Map<String, dynamic> get toMap => {
        'teacher_uid': uid,
        'teacher_email': email,
        'teacher_name': name,
      };
}
