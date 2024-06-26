//--------------------------------------------
//--------- pages/home_page.dart
//--------------------------------------------

// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:ihc_hi/data/database/database_helper.dart';
import 'package:ihc_hi/pages/habit_card.dart';
import 'package:ihc_hi/pages/usuario_page.dart'; // Asegúrate de importar la nueva página de usuario

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Map<String, dynamic>>> activeHabits;
  late Future<Map<String, dynamic>> randomTechnique;
  late Future<Map<String, dynamic>> randomPhrase;
  late Future<Map<String, dynamic>> usuario;

  @override
  void initState() {
    super.initState();
    _refreshHabits();
    _loadRandomTechnique();
    _loadRandomPhrase();
    _loadUsuario();
  }

  void _refreshHabits() {
    setState(() {
      activeHabits = DatabaseHelper().getActiveHabits();
    });
  }

  void _loadRandomTechnique() {
    setState(() {
      randomTechnique = DatabaseHelper().getRandomTechnique();
    });
  }

  void _loadRandomPhrase() {
    setState(() {
      randomPhrase = DatabaseHelper().getRandomPhrase();
    });
  }

  void _loadUsuario() {
    setState(() {
      usuario = DatabaseHelper().getUsuario();
    });
  }

  @override
  Widget build(BuildContext context) {
    Color customColor = Color.fromARGB(255, 255, 255, 255);
    Color iconColor = Color.fromARGB(255, 61, 76, 246);
    Color textColor = Colors.black;

    return WillPopScope(
      onWillPop: () async {
        _loadRandomTechnique();
        _loadRandomPhrase();
        return true;
      },
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UsuarioPage()),
                          ).then((_) {
                            _loadUsuario();
                          });
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: iconColor,
                                      width: 2.0,
                                    ),
                                    color: customColor,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    color: iconColor,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                FutureBuilder<Map<String, dynamic>>(
                                  future: usuario,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Text(
                                        'Cargando...',
                                        style: TextStyle(
                                          color: textColor,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text(
                                        'Error',
                                        style: TextStyle(
                                          color: textColor,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    } else if (snapshot.hasData &&
                                        snapshot.data != null &&
                                        snapshot.data!['nombre'] != null) {
                                      return Text(
                                        'Hola ${snapshot.data!['nombre']}!',
                                        style: TextStyle(
                                          color: textColor,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    } else {
                                      return Text(
                                        'Hola Usuario!',
                                        style: TextStyle(
                                          color: textColor,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              '26 Jun, 2024',
                              style: TextStyle(color: iconColor),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Espacio Personal',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
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
                      SizedBox(height: 16.0),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Icon(
                                Icons.dashboard_rounded,
                                color: Colors.black,
                                size: MediaQuery.of(context).size.width * 0.35,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await Navigator.pushNamed(
                                          context, 'habitosDesarrollo');
                                      _refreshHabits();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      elevation: 4.0,
                                      minimumSize: Size(double.infinity, 50),
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Hábitos en Desarrollo',
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await Navigator.pushNamed(
                                          context, 'habitosFinalizados');
                                      _refreshHabits();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      elevation: 4.0,
                                      minimumSize: Size(double.infinity, 50),
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Hábitos Finalizados',
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await Navigator.pushNamed(
                                          context, 'habitosAbandonados');
                                      _refreshHabits();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      elevation: 4.0,
                                      minimumSize: Size(double.infinity, 50),
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Hábitos Abandonados',
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await Navigator.pushNamed(
                                          context, 'tecnicas');
                                      _refreshHabits();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      elevation: 4.0,
                                      minimumSize: Size(double.infinity, 50),
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Técnicas',
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await Navigator.pushNamed(
                                          context, 'frasesMotivacionales');
                                      _refreshHabits();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      elevation: 4.0,
                                      minimumSize: Size(double.infinity, 50),
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Frases Motivacionales',
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Hábito en desarrollo',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 50,
                          ),
                          TextButton(
                            onPressed: () {
                              print('Botón Editar presionado');
                            },
                            style: TextButton.styleFrom(
                              backgroundColor:
                                  Color.fromARGB(255, 255, 255, 255),
                              textStyle: TextStyle(fontSize: 13),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              minimumSize: Size(5, 5),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  width: 15,
                                ),
                              ],
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
                    future: activeHabits,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No hay hábitos activos.'));
                      } else {
                        return Column(
                          children: snapshot.data!.map((habit) {
                            return HabitCard(
                                habit: habit, onHabitUpdated: _refreshHabits);
                          }).toList(),
                        );
                      }
                    },
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Conoce',
                            style: TextStyle(
                              fontSize: 24.0,
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
                  FutureBuilder<Map<String, dynamic>>(
                    future: randomTechnique,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData) {
                        return Center(
                            child: Text('No se pudo cargar la técnica.'));
                      } else {
                        var technique = snapshot.data!;
                        return Container(
                          padding: EdgeInsets.all(16.0),
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Row(
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.lightbulb_outline_rounded,
                                        color: Colors.black,
                                        size: 50,
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(technique['name'] ?? 'N/A',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                        Text(technique['description'] ?? 'N/A',
                                            style: TextStyle(fontSize: 16)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  FutureBuilder<Map<String, dynamic>>(
                    future: randomPhrase,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData) {
                        return Center(
                            child: Text('No se pudo cargar la frase.'));
                      } else {
                        var phrase = snapshot.data!;
                        return Container(
                          padding: EdgeInsets.all(16.0),
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.bolt_rounded, size: 50),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(phrase['name'] ?? 'Frase diaria',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                        Text(phrase['phrase'] ?? 'N/A',
                                            style: TextStyle(fontSize: 16)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _loadRandomTechnique();
                      _loadRandomPhrase();
                    },
                    child: Text('Actualizar Técnica y Frase'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  SizedBox(height: 16.0),
                  SizedBox(
                    height: 100,
                  ),
                  Divider(height: 50),
                  FooterWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

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

//--------------------------------------------
//--------- pages/home_page.dart//
//--------------------------------------------

