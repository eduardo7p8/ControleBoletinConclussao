class Discipline {
  int? id;
  String name;
  bool isSemester;
  String createdAt;

  Discipline({
    this.id,
    required this.name,
    required this.isSemester,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isSemester': isSemester ? 1 : 0,
      'createdAt': createdAt,
    };
  }

  factory Discipline.fromMap(Map<String, dynamic> map) {
    return Discipline(
      id: map['id'],
      name: map['name'],
      isSemester: map['isSemester'] == 1,
      createdAt: map['createdAt'],
    );
  }
}
