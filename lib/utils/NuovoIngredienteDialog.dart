import 'package:buonappetito/providers/ColorsProvider.dart';
import 'package:buonappetito/providers/RicetteProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NuovoIngredienteDialog extends StatefulWidget {
  final String msg;

  const NuovoIngredienteDialog({Key? key, required this.msg}) : super(key: key);

  @override
  _NuovoIngredienteDialogState createState() => _NuovoIngredienteDialogState();
}

class _NuovoIngredienteDialogState extends State<NuovoIngredienteDialog> {
  String? provIngrediente;
  String? provQuantita;
  String unit = "grammi";
  bool enableQuantita = true; 

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer2<ColorsProvider, RicetteProvider>(
      builder: (context, colorsModel, ricetteModel, _) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // icona [?]
                Icon(
                  Icons.help_outline,
                  color: colorsModel.getColoreSecondario(),
                  size: 70,
                ),
                SizedBox(height: 20),

                // testo richiesta
                Text(
                  widget.msg,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                SizedBox(height: 20),

                // form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // ingrediente
                      TextFormField(
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Completare campo";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          provIngrediente = value;
                        },
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Ingrediente',
                        ),
                      ),
                      SizedBox(height: 20),

                      // quantità e selettore unità
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              enabled: enableQuantita, // Abilita o Disabilita il campo in base allo stato
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (enableQuantita){
                                  if (value == null || value.isEmpty) {
                                    return "Completare campo";
                                  }
                                }
                                return null;
                              },
                              onChanged: (value) {
                                provQuantita = value;
                              },
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Quantità ciascuno',
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          DropdownButton<String>(
                            value: unit,
                            icon: Icon(Icons.arrow_downward),
                            onChanged: (String? newValue) {
                              setState(() {
                                unit = newValue!;
                                enableQuantita = (unit == 'grammi');
                                if (!enableQuantita) {
                                  provQuantita = '';
                                }
                              });
                            },
                            items: <String>['grammi', 'Q.B.']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // tasti
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [

                    // tasto annulla

                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(12),
                        width: 130,
                        decoration: BoxDecoration(
                          color: colorsModel.getColoreSecondario(),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              spreadRadius: 1.5,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "ANNULLA",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // tasto fatto
                    GestureDetector(
                      onTap: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          // Solo se l'unità è 'grammi', aggiunge il valore della quantità
                          if (unit == 'grammi') {
                            Map<String, String> nuovoIngrediente = {provIngrediente!: provQuantita! + " " + unit};
                            Navigator.pop(context, nuovoIngrediente);
                          } else {
                            // Altrimenti, aggiunge solo l'ingrediente senza quantità
                            Map<String, String> nuovoIngrediente = {provIngrediente!: "Q.B."};
                            Navigator.pop(context, nuovoIngrediente);
                          }
                        }
                      },
                      child: Container(
                        width: 130,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colorsModel.getColoreSecondario(),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              spreadRadius: 1.5,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "FATTO",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
