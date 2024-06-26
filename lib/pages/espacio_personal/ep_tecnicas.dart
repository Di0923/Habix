//--------------------
//-----ep_tecnicas
//--------------------
import 'package:flutter/material.dart';
import 'package:ihc_hi/data/database/database_helper.dart';
import 'package:ihc_hi/pages/crear_tecnica.dart';
import 'package:ihc_hi/pages/editar_tecnica.dart';

class TecnicasPage extends StatefulWidget {
  @override
  _TecnicasPageState createState() => _TecnicasPageState();
}

class _TecnicasPageState extends State<TecnicasPage> {
  late Future<List<Map<String, dynamic>>> _techniqueList;

  @override
  void initState() {
    super.initState();
    _loadTechniques();
  }

  void _loadTechniques() {
    setState(() {
      _techniqueList = DatabaseHelper().getTechniques();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Técnicas'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20.0),
            Icon(
              Icons.lightbulb_outline_rounded,
              size: 100,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CrearTecnicaPage()),
                );
                _loadTechniques();
              },
              child: Text('Añadir Técnica'),
            ),
            SizedBox(height: 20.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Tu lista de técnicas',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 2.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.blue.withOpacity(0.5),
                        Colors.blue.withOpacity(0.2),
                        Colors.blue.withOpacity(0.1),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _techniqueList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No hay técnicas.');
                } else {
                  return Column(
                    children: snapshot.data!.map((technique) {
                      return TechniqueCard(
                        technique: technique,
                        onTechniqueUpdated: _loadTechniques,
                      );
                    }).toList(),
                  );
                }
              },
            ),
            SizedBox(height: 20.0),
            SizedBox(
              height: 100,
            ),
            Divider(height: 50),
            FooterWidget(),
          ],
        ),
      ),
    );
  }
}

class TechniqueCard extends StatelessWidget {
  final Map<String, dynamic> technique;
  final VoidCallback onTechniqueUpdated;

  TechniqueCard({required this.technique, required this.onTechniqueUpdated});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(technique['name']),
        subtitle: Text(technique['description']),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          EditarTecnicaPage(technique: technique)),
                );
                onTechniqueUpdated();
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await DatabaseHelper().deleteTechnique(technique['id']);
                onTechniqueUpdated();
              },
            ),
          ],
        ),
      ),
    );
  }
}

//----------------------------------- CLASES APARTE
//----- FOOTER
class FooterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.all(5.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'IHC - HI',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 5),
          Image.asset(
            'assets/images/sharkhi2.png',
            height: 100,
          ),
        ],
      ),
    );
  }
}

//--------------------
//-----ep_tecnicas
//--------------------
