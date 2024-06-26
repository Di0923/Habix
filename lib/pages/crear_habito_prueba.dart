//--------------------------------------------
//--------- pages/crear_habito_prueba.dart
//--------------------------------------------
import 'package:flutter/material.dart';
import 'package:ihc_hi/data/database/database_helper.dart';

class CrearHabitoPruebaPage extends StatefulWidget {
  @override
  _CrearHabitoPruebaPageState createState() => _CrearHabitoPruebaPageState();
}

class _CrearHabitoPruebaPageState extends State<CrearHabitoPruebaPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  int _currentImageIndex = 0;
  String _selectedTechniqueId = '';
  int _selectedDays = 3;
  final List<String> _images = [
    'assets/images/corriendo_hombre.png',
    'assets/images/corriendo_mujer.png',
    'assets/images/meditando_hombre.png',
    'assets/images/meditando_mujer.png',
    'assets/images/entrenando_hombre.png',
  ];

  Future<List<Map<String, dynamic>>>? _techniquesFuture;

  @override
  void initState() {
    super.initState();
    _techniquesFuture = DatabaseHelper().fetchTechniques();
  }

  _saveHabit() async {
    if (_formKey.currentState!.validate()) {
      final String fechaCreacion = DateTime.now().toIso8601String();
      final habit = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'days': _selectedDays,
        'technique': _selectedTechniqueId,
        'image': _images[_currentImageIndex],
        'estado': 'activo', // Estado inicial del hábito
        'fechaCreacion': fechaCreacion, // Fecha de creación
        'diasTranscurridos': 0, // Inicializa en 0
        'diasRestantes': _selectedDays, // Copia el valor de days
        'comodines': 3, //inicializar comodines en 3
      };
      await DatabaseHelper().insertHabit(habit);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Hábito'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 60,
                      ),
                      Icon(Icons.rocket_launch_outlined, size: 150),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'CREANDO',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'HÁBITO',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 60.0),
              Text(
                'Dale un nombre',
                style: TextStyle(fontSize: 20),
              ),
              Container(
                height: 2.0, // Altura de la línea
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 100.0,
                    colors: [
                      Colors.blue.withOpacity(0.5),
                      Colors.blue.withOpacity(0.2),
                    ],
                    stops: [0.5, 1.0],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un nombre';
                  }
                  return null;
                },
              ),
              SizedBox(height: 60.0),
              Text(
                'Selecciona una imagen',
                style: TextStyle(fontSize: 20),
              ),
              Container(
                height: 2.0, // Altura de la línea
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 100.0,
                    colors: [
                      Colors.blue.withOpacity(0.5),
                      Colors.blue.withOpacity(0.2),
                    ],
                    stops: [0.5, 1.0],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_left),
                    onPressed: () {
                      setState(() {
                        _currentImageIndex =
                            (_currentImageIndex - 1 + _images.length) %
                                _images.length;
                      });
                    },
                  ),
                  Image.asset(
                    _images[_currentImageIndex],
                    width: 200,
                    height: 400,
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_right),
                    onPressed: () {
                      setState(() {
                        _currentImageIndex =
                            (_currentImageIndex + 1) % _images.length;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Text(
                'Dale una descripción',
                style: TextStyle(fontSize: 20),
              ),
              Container(
                height: 2.0, // Altura de la línea
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 100.0,
                    colors: [
                      Colors.blue.withOpacity(0.5),
                      Colors.blue.withOpacity(0.2),
                    ],
                    stops: [0.5, 1.0],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una descripción';
                  }
                  return null;
                },
              ),
              SizedBox(height: 60.0),
              Text(
                'Selecciona los días',
                style: TextStyle(fontSize: 20),
              ),
              Container(
                height: 2.0, // Altura de la línea
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 100.0,
                    colors: [
                      Colors.blue.withOpacity(0.5),
                      Colors.blue.withOpacity(0.2),
                    ],
                    stops: [0.5, 1.0],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              DropdownButtonFormField<int>(
                value: _selectedDays,
                items: [3, 21, 30].map((label) {
                  return DropdownMenuItem(
                    child: Text('$label días'),
                    value: label,
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDays = value!;
                  });
                },
              ),
              // Agregado el mensaje en rojo debajo del DropdownButtonFormField
              SizedBox(height: 10),
              Text(
                '¡Selecciona bien, los días no se pueden modificar!',
                style: TextStyle(color: Colors.red),
              ),
              SizedBox(height: 60.0),
              Text(
                'Añade una técnica inicial',
                style: TextStyle(fontSize: 20),
              ),
              Container(
                height: 2.0, // Altura de la línea
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 100.0,
                    colors: [
                      Colors.blue.withOpacity(0.5),
                      Colors.blue.withOpacity(0.2),
                    ],
                    stops: [0.5, 1.0],
                  ),
                ),
              ),
              SizedBox(height: 20),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _techniquesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No techniques found.');
                  } else {
                    return DropdownButtonFormField<String>(
                      items: snapshot.data!.map((technique) {
                        return DropdownMenuItem<String>(
                          child: Text(technique['name']),
                          value: technique['id']
                              .toString(), // Usar el ID de la técnica como cadena
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedTechniqueId =
                              value!; // Guardar el ID de la técnica seleccionada como cadena
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor selecciona una técnica';
                        }
                        return null;
                      },
                    );
                  }
                },
              ),
              SizedBox(height: 70.0),
              ElevatedButton(
                onPressed: _saveHabit,
                child: Text('Crear'),
              ),
              SizedBox(height: 40.0),
              Divider(height: 50), // Línea divisoria
              FooterWidget(), // Footer en la parte inferior
            ],
          ),
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
//--------- pages/crear_habito_prueba.dart //
//--------------------------------------------
