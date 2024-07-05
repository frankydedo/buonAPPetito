// ignore_for_file: unused_import

import 'dart:io';
import 'dart:math';

import 'package:buonappetito/models/Categoria.dart';
import 'package:buonappetito/models/Ricetta.dart';
import 'package:buonappetito/providers/ColorsProvider.dart';
import 'package:buonappetito/providers/RicetteProvider.dart';
import 'package:buonappetito/utils/MyCategoriaDialog.dart';
import 'package:buonappetito/utils/NuovoIngredienteDialog.dart';
import 'package:buonappetito/utils/NuovoPassaggioDialog.dart';
import 'package:buonappetito/utils/RicettaTileOrizzontale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class CreaCategoriaPage extends StatefulWidget {
  final String categoriaNome;
  final Function onUpdate;
  const CreaCategoriaPage({super.key, required this.categoriaNome, required this.onUpdate});

  @override
  State<CreaCategoriaPage> createState() => _CreaCategoriaPageState();
}

class _CreaCategoriaPageState extends State<CreaCategoriaPage> {
  TextEditingController controller = TextEditingController();
  List<Ricetta> ricetteSelezionate = [];

  void salvaPressed(List<Ricetta> ricetteSelezionate) {
    // Logica per salvare la categoria e le ricette selezionate
    String categoriaNome = controller.text.trim();
    if (categoriaNome.isEmpty) {
      // Mostra un messaggio di errore se il nome della categoria è vuoto
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Il nome della categoria non può essere vuoto.',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return; // Esce dal metodo senza eseguire ulteriori azioni
    } else if (ricetteSelezionate.isEmpty) {
      // Mostra un messaggio di errore se non è stata aggiunta alcuna ricetta
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Aggiungi una ricetta alla categoria creata.',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return; // Esce dal metodo senza eseguire ulteriori azioni
    } else if (Provider.of<RicetteProvider>(context, listen: false).categorie.any((categoria) => categoria.nome == categoriaNome)) {
      // Mostra un messaggio di errore se la categoria esiste già
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Il nome della categoria esiste già. Inserisci un nome diverso.',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return; // Esce dal metodo senza eseguire ulteriori azioni
    } else {
      // crea la nuova categoria
      Provider.of<RicetteProvider>(context, listen: false).aggiungiNuovaCategoria(Categoria(nome: categoriaNome, ricette: []));

      // Aggiungi la nuova categoria alle ricette selezionate
      for (Ricetta ricetta in ricetteSelezionate) {
        if (!ricetta.getCategorie().contains(categoriaNome)) {
          ricetta.aggiungiNuovaCategoria(categoriaNome);
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Categoria creata con successo.',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 2, 62, 110),
        ),
      );

      // Esegui l'aggiornamento della pagina
      widget.onUpdate();

      // Naviga indietro
      Navigator.popUntil(context, ModalRoute.withName('/categoriapage'));
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Consumer2<ColorsProvider, RicetteProvider>(
      builder: (context, colorsModel, ricetteModel, _) {
        return Scaffold(
          backgroundColor: colorsModel.backgroudColor,
          appBar: AppBar(
            backgroundColor: colorsModel.backgroudColor,
            iconTheme: IconThemeData(
              color: colorsModel.coloreSecondario,
              size: 28.0,
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: colorsModel.coloreTitoli),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              'Crea Categoria',
              style: GoogleFonts.encodeSans(
                color: colorsModel.coloreTitoli,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: controller,
                  cursorColor: colorsModel.coloreSecondario,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.create_rounded, color: Colors.grey.shade600),
                    hintText: 'Crea una categoria...',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: colorsModel.coloreSecondario,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: screenHeight * 0.07,
                      width: screenWidth * 0.30,
                      child: ElevatedButton(
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
                        child: Text(
                          'Aggiungi Ricetta \n       Esistente',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          // Naviga alla schermata per aggiungere una ricetta esistente
                          _showSelectRicettaDialog(context, widget.onUpdate, widget.categoriaNome, ricetteSelezionate);
                        },
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.07,
                      width: screenWidth * 0.30,
                      child: ElevatedButton(
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
                        child: Text(
                          'Crea Nuova \n    Ricetta',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () async {
                          // Naviga alla schermata per creare una nuova ricetta e aspetta il risultato
                          final nuovaRicetta = await Navigator.pushNamed(context, '/nuovaricettapage');
                          if (nuovaRicetta != null && nuovaRicetta is Ricetta) {
                            setState(() {
                              ricetteSelezionate.add(nuovaRicetta);
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Title for selected recipes
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Ricette Selezionate',
                    style: GoogleFonts.encodeSans(
                      color: colorsModel.coloreTitoli,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ricetteSelezionate.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: ricetteSelezionate.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RicettaTileOrizzontale(ricetta: ricetteSelezionate[index]),
                              ),
                            );
                          },
                        ),
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.heart_broken_rounded,
                              color: Colors.grey,
                              size: 80,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Non hai selezionato nessuna ricetta',
                              style: GoogleFonts.encodeSans(
                                textStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Aggiungi o crea ricette \nper vederle qui.',
                              style: GoogleFonts.encodeSans(
                                textStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                SizedBox(height: 20),
                SizedBox(
                  width: screenWidth*0.2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: colorsModel.coloreSecondario,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      elevation: 5,
                      shadowColor: Colors.black,
                    ),
                    child: Text(
                      'Salva',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      salvaPressed(ricetteSelezionate);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

void _showSelectRicettaDialog(BuildContext context, Function onUpdate, String categoriaNome, List<Ricetta> ricetteSelezionate) {
  // Lista per tenere traccia delle ricette selezionate temporaneamente
  List<Ricetta> temporarySelectedRicette = List.from(ricetteSelezionate);

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
                  bool isRicettaSelected = temporarySelectedRicette.contains(ricetta);

                  return ListTile(
                    title: Text(ricetta.titolo),
                    leading: Checkbox(
                      activeColor: Provider.of<ColorsProvider>(context, listen: false).coloreSecondario,
                      value: isRicettaSelected,
                      onChanged: (value) {
                        setState(() {
                          if (value != null && value) {
                            temporarySelectedRicette.add(ricetta);
                          } else {
                            temporarySelectedRicette.remove(ricetta);
                          }
                        });
                      },
                    ),
                    onTap: () {
                      setState(() {
                        if (isRicettaSelected) {
                          temporarySelectedRicette.remove(ricetta);
                        } else {
                          temporarySelectedRicette.add(ricetta);
                        }
                      });
                    },
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
                  // Update the original selected recipes list
                  ricetteSelezionate.clear();
                  ricetteSelezionate.addAll(temporarySelectedRicette);

                  // Aggiungi le categorie selezionate alla ricetta
                  for (Ricetta ricetta in ricetteSelezionate) {
                    if (!ricetta.getCategorie().contains(categoriaNome)) {
                      ricetta.aggiungiNuovaCategoria(categoriaNome);
                    }
                  }
                  onUpdate();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    },
  );
}
