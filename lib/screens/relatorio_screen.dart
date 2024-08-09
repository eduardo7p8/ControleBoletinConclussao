import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/discipline.dart';
import '../models/grade.dart';
import '../stores/discipline_store.dart';
class RelatorioScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final store = Provider.of<DisciplineStore>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Relatórios'),
      ),
      body: FutureBuilder<void>(
        future: Future.wait([
          store.fetchDisciplines(),
          store.fetchAllGrades(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar relatórios'));
          }

          if (store.disciplines.isEmpty) {
            return const Center(child: Text('Nenhuma disciplina cadastrada.'));
          }

          return ListView.builder(
            itemCount: store.disciplines.length,
            itemBuilder: (context, index) {
              final discipline = store.disciplines[index];
              final grades = store.grades
                  .where((g) => g.disciplineId == discipline.id)
                  .toList();

              //
              final gradesByYear = <int, List<Grade>>{};
              for (var grade in grades) {
                if (!gradesByYear.containsKey(grade.year)) {
                  gradesByYear[grade.year] = [];
                }
                gradesByYear[grade.year]!.add(grade);
              }

              //
              final averageByYear = gradesByYear.map((year, grades) {
                final isSemester = discipline.isSemester;
                final expectedGradeCount = isSemester ? 2 : 4;

                if (grades.length < expectedGradeCount) {
                  return MapEntry(year, null);
                }

                final average = grades.fold(0.0, (sum, grade) => sum + grade.grade) / grades.length;
                return MapEntry(year, average);
              });

              return Card(
                margin: EdgeInsets.all(8.0),
                child: ExpansionTile(
                  title: Text(discipline.name),
                  subtitle: Text(discipline.isSemester ? 'Semestral' : 'Anual'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      //
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Excluir disciplina'),
                          content: Text('Tem certeza de que deseja excluir esta disciplina e suas notas?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Excluir'),
                            ),
                          ],
                        ),
                      );
                      if (confirmed == true) {
                        await store.deleteDiscipline(discipline.id!);
                      }
                    },
                  ),
                  children: gradesByYear.entries.map((entry) {
                    final year = entry.key;
                    final grades = entry.value;
                    final average = averageByYear[year];
                    final isSemester = discipline.isSemester;
                    final expectedGradeCount = isSemester ? 2 : 4;

                    return ListTile(
                      title: Text('Ano $year'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...grades.map((grade) => Text('Nota: ${grade.grade.toStringAsFixed(1)}')),
                          if (grades.length < expectedGradeCount)
                            Text('Faltam ${expectedGradeCount - grades.length} notas para completar o semestre/ano.'),
                          if (average != null)
                            Text('Média: ${average.toStringAsFixed(2)}'),
                          if (average == null)
                            const Text('Média não disponível.'),
                          Text('Status: ${average != null ? store.getStatus(average) : 'Aguardando todas as notas'}'),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
