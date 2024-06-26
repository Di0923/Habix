//--------------------------------------------
// pages/espacio_personal/editar_tecnica_page.dart
//--------------------------------------------
import 'package:flutter/material.dart';
import 'package:ihc_hi/data/database/database_helper.dart';

class EditarTecnicaPage extends StatefulWidget {
  final Map<String, dynamic> technique;

  EditarTecnicaPage({required this.technique});

  @override
  _EditarTecnicaPageState createState() => _EditarTecnicaPageState();
}

class _EditarTecnicaPageState extends State<EditarTecnicaPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.technique['name']);
    _descriptionController =
        TextEditingController(text: widget.technique['description']);
  }

  _saveTechnique() async {
    if (_formKey.currentState!.validate()) {
      final updatedTechnique = {
        'id': widget.technique['id'],
        'name': _nameController.text,
        'description': _descriptionController.text,
      };
      await DatabaseHelper().updateTechnique(updatedTechnique);
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
        title: Text('Editar Técnica'),
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
                      Icon(Icons.lightbulb_outline_rounded, size: 150),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'EDITAR',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'TÉCNICA',
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
                'Nombre de la técnica',
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
                'Descripción de la técnica',
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
              SizedBox(height: 70.0),
              ElevatedButton(
                onPressed: _saveTechnique,
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
// pages/espacio_personal/editar_tecnica_page.dart
//--------------------------------------------
