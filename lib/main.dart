import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'stores/discipline_store.dart';
import 'screens/relatorio_screen.dart';
import 'screens/cadastro_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DisciplineStore>(create: (_) => DisciplineStore()),
      ],
      child: MaterialApp(
        title: 'Boletim Acadêmico',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
        debugShowCheckedModeBanner: false, // Remove o banner de debug
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajuda'),
        content: const Text('Bem-vindo ao aplicativo de boletim acadêmico! Aqui você pode cadastrar disciplinas e notas, e gerar relatórios.'),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _openCadastroScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => CadastroScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<DisciplineStore>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                setState(() {
                  _selectedIndex = 0; // Navega para a tela de disciplinas
                });
              },
            ),
            Expanded(
              child: Center(
                child: Text(
                  _selectedIndex == 0 ? 'Disciplinas' : 'Relatórios',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.help),
              onPressed: _showHelpDialog,
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
      // Imagem de fundo
      Positioned.fill(
      child: Opacity(
      opacity: 0.05, // Ajuste a opacidade conforme necessário
        child: Image.asset(
          'assets/fundo.jpg',
          fit: BoxFit.cover,
        ),
      ),
    ),
    // Conteúdo do app
     _selectedIndex == 0
          ?  Column(
        children: [
          const Text('DISCIPLINAS CADASTRADAS', style: TextStyle(fontSize: 24)),
          Expanded(
            child: FutureBuilder(
              future: store.fetchDisciplines(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Erro ao carregar disciplinas'));
                }

                if (store.disciplines.isEmpty) {
                  return const Center(child: Text('Nenhuma disciplina cadastrada.'));
                }

                return ListView.builder(
                  itemCount: store.disciplines.length,
                  itemBuilder: (context, index) {
                    final discipline = store.disciplines[index];
                    return ListTile(
                      title: Text(discipline.name),
                      subtitle: Text(discipline.isSemester ? 'Semestral' : 'Anual'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      )
          : RelatorioScreen(),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
        onPressed: _openCadastroScreen,
        child: Icon(Icons.add),
        tooltip: 'Adicionar Disciplina',
      )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Disciplinas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report),
            label: 'Relatórios',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}