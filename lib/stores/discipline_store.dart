import 'package:mobx/mobx.dart';
import '../models/discipline.dart';
import '../models/grade.dart';
import '../services/database_service.dart';

part 'discipline_store.g.dart';

class DisciplineStore = _DisciplineStore with _$DisciplineStore;

abstract class _DisciplineStore with Store {
  final DatabaseService _dbService = DatabaseService();

  @observable
  ObservableList<Discipline> disciplines = ObservableList<Discipline>();

  @observable
  ObservableList<Grade> grades = ObservableList<Grade>();

  @action
  Future<void> fetchDisciplines() async {
    final data = await _dbService.getDisciplines();
    disciplines = ObservableList.of(data.map((d) => Discipline.fromMap(d)).toList());
  }

  @action
  Future<void> addDiscipline(Discipline discipline) async {
    await _dbService.insertDiscipline(discipline.toMap());
    await fetchDisciplines();
  }

  @action
  Future<void> addGrade(Grade grade) async {
    await _dbService.insertGrade(grade.toMap());
    await fetchGrades(grade.disciplineId);
    print('Nota salva: ${grade.toMap()}');
  }

  @action
  Future<void> fetchGrades(int disciplineId) async {
    final data = await _dbService.getGrades(disciplineId);
    grades = ObservableList.of(data.map((g) => Grade.fromMap(g)).toList());
  }

  @action
  Future<void> deleteDiscipline(int disciplineId) async {

    await _dbService.deleteGradesByDisciplineId(disciplineId);

    await _dbService.deleteDiscipline(disciplineId);

    await fetchDisciplines();
  }

  double calculateAverage(int disciplineId) {
    final disciplineGrades = grades.where((g) => g.disciplineId == disciplineId).toList();
    if (disciplineGrades.isEmpty) return 0.0;
    final total = disciplineGrades.fold(0.0, (sum, grade) => sum + grade.grade);
    return total / disciplineGrades.length;
  }

  String getStatus(double average) {
    return average >= 5.0 ? 'Aprovado' : 'Reprovado';
  }
  @action
  Future<void> fetchAllGrades() async {
    final allDisciplines = disciplines;
    grades = ObservableList<Grade>();

    for (var discipline in allDisciplines) {
      final data = await _dbService.getGrades(discipline.id!);
      grades.addAll(data.map((g) => Grade.fromMap(g)).toList());
    }
  }

}
