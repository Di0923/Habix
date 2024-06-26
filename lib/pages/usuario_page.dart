//------------------------
//---------usuario_page
//------------------------
import 'package:flutter/material.dart';
import 'package:ihc_hi/data/database/database_helper.dart';
import 'package:ihc_hi/pages/notification_helper.dart';

class UsuarioPage extends StatefulWidget {
  @override
  _UsuarioPageState createState() => _UsuarioPageState();
}

class _UsuarioPageState extends State<UsuarioPage> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _mensajeController = TextEditingController();
  TimeOfDay? _selectedTime;
  late Future<Map<String, dynamic>> usuario;
  late Future<List<Map<String, dynamic>>> notificaciones;

  @override
  void initState() {
    super.initState();
    usuario = DatabaseHelper().getUsuario();
    notificaciones = DatabaseHelper().getNotificaciones();
    NotificationHelper.initializeNotifications();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuración de Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20.0),
              Icon(
                Icons.person_4_outlined,
                size: 100,
              ),
              SizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Usuario y Notificaciones',
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
              SizedBox(height: 20.0),
              FutureBuilder<Map<String, dynamic>>(
                future: usuario,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No se encontraron datos del usuario');
                  } else {
                    var data = snapshot.data!;
                    if (_nombreController.text.isEmpty &&
                        data['nombre'] != null) {
                      _nombreController.text = data['nombre'];
                    }
                    return Column(
                      children: [
                        TextField(
                          controller: _nombreController,
                          decoration:
                              InputDecoration(labelText: 'Nombre de Usuario'),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () async {
                            await DatabaseHelper().insertOrUpdateUsuario({
                              'nombre': _nombreController.text,
                            });
                            setState(() {
                              usuario = DatabaseHelper().getUsuario();
                            });
                          },
                          child: Text('Guardar Nombre'),
                        ),
                        if (data['nombre'] != null)
                          ListTile(
                            title:
                                Text('Nombre del Usuario: ${data['nombre']}'),
                          ),
                        Divider(),
                        TextField(
                          controller: _mensajeController,
                          decoration: InputDecoration(
                              labelText: 'Mensaje de Notificación'),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _selectTime(context),
                          child: Text('Seleccionar Hora'),
                        ),
                        SizedBox(height: 16),
                        Text(_selectedTime != null
                            ? 'Hora Seleccionada: ${_selectedTime!.format(context)}'
                            : 'No se ha seleccionado una hora'),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () async {
                            if (_selectedTime != null &&
                                _mensajeController.text.isNotEmpty) {
                              await DatabaseHelper().insertNotificacion({
                                'mensaje': _mensajeController.text,
                                'hora': _selectedTime!.format(context),
                              });
                              // Programar notificación
                              await NotificationHelper.scheduleNotification(
                                DateTime.now().millisecondsSinceEpoch % 100000,
                                'Recordatorio',
                                _mensajeController.text,
                                _selectedTime!,
                              );
                              _mensajeController.clear();
                              setState(() {
                                _selectedTime = null;
                                notificaciones =
                                    DatabaseHelper().getNotificaciones();
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Seleccione una hora y escriba un mensaje para la notificación'),
                                ),
                              );
                            }
                          },
                          child: Text('Añadir Notificación'),
                        ),
                        SizedBox(height: 16),
                        FutureBuilder<List<Map<String, dynamic>>>(
                          future: notificaciones,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Text('No se encontraron notificaciones');
                            } else {
                              var notificacionesList = snapshot.data!;
                              return Column(
                                children:
                                    notificacionesList.map((notificacion) {
                                  return ListTile(
                                    title: Text(notificacion['mensaje']),
                                    subtitle: Text(notificacion['hora']),
                                    trailing: IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () async {
                                        await DatabaseHelper()
                                            .deleteNotificacion(
                                                notificacion['id']);
                                        setState(() {
                                          notificaciones = DatabaseHelper()
                                              .getNotificaciones();
                                        });
                                      },
                                    ),
                                  );
                                }).toList(),
                              );
                            }
                          },
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//------------------------
//---------usuario_page
//------------------------