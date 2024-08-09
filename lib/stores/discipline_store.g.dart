// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discipline_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DisciplineStore on _DisciplineStore, Store {
  late final _$disciplinesAtom =
      Atom(name: '_DisciplineStore.disciplines', context: context);

  @override
  ObservableList<Discipline> get disciplines {
    _$disciplinesAtom.reportRead();
    return super.disciplines;
  }

  @override
  set disciplines(ObservableList<Discipline> value) {
    _$disciplinesAtom.reportWrite(value, super.disciplines, () {
      super.disciplines = value;
    });
  }

  late final _$gradesAtom =
      Atom(name: '_DisciplineStore.grades', context: context);

  @override
  ObservableList<Grade> get grades {
    _$gradesAtom.reportRead();
    return super.grades;
  }

  @override
  set grades(ObservableList<Grade> value) {
    _$gradesAtom.reportWrite(value, super.grades, () {
      super.grades = value;
    });
  }

  late final _$fetchDisciplinesAsyncAction =
      AsyncAction('_DisciplineStore.fetchDisciplines', context: context);

  @override
  Future<void> fetchDisciplines() {
    return _$fetchDisciplinesAsyncAction.run(() => super.fetchDisciplines());
  }

  late final _$addDisciplineAsyncAction =
      AsyncAction('_DisciplineStore.addDiscipline', context: context);

  @override
  Future<void> addDiscipline(Discipline discipline) {
    return _$addDisciplineAsyncAction
        .run(() => super.addDiscipline(discipline));
  }

  late final _$addGradeAsyncAction =
      AsyncAction('_DisciplineStore.addGrade', context: context);

  @override
  Future<void> addGrade(Grade grade) {
    return _$addGradeAsyncAction.run(() => super.addGrade(grade));
  }

  late final _$fetchGradesAsyncAction =
      AsyncAction('_DisciplineStore.fetchGrades', context: context);

  @override
  Future<void> fetchGrades(int disciplineId) {
    return _$fetchGradesAsyncAction.run(() => super.fetchGrades(disciplineId));
  }

  late final _$deleteDisciplineAsyncAction =
      AsyncAction('_DisciplineStore.deleteDiscipline', context: context);

  @override
  Future<void> deleteDiscipline(int disciplineId) {
    return _$deleteDisciplineAsyncAction
        .run(() => super.deleteDiscipline(disciplineId));
  }

  @override
  String toString() {
    return '''
disciplines: ${disciplines},
grades: ${grades}
    ''';
  }
}
