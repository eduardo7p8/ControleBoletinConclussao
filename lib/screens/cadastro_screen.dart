import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/discipline.dart';
import '../models/grade.dart';
import '../stores/discipline_store.dart';

class CadastroScreen extends StatefulWidget {
  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _gradeController = TextEditingController();
  final _yearController = TextEditingController(text: DateTime.now().year.toString());
  int? _selectedDisciplineId;
  int _selectedSemester = 1;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final disciplineStore = Provider.of<DisciplineStore>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Disciplinas e Notas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () => _showAddDisciplineDialog(context),
                    child: Text('Cadastrar Disciplina'),
                  ),
                  SizedBox(height: 20),
                  FutureBuilder<void>(
                    future: disciplineStore.fetchDisciplines(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Erro ao carregar disciplinas'));
                      }
                      if (disciplineStore.disciplines.isEmpty) {
                        return Center(child: Text('Nenhuma disciplina cadastrada.'));
                      }
                      return DropdownButtonFormField<int>(
                        hint: Text('Selecione a Disciplina'),
                        value: _selectedDisciplineId,
                        onChanged: (int? value) {
                          setState(() {
                            _selectedDisciplineId = value;
                            _selectedSemester = 1;
                          });
                        },
                        items: disciplineStore.disciplines.map((discipline) {
                          return DropdownMenuItem<int>(
                            value: discipline.id,
                            child: Text(discipline.name),
                          );
                        }).toList(),
                        validator: (value) => value == null ? 'Selecione uma disciplina' : null,
                      );
                    },
                  ),
                  if (_selectedDisciplineId != null)
                    _buildSemesterSelector(disciplineStore),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _gradeController,
                    decoration: InputDecoration(labelText: 'Nota'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Insira uma nota';
                      }
                      final grade = double.tryParse(value);
                      if (grade == null || grade < 0 || grade > 10) {
                        return 'Insira uma nota válida entre 0 e 10';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _yearController,
                    decoration: InputDecoration(labelText: 'Ano'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Insira o ano';
                      }
                      final year = int.tryParse(value);
                      if (year == null || year < 2000 || year > DateTime.now().year) {
                        return 'Insira um ano válido';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _saveGrade(context);
                      }
                    },
                    child: Text('Salvar Nota'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSemesterSelector(DisciplineStore disciplineStore) {
    final selectedDiscipline = disciplineStore.disciplines.firstWhere((d) => d.id == _selectedDisciplineId);
    final semesterOptions = selectedDiscipline.isSemester ? [1, 2] : [1, 2, 3, 4];

    return DropdownButtonFormField<int>(
      value: _selectedSemester,
      onChanged: (int? value) {
        setState(() {
          _selectedSemester = value!;
        });
      },
      items: semesterOptions.map((semester) {
        return DropdownMenuItem<int>(
          value: semester,
          child: Text('Semestre $semester'),
        );
      }).toList(),
    );
  }

  void _saveGrade(BuildContext context) {
    final disciplineStore = Provider.of<DisciplineStore>(context, listen: false);
    if (_selectedDisciplineId != null && _gradeController.text.isNotEmpty && _yearController.text.isNotEmpty) {
      final grade = Grade(
        disciplineId: _selectedDisciplineId!,
        grade: double.parse(_gradeController.text),
        semester: _selectedSemester,
        year: int.parse(_yearController.text),
        createdAt: DateTime.now().toIso8601String(),
      );
      disciplineStore.addGrade(grade);
      print('Nota salva: ${grade.toString()}');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nota salva com sucesso!')),
      );

      _gradeController.clear();
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar a nota. Verifique os campos e tente novamente.')),
      );
    }
  }

  void _showAddDisciplineDialog(BuildContext context) {
    final _nameController = TextEditingController();
    bool _isSemester = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Cadastrar Disciplina'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Nome da Disciplina'),
                  ),
                  SwitchListTile(
                    title: Text('Semestral'),
                    value: _isSemester,
                    onChanged: (value) {
                      setState(() {
                        _isSemester = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    final discipline = Discipline(
                      name: _nameController.text,
                      isSemester: _isSemester,
                      createdAt: DateTime.now().toIso8601String(),
                    );
                    Provider.of<DisciplineStore>(context, listen: false).addDiscipline(discipline);
                    Navigator.of(context).pop();

                    //
                    setState(() {});
                  },
                  child: Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
