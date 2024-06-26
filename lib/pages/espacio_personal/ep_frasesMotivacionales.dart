import 'package:flutter/material.dart';
import 'package:ihc_hi/data/database/database_helper.dart';
import 'package:ihc_hi/pages/crear_frase.dart';
import 'package:ihc_hi/pages/editar_frase.dart';

class FrasesMotivacionalesPage extends StatefulWidget {
  @override
  _FrasesMotivacionalesPageState createState() =>
      _FrasesMotivacionalesPageState();
}

class _FrasesMotivacionalesPageState extends State<FrasesMotivacionalesPage> {
  late Future<List<Map<String, dynamic>>> _phraseList;

  @override
  void initState() {
    super.initState();
    _loadPhrases();
  }

  void _loadPhrases() {
    setState(() {
      _phraseList = DatabaseHelper().getPhrases();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Frases Motivacionales'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20.0),
            Icon(
              Icons.bolt_rounded,
              size: 100,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CrearFrasePage()),
                );
                _loadPhrases();
              },
              child: Text('Añadir Frase'),
            ),
            SizedBox(height: 20.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Tu lista de frases',
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
              future: _phraseList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No hay frases motivacionales.');
                } else {
                  return Column(
                    children: snapshot.data!.map((phrase) {
                      return PhraseCard(
                        phrase: phrase,
                        onPhraseUpdated: _loadPhrases,
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

class PhraseCard extends StatelessWidget {
  final Map<String, dynamic> phrase;
  final VoidCallback onPhraseUpdated;

  PhraseCard({required this.phrase, required this.onPhraseUpdated});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(phrase['phrase']),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditarFrasePage(phrase: phrase)),
                );
                onPhraseUpdated();
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await DatabaseHelper().deletePhrase(phrase['id']);
                onPhraseUpdated();
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
