class Grade {
  int? id;
  int disciplineId;
  double grade;
  int semester;
  String createdAt;
  int year;

  Grade({
    this.id,
    required this.disciplineId,
    required this.grade,
    required this.semester,
    required this.createdAt,
    required this.year,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'disciplineId': disciplineId,
      'grade': grade,
      'semester': semester,
      'createdAt': createdAt,
      'year': year,
    };
  }

  factory Grade.fromMap(Map<String, dynamic> map) {
    return Grade(
      id: map['id'],
      disciplineId: map['disciplineId'],
      grade: map['grade'],
      semester: map['semester'],
      createdAt: map['createdAt'],
      year: map['year'],
    );
  }
}
