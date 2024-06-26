//------------------------------------------------------
// pages/espacio_personal/editar_habitoDesarrollo.dart
//------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:ihc_hi/data/database/database_helper.dart';

class EditarHabitoPage extends StatefulWidget {
  final Map<String, dynamic> habit;

  EditarHabitoPage({required this.habit});

  @override
  _EditarHabitoPageState createState() => _EditarHabitoPageState();
}

class _EditarHabitoPageState extends State<EditarHabitoPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late int _currentImageIndex;
  late String _selectedTechnique;
  late int _selectedDays;
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
    _nameController = TextEditingController(text: widget.habit['name']);
    _descriptionController =
        TextEditingController(text: widget.habit['description']);
    _currentImageIndex = _images.indexOf(widget.habit['image']);
    _selectedTechnique = widget.habit['technique'];
    _selectedDays = widget.habit['days'];
    _techniquesFuture = DatabaseHelper().fetchTechniques();
    print('Valor de técnica: $_selectedTechnique');
  }

  _saveHabit() async {
    if (_formKey.currentState!.validate()) {
      final updatedHabit = {
        'id': widget.habit['id'],
        'name': _nameController.text,
        'description': _descriptionController.text,
        'days': _selectedDays,
        'technique': _selectedTechnique,
        'image': _images[_currentImageIndex],
        'estado': 'activo',
        'fechaCreacion': widget.habit['fechaCreacion'],
      };
      await DatabaseHelper().updateHabit(updatedHabit);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Hábito'),
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
                            'EDITANDO',
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
                height: 2.0,
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
                height: 2.0,
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
                height: 2.0,
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
                height: 2.0,
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
              TextFormField(
                initialValue: '$_selectedDays días',
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Los días no se pueden editar!',
                style: TextStyle(color: Colors.red),
              ),
              SizedBox(height: 60.0),
              Text(
                'Añade una técnica inicial',
                style: TextStyle(fontSize: 20),
              ),
              Container(
                height: 2.0,
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
                      value: _selectedTechnique,
                      items: snapshot.data!.map((technique) {
                        return DropdownMenuItem<String>(
                          child: Text(technique['name']),
                          value: technique['id'].toString(),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedTechnique = value!;
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
              //------------------ sección añade otra técnica -------------------------------------------
              SizedBox(height: 60.0),
              Text(
                'Añade otra técnica.',
                style: TextStyle(fontSize: 20),
              ),
              Container(
                height: 2.0,
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
                      value: _selectedTechnique,
                      items: snapshot.data!.map((technique) {
                        return DropdownMenuItem<String>(
                          child: Text(technique['name']),
                          value: technique['id'].toString(),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedTechnique = value!;
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
              //--------------------------------------------
              SizedBox(height: 70.0),
              ElevatedButton(
                onPressed: _saveHabit,
                child: Text('Guardar Cambios'),
              ),
              SizedBox(height: 40.0),
              Divider(height: 50),
              FooterWidget(),
            ],
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

//------------------------------------------------------
// pages/espacio_personal/editar_habitoDesarrollo.dart
//------------------------------------------------------
