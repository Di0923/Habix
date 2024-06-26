//--------------------------------------------
//------- main.dart
//--------------------------------------------

import 'package:flutter/material.dart';
import 'package:ihc_hi/data/database/database_helper.dart';
import 'package:ihc_hi/pages/crear_frase.dart';
import 'package:ihc_hi/pages/crear_habito_prueba.dart';
import 'package:ihc_hi/pages/crear_tecnica.dart';
import 'package:ihc_hi/pages/home_page.dart';
import 'package:ihc_hi/pages/espacio_personal/ep_habitosDesarrollo.dart';
import 'package:ihc_hi/pages/espacio_personal/ep_habitosFinalizados.dart';
import 'package:ihc_hi/pages/espacio_personal/ep_habitosAbandonados.dart';
import 'package:ihc_hi/pages/espacio_personal/ep_tecnicas.dart';
import 'package:ihc_hi/pages/espacio_personal/ep_frasesMotivacionales.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().initDb();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'home',
      routes: {
        'home': (_) => HomePage(),
        'habitosDesarrollo': (_) => HabitosDesarrolloPage(),
        'habitosFinalizados': (_) => HabitosFinalizadosPage(),
        'habitosAbandonados': (_) => HabitosAbandonadosPage(),
        'tecnicas': (_) => TecnicasPage(),
        'frasesMotivacionales': (_) => FrasesMotivacionalesPage(),
        'crearHabitoPrueba': (_) => CrearHabitoPruebaPage(),
        'crearTecnica': (_) => CrearTecnicaPage(),
        'crearFrase': (_) => CrearFrasePage(),
      },
    );
  }
}
//--------------------------------------------
//------- main.dart //
//--------------------------------------------
