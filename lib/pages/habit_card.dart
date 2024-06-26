import 'package:flutter/material.dart';
import 'package:ihc_hi/data/database/database_helper.dart';

class HabitCard extends StatefulWidget {
  final Map<String, dynamic> habit;
  final Function onHabitUpdated;

  const HabitCard({Key? key, required this.habit, required this.onHabitUpdated})
      : super(key: key);

  @override
  _HabitCardState createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> {
  bool showButtons = true;

  void _handleHabitCompletion(bool completed) async {
    setState(() {
      showButtons = false;
    });

    // Crear una copia mutable del hábito
    Map<String, dynamic> updatedHabit = Map<String, dynamic>.from(widget.habit);

    int daysTranscurridos = (updatedHabit['diasTranscurridos'] ?? 0) + 1;
    int daysRestantes = (updatedHabit['diasRestantes'] ?? 0) - 1;
    int comodines = updatedHabit['comodines'] ?? 0;

    print('Antes de la actualización:');
    print('Días transcurridos: ${updatedHabit['diasTranscurridos']}');
    print('Días restantes: ${updatedHabit['diasRestantes']}');
    print('Comodines: ${updatedHabit['comodines']}');

    if (!completed) {
      comodines -= 1;
    }

    if (comodines < 0) {
      comodines = 0;
    }

    updatedHabit['diasTranscurridos'] = daysTranscurridos;
    updatedHabit['diasRestantes'] = daysRestantes;
    updatedHabit['comodines'] = comodines;

    if (comodines == 0) {
      updatedHabit['estado'] = 'abandonado';
    } else if (daysRestantes == 0) {
      updatedHabit['estado'] = 'finalizado';
    }

    await DatabaseHelper().updateHabit(updatedHabit);

    print('Después de la actualización:');
    print('Días transcurridos: $daysTranscurridos');
    print('Días restantes: $daysRestantes');
    print('Comodines: $comodines');

    widget.onHabitUpdated();
  }

  @override
  Widget build(BuildContext context) {
    int diasTranscurridos = widget.habit['diasTranscurridos'] ?? 0;
    int diasRestantes = widget.habit['diasRestantes'] ?? 0;
    int comodines = widget.habit['comodines'] ?? 0;

    String imageUrl = widget.habit['image'] ?? '';
    bool isLocalImage = !imageUrl.startsWith('http');

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 1.0),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    right: 1.0), // Ajusta el valor según lo necesario
                child: Text(
                  widget.habit['name'] ?? 'Nombre no disponible',
                  style: TextStyle(
                    fontSize:
                        20.0, // Ajusta el tamaño de la letra según lo necesario
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                // child: Icon(
                //   Icons.remove_red_eye,
                //   size: 25,
                //   color: Colors.black,
                // ),
              )
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: <Widget>[
              Expanded(
                flex: 6,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                isLocalImage
                                    ? Image.asset(imageUrl,
                                        height: 150, fit: BoxFit.cover)
                                    : Image.network(imageUrl,
                                        height: 150, fit: BoxFit.cover),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 1.0),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: SingleChildScrollView(
                              child: Container(
                                padding: EdgeInsets.all(8),
                                child: Text(widget.habit['description'] ??
                                    'No description'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                flex: 4,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 1.0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 10),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('Días transcurridos',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15)),
                                SizedBox(height: 8),
                                CircularProgressIndicator(
                                  value: diasTranscurridos /
                                      (diasTranscurridos + diasRestantes)
                                          .toDouble(),
                                  backgroundColor: Colors.grey[300],
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.blue),
                                ),
                                SizedBox(height: 8),
                                Text('$diasTranscurridos días',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 13)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('Comodines',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15)),
                                IconButton(
                                  icon: Icon(Icons.info_outline, size: 16),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Cada día que no cumplas tu hábito se restará un comodín. ¡Solo puedes fallar 3 veces!')));
                                  },
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(3, (index) {
                                    return Icon(
                                      Icons.favorite,
                                      color: index < comodines
                                          ? Colors.red
                                          : Colors.grey,
                                    );
                                  }),
                                ),
                                Text('$comodines comodines',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 13)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 10),
          showButtons
              ? Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          ElevatedButton.icon(
                            icon: Icon(Icons.arrow_upward),
                            label: Text('Hoy cumplí mi hábito'),
                            onPressed: () => _handleHabitCompletion(true),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          ElevatedButton.icon(
                            icon: Icon(Icons.arrow_downward),
                            label: Text('Hoy no cumplí mi hábito'),
                            onPressed: () => _handleHabitCompletion(false),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              : Text(
                  'Hoy ${widget.habit['diasRestantes'] > 0 ? 'cumpliste' : 'no cumpliste'} tu hábito'),
        ],
      ),
    );
  }
}
