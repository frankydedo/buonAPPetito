// ignore_for_file: unused_import

import 'dart:io';
import 'dart:math';

import 'package:buonappetito/models/Categoria.dart';
import 'package:buonappetito/models/Ricetta.dart';
import 'package:buonappetito/pages/NuovaRicettaPage.dart';
import 'package:buonappetito/providers/ColorsProvider.dart';
import 'package:buonappetito/providers/RicetteProvider.dart';
import 'package:buonappetito/utils/ConfermaDialog.dart';
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
  final Function onUpdate;
  const CreaCategoriaPage({super.key, required this.onUpdate});

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
            'Una ricetta con lo stesso nome è già presente.',
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
      categoriaNome = categoriaNome[0].toUpperCase()+categoriaNome.substring(1).toLowerCase(); // formatto la stringa con solo la prima lettera maiuscola
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
          backgroundColor: Color.fromRGBO(26, 35, 126, 1),
        ),
      );

      // Esegui l'aggiornamento della pagina
      widget.onUpdate();

      // Naviga indietro
      Navigator.popUntil(context, ModalRoute.withName('/categoriapage'));
    }
  }

  bool hasBeenModified(){
    
    if(controller.text.isNotEmpty){
      return true;
    }
    if(ricetteSelezionate.isNotEmpty){
      return true;
    }

    return false;
  }

  Future showConfermaDialog (){
  return showDialog(
      context: context,
      builder: (context) => ConfermaDialog(domanda: "Sei sicuro di voler uscire?"),
    );
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
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: colorsModel.coloreSecondario, size: 29),
              onPressed: () async {
                if(hasBeenModified()){
                  bool conferma = await showConfermaDialog();
                  if(conferma){
                    Navigator.pop(context);
                  }
                }else{
                  Navigator.pop(context);
                }
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
          body: SingleChildScrollView(
            child: Padding(
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
                    style: TextStyle(
                      color: Provider.of<ColorsProvider>(context, listen: false).textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 88,
                        width: screenWidth * 0.4,
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
                          child: Column(
                            children: [
                              Text(
                                'Ricetta',
                                style: GoogleFonts.encodeSans(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700
                                )
                              ),
                              Text(
                                'Esistente',
                                style: GoogleFonts.encodeSans(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700
                                )
                              ),
                            ],
                          ),
                          onPressed: () {
                            // Naviga alla schermata per aggiungere una ricetta esistente
                            _showSelectRicettaDialog(context, widget.onUpdate, controller.text.trim(), ricetteSelezionate);
                          },
                        ),
                      ),
                      SizedBox(
                        height: 88,
                        width: screenWidth * 0.4,
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
                          child: Column(
                            children: [
                              Text(
                                'Nuova',
                                style: GoogleFonts.encodeSans(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700
                                )
                              ),
                              Text(
                                'Ricetta',
                                style: GoogleFonts.encodeSans(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700
                                )
                              ),
                            ],
                          ),
                          onPressed: () async {
                            // Naviga alla schermata per creare una nuova ricetta e aspetta il risultato
                            final nuovaRicetta = await Navigator.push(context, MaterialPageRoute(builder: (context) => NuovaRicettaPage(categorieCanBeEmpty: true)));
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
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  ricetteSelezionate.isNotEmpty
                      ? Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: SizedBox(
                          height: ricetteSelezionate.length * 88 <150 ? 150 : min(ricetteSelezionate.length * 125, 470),
                          width: screenWidth * 0.9,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                              child: ListView.builder(
                                itemCount: ricetteSelezionate.length,
                                itemBuilder: (context, index) {
                                  Ricetta ric = ricetteSelezionate[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Slidable(
                                      endActionPane: ActionPane(
                                        motion: DrawerMotion(),
                                        children: [
                                          SlidableAction(
                                            onPressed: (context) {
                                              setState(() {
                                                ricetteSelezionate.remove(ric);
                                              });
                                            },
                                            borderRadius: BorderRadius.circular(20),
                                            icon: Icons.delete_outline,
                                            backgroundColor: Colors.red,
                                          )
                                        ],
                                      ),
                                      child: GestureDetector(
                                        child: RicettaTileOrizzontale(ricetta: ric),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
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
                                'Nessuna ricetta selezionata',
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
                  // Spacer(),
            
                  // tasto crea categoria
            
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: colorsModel.coloreSecondario,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 5,
                        shadowColor: Colors.black,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 6.0, top: 6, right: 30, left:30),
                          child: Center(
                            child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "Crea Categoria",
                              style: GoogleFonts.encodeSans(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
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
          ),
        );
      },
    );
  }
}

void _showSelectRicettaDialog(BuildContext context, Function onUpdate, String categoriaNome, List<Ricetta> ricetteSelezionate) {
  // Lista per tenere traccia delle ricette selezionate temporaneamente
  List<Ricetta> temporarySelectedRicette = List.from(ricetteSelezionate);

  // Variabile per il testo della ricerca
  String searchText = '';

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          // l'utente può cercare per nome, categoria o ingredienti
          List<Ricetta> filteredRicette = Provider.of<RicetteProvider>(context, listen: false).ricette.where((ricetta) {
            return ricetta.titolo.toLowerCase().contains(searchText.toLowerCase()) ||
                   ricetta.ingredienti.keys.toList().any((ingrediente) => ingrediente.toLowerCase().contains(searchText.toLowerCase())) ||
                   ricetta.categorie.toList().any((categoria) => categoria.toLowerCase().contains(searchText.toLowerCase()));
          }).toList();

          return AlertDialog(
            backgroundColor: Provider.of<ColorsProvider>(context, listen: false).dialogBackgroudColor,
            title: Text('Seleziona una o più ricette', style: TextStyle(color: Provider.of<ColorsProvider>(context, listen: false).textColor)),
            content: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Barra di ricerca
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Cerca',
                      border: OutlineInputBorder(),
                    ),
                    style: TextStyle(
                      color: Provider.of<ColorsProvider>(context, listen: false).textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  // Lista delle ricette filtrate
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredRicette.length,
                      itemBuilder: (context, index) {
                        Ricetta ricetta = filteredRicette[index];
                        bool isRicettaSelected = temporarySelectedRicette.contains(ricetta);

                        return ListTile(
                          title: Text(ricetta.titolo, style: TextStyle(color: Provider.of<ColorsProvider>(context, listen: false).textColor),),
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
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text(
                  'ANNULLA',
                  style: GoogleFonts.encodeSans(
                    color: Provider.of<ColorsProvider>(context, listen: false).coloreSecondario,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                onPressed: () {
                  ricetteSelezionate.clear();
                  ricetteSelezionate.addAll(temporarySelectedRicette);
                  onUpdate();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Provider.of<ColorsProvider>(context, listen: false).coloreSecondario,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  elevation: 5,
                  shadowColor: Colors.black,
                ),
                child: Text(
                  'SALVA',
                  style: GoogleFonts.encodeSans(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
