//-----------------------------------------
//---------ep_habitosDesarrollo
//-----------------------------------------

import 'package:flutter/material.dart';
import 'package:ihc_hi/data/database/database_helper.dart';
import 'package:ihc_hi/pages/crear_habito_prueba.dart';
import 'package:ihc_hi/pages/editar_habitoDesarrollo.dart';
import 'package:intl/intl.dart';

class HabitosDesarrolloPage extends StatefulWidget {
  @override
  _HabitosDesarrolloPageState createState() => _HabitosDesarrolloPageState();
}

class _HabitosDesarrolloPageState extends State<HabitosDesarrolloPage> {
  late Future<List<Map<String, dynamic>>> _habitList;

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  void _loadHabits() {
    setState(() {
      _habitList = DatabaseHelper().getHabitsByState('activo');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hábitos en desarrollo'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20.0),
            Icon(
              Icons.timelapse,
              size: 100,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CrearHabitoPruebaPage()),
                );
                _loadHabits();
              },
              child: Text('Crear Nuevo'),
            ),
            SizedBox(height: 20.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Los hábitos que estas formando',
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
                        Colors.blue.withOpacity(0.1)
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
                  return Text('No hay hábitos en desarrollo.');
                } else {
                  return Column(
                    children: snapshot.data!.map((habit) {
                      return HabitCard(
                        habit: habit,
                        onHabitUpdated: _loadHabits,
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

//---------------------------------- TARJETA DE HABITO -------
class HabitCard extends StatelessWidget {
  final Map<String, dynamic> habit;
  final VoidCallback onHabitUpdated;

  HabitCard({required this.habit, required this.onHabitUpdated});

  @override
  Widget build(BuildContext context) {
    String formattedDate = '';
    if (habit['fechaCreacion'] != null) {
      DateTime date = DateTime.parse(habit['fechaCreacion']);
      formattedDate = DateFormat('dd/MM/yyyy').format(date);
    }

    return Card(
      child: ListTile(
        title: Text(habit['name']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(habit['description']),
            SizedBox(height: 8.0),
            Text('Fecha de creación: $formattedDate'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditarHabitoPage(habit: habit)),
                );
                onHabitUpdated();
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await DatabaseHelper().deleteHabit(habit['id']);
                onHabitUpdated();
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

//-----------------------------------------
//---------ep_habitosDesarrollo
//-----------------------------------------
