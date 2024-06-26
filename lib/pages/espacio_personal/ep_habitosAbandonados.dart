//--------------------------------------------
//--------- pages/espacio_personal/ep_habitosAbandonados.dart
//--------------------------------------------
import 'package:flutter/material.dart';
import 'package:ihc_hi/data/database/database_helper.dart';

class HabitosAbandonadosPage extends StatefulWidget {
  @override
  _HabitosAbandonadosPageState createState() => _HabitosAbandonadosPageState();
}

class _HabitosAbandonadosPageState extends State<HabitosAbandonadosPage> {
  late Future<List<Map<String, dynamic>>> _habitList;

  @override
  void initState() {
    super.initState();
    _habitList = DatabaseHelper().getHabitsByState('abandonado');
  }

  void _refreshHabitList() {
    setState(() {
      _habitList = DatabaseHelper().getHabitsByState('abandonado');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hábitos abandonados'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20.0),
            Icon(
              Icons.clear_rounded,
              size: 100,
            ),
            SizedBox(height: 40.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Tus hábitos abandonados',
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
              future: _habitList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No hay hábitos abandonados.');
                } else {
                  return Column(
                    children: snapshot.data!.map((habit) {
                      return HabitCard(
                        habit: habit,
                        onDelete: () {
                          _deleteHabit(habit['id']);
                        },
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
            Divider(height: 50), // Línea divisoria
            FooterWidget(), // Footer en la parte inferior
          ],
        ),
      ),
    );
  }

  void _deleteHabit(int id) async {
    await DatabaseHelper().deleteHabit(id);
    _refreshHabitList();
  }
}

class HabitCard extends StatelessWidget {
  final Map<String, dynamic> habit;
  final VoidCallback onDelete;

  HabitCard({required this.habit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(habit['name']),
        subtitle: Text(habit['description']),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                // Acción al presionar el ícono de edición
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: onDelete,
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
      width: double
          .infinity, // Asegura que el container ocupe todo el ancho disponible
      color: Colors.white, // Fondo oscuro para el footer
      padding:
          EdgeInsets.all(5.0), // Espacio alrededor del contenido del footer
      child: Column(
        mainAxisSize: MainAxisSize
            .min, // Asegura que el footer no ocupe más espacio del necesario
        crossAxisAlignment:
            CrossAxisAlignment.center, // Centra los elementos horizontalmente
        children: <Widget>[
          Text(
            'IHC - HI',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black, // Color del texto para contraste
            ),
          ),
          SizedBox(height: 5), // Espacio entre el texto y el logo
          Image.asset(
            'assets/images/sharkhi2.png', // Ruta del logo (asegúrate de tener esta imagen en tu proyecto)
            height: 100, // Altura del logo
          ),
        ],
      ),
    );
  }
}

//--------------------------------------------
//--------- pages/espacio_personal/ep_habitosAbandonados.dart //
//--------------------------------------------