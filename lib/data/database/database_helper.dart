//--------------------------------------------
//---------database_helper.dart//
//--------------------------------------------
import 'dart:math';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  DatabaseHelper.internal();

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'habits.db');

    return await openDatabase(path,
        version: 6, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
      'CREATE TABLE Habit(id INTEGER PRIMARY KEY, name TEXT, description TEXT, days INTEGER, technique TEXT, image TEXT, estado TEXT, fechaCreacion TEXT, motivacionPersonal TEXT, diasTranscurridos INTEGER, diasRestantes INTEGER, comodines INTEGER)',
    );
    await db.execute(
      'CREATE TABLE Technique(id INTEGER PRIMARY KEY, name TEXT, description TEXT)',
    );
    await db.execute(
      'CREATE TABLE Phrase(id INTEGER PRIMARY KEY, name TEXT, phrase TEXT)',
    );
    await db.execute(
      'CREATE TABLE Usuario(id INTEGER PRIMARY KEY, nombre TEXT)',
    );
    await db.execute(
      'CREATE TABLE Notificaciones(id INTEGER PRIMARY KEY, mensaje TEXT, hora TEXT)',
    );
    //-----n
    await db.execute(
      'CREATE TABLE HabitTechnique(id INTEGER PRIMARY KEY, habitId INTEGER, techniqueId INTEGER, FOREIGN KEY(habitId) REFERENCES Habit(id), FOREIGN KEY(techniqueId) REFERENCES Technique(id))',
    );
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE Habit ADD COLUMN estado TEXT');
    }
    if (oldVersion < 3) {
      await db.execute('ALTER TABLE Phrase ADD COLUMN name TEXT');
    }
    if (oldVersion < 4) {
      await db.execute('ALTER TABLE Habit ADD COLUMN fechaCreacion TEXT');
    }
    if (oldVersion < 5) {
      await db.execute('ALTER TABLE Habit ADD COLUMN motivacionPersonal TEXT');
      await db
          .execute('ALTER TABLE Habit ADD COLUMN diasTranscurridos INTEGER');
      await db.execute('ALTER TABLE Habit ADD COLUMN diasRestantes INTEGER');
      await db.execute('ALTER TABLE Habit ADD COLUMN comodines INTEGER');
    }
    if (oldVersion < 6) {
      await db
          .execute('CREATE TABLE Usuario(id INTEGER PRIMARY KEY, nombre TEXT)');
      await db.execute(
          'CREATE TABLE Notificaciones(id INTEGER PRIMARY KEY, mensaje TEXT, hora TEXT)');
    }
    //----------- n
    if (oldVersion < 7) {
      await db.execute(
        'CREATE TABLE HabitTechnique(id INTEGER PRIMARY KEY, habitId INTEGER, techniqueId INTEGER, FOREIGN KEY(habitId) REFERENCES Habit(id), FOREIGN KEY(techniqueId) REFERENCES Technique(id))',
      );
    }
  }

  // Métodos para la tabla Habit
  Future<int> insertHabit(Map<String, dynamic> habit) async {
    var dbClient = await db;
    return await dbClient.insert('Habit', habit);
  }

  Future<List<Map<String, dynamic>>> getHabitsByState(String estado) async {
    var dbClient = await db;
    return await dbClient
        .query('Habit', where: 'estado = ?', whereArgs: [estado]);
  }

  Future<int> updateHabit(Map<String, dynamic> habit) async {
    var dbClient = await db;
    return await dbClient
        .update('Habit', habit, where: 'id = ?', whereArgs: [habit['id']]);
  }

  Future<int> deleteHabit(int id) async {
    var dbClient = await db;
    return await dbClient.delete('Habit', where: 'id = ?', whereArgs: [id]);
  }

  // Métodos para la tabla Technique
  Future<int> insertTechnique(Map<String, dynamic> technique) async {
    var dbClient = await db;
    return await dbClient.insert('Technique', technique);
  }

  Future<List<Map<String, dynamic>>> getTechniques() async {
    var dbClient = await db;
    return await dbClient.query('Technique');
  }

  Future<int> updateTechnique(Map<String, dynamic> technique) async {
    var dbClient = await db;
    return await dbClient.update('Technique', technique,
        where: 'id = ?', whereArgs: [technique['id']]);
  }

  Future<int> deleteTechnique(int id) async {
    var dbClient = await db;
    return await dbClient.delete('Technique', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> fetchTechniques() async {
    var dbClient = await db;
    return await dbClient.query('Technique');
  }

  // Métodos para la tabla Phrase
  Future<int> insertPhrase(Map<String, dynamic> phrase) async {
    var dbClient = await db;
    return await dbClient.insert('Phrase', phrase);
  }

  Future<List<Map<String, dynamic>>> getPhrases() async {
    var dbClient = await db;
    return await dbClient.query('Phrase');
  }

  Future<int> updatePhrase(Map<String, dynamic> phrase) async {
    var dbClient = await db;
    return await dbClient
        .update('Phrase', phrase, where: 'id = ?', whereArgs: [phrase['id']]);
  }

  Future<int> deletePhrase(int id) async {
    var dbClient = await db;
    return await dbClient.delete('Phrase', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getActiveHabits() async {
    var dbClient = await db;
    return await dbClient
        .query('Habit', where: 'estado = ?', whereArgs: ['activo']);
  }

  Future<Map<String, dynamic>> getRandomTechnique() async {
    var dbClient = await db;
    List<Map<String, dynamic>> techniques = await dbClient.query('Technique');
    if (techniques.isNotEmpty) {
      final _random = new Random();
      return techniques[_random.nextInt(techniques.length)];
    } else {
      return {
        'name': 'No disponible',
        'description': 'No hay técnicas disponibles'
      };
    }
  }

  Future<Map<String, dynamic>> getRandomPhrase() async {
    var dbClient = await db;
    List<Map<String, dynamic>> phrases = await dbClient.query('Phrase');
    if (phrases.isNotEmpty) {
      final _random = new Random();
      return phrases[_random.nextInt(phrases.length)];
    } else {
      return {'name': 'No disponible', 'phrase': 'No hay frases disponibles'};
    }
  }

  // Métodos para la tabla Usuario

  //------------------- Métodos para la tabla Usuario
  Future<int> insertOrUpdateUsuario(Map<String, dynamic> usuario) async {
    var dbClient = await db;
    List<Map<String, dynamic>> existingUsers = await dbClient.query('Usuario');
    if (existingUsers.isNotEmpty) {
      return await dbClient.update('Usuario', usuario,
          where: 'id = ?', whereArgs: [existingUsers.first['id']]);
    } else {
      return await dbClient.insert('Usuario', usuario);
    }
  }
  //----------------

  Future<int> insertUsuario(Map<String, dynamic> usuario) async {
    var dbClient = await db;
    return await dbClient.insert('Usuario', usuario);
  }

  Future<int> updateUsuario(Map<String, dynamic> usuario) async {
    var dbClient = await db;
    return await dbClient.update('Usuario', usuario,
        where: 'id = ?', whereArgs: [usuario['id']]);
  }

  Future<Map<String, dynamic>> getUsuario() async {
    var dbClient = await db;
    List<Map<String, dynamic>> result = await dbClient.query('Usuario');
    return result.isNotEmpty ? result.first : {};
  }

  Future<void> printUsuario() async {
    var dbClient = await db;
    List<Map<String, dynamic>> result = await dbClient.query('Usuario');
    result.forEach((row) {
      print(row);
    });
  }

  // Métodos para la tabla Notificaciones
  Future<int> insertNotificacion(Map<String, dynamic> notificacion) async {
    var dbClient = await db;
    return await dbClient.insert('Notificaciones', notificacion);
  }

  Future<List<Map<String, dynamic>>> getNotificaciones() async {
    var dbClient = await db;
    return await dbClient.query('Notificaciones');
  }

  Future<int> deleteNotificacion(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete('Notificaciones', where: 'id = ?', whereArgs: [id]);
  }

  //---------n habittechnique
// Métodos para la tabla HabitTechnique
  Future<int> insertHabitTechnique(int habitId, int techniqueId) async {
    var dbClient = await db;
    return await dbClient.insert(
        'HabitTechnique', {'habitId': habitId, 'techniqueId': techniqueId});
  }

  Future<List<Map<String, dynamic>>> getHabitTechniques(int habitId) async {
    var dbClient = await db;
    return await dbClient
        .query('HabitTechnique', where: 'habitId = ?', whereArgs: [habitId]);
  }

  Future<int> deleteHabitTechniques(int habitId) async {
    var dbClient = await db;
    return await dbClient
        .delete('HabitTechnique', where: 'habitId = ?', whereArgs: [habitId]);
  }
}



//--------------------------------------------
//---------database_helper.dart//
//--------------------------------------------
