import 'package:buonappetito/models/Ricetta.dart';
import 'package:buonappetito/providers/ColorsProvider.dart';
import 'package:buonappetito/providers/RicetteProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AggiungiRicettaScreen extends StatelessWidget {
  final String categoriaNome;
  final Function onUpdate;

  AggiungiRicettaScreen({required this.categoriaNome, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return Consumer<ColorsProvider>(builder: (context, colorsModel, _) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Aggiungi Ricetta a $categoriaNome'),
        ),
        body: Center(
          child: AlertDialog(
            backgroundColor: colorsModel.dialogBackgroudColor,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.help_outline,
                  color: colorsModel.coloreSecondario,
                  size: 70,
                ),
                SizedBox(height: 20),
                Text(
                  'Scegli un\'opzione per aggiungere una ricetta alla categoria "$categoriaNome" \n altrimenti la categoria viene eliminata',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                // tasti
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: colorsModel.coloreSecondario,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        elevation: 5,
                        shadowColor: Colors.black,
                      ),
                      onPressed: () {
                        // Implementa la logica per aggiungere una ricetta esistente
                        _showSelectRicettaDialog(context, onUpdate);
                      },
                      child: Text(
                        'Aggiungi Ricetta Esistente',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: colorsModel.coloreSecondario,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    elevation: 5,
                    shadowColor: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/nuovaricettapage').then((_) {
                      onUpdate();
                      Navigator.popUntil(context, ModalRoute.withName('/categoriapage'));
                    });
                  },
                  child: Text(
                    'Crea Nuova Ricetta',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

 void _showSelectRicettaDialog(BuildContext context, Function onUpdate) {
  // Lista per tenere traccia delle ricette selezionate
  List<Ricetta> ricetteSelezionate = [];

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Seleziona una o più ricette'),
            content: Container(
              width: double.minPositive,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: Provider.of<RicetteProvider>(context, listen: false).ricette.length,
                itemBuilder: (context, index) {
                  Ricetta ricetta = Provider.of<RicetteProvider>(context, listen: false).ricette[index];
                  bool isRicettaSelected = ricetteSelezionate.contains(ricetta);

                  return ListTile(
                    title: Text(ricetta.titolo),
                    leading: Checkbox(
                      activeColor: Provider.of<ColorsProvider>(context, listen: false).coloreSecondario,
                      value: isRicettaSelected,
                      onChanged: (value) {
                        setState(() {
                          if (value != null && value) {
                            ricetteSelezionate.add(ricetta);
                          } else {
                            ricetteSelezionate.remove(ricetta);
                          }
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                child: Text('ANNULLA'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text('SALVA'),
                onPressed: () {
                  // Aggiungi le categorie selezionate alla ricetta
                  for (Ricetta ricetta in ricetteSelezionate) {
                    if (!ricetta.getCategorie().contains(categoriaNome)) {
                      ricetta.aggiungiNuovaCategoria(categoriaNome);
                    }
                  }
                  Navigator.pop(context);
                  onUpdate();
                  Navigator.popUntil(context, ModalRoute.withName('/categoriapage'));
                },
              ),
            ],
          );
        },
      );
    },
  );
}
}