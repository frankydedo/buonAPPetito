// ignore_for_file: unused_local_variable

import 'dart:io';
import 'dart:math';

import 'package:buonappetito/models/Categoria.dart';
import 'package:buonappetito/models/Ricetta.dart';
import 'package:buonappetito/providers/ColorsProvider.dart';
import 'package:buonappetito/providers/RicetteProvider.dart';
import 'package:buonappetito/utils/MyCategoriaDialog.dart';
import 'package:buonappetito/utils/NuovoIngredienteDialog.dart';
import 'package:buonappetito/utils/NuovoPassaggioDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class NuovaRicettaPage extends StatefulWidget {
  const NuovaRicettaPage({super.key});

  @override
  State<NuovaRicettaPage> createState() => _NuovaRicettaPageState();
}

class _NuovaRicettaPageState extends State<NuovaRicettaPage> {

  final _formKey = GlobalKey<FormState>();

  String? percorsoImmagine;
  String? titolo;
  String? descrizione;
  Map<String, String> ingredientiInseriti = {};
  List<String> categorie = [];
  List<String> passaggiInseriti = [];
  int? difficolta;
  int? minutiPreparazione;
  DateTime? dataAggiunta;
  bool isFavourite = false;

  Map<Categoria, bool> selezioneCategorie = {};

  FocusNode _focusNode_titolo = FocusNode();
  FocusNode _focusNode_descrizione = FocusNode();
  FocusNode _focusNode_tempo = FocusNode();

  Future<void> pickImageFromCamera() async {
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);

    if (image == null) return;

    String imagePath = await saveImage(image.path);
    setState(() {
      percorsoImmagine = imagePath;
    });
  }

  Future<void> pickImageFromGallery() async {
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return;

    String imagePath = await saveImage(image.path);
    setState(() {
      percorsoImmagine = imagePath;
    });
  }

  Future<String> saveImage(String imagePath) async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String saveDirPath = path.join(appDocDir.path, 'foto_piatti_gz');

    final Directory saveDir = Directory(saveDirPath);
    if (!await saveDir.exists()) {
      await saveDir.create(recursive: true);
    }

    final String fileName = path.basename(imagePath);
    final String newPath = path.join(saveDirPath, fileName);

    final File newImage = await File(imagePath).copy(newPath);

    return newImage.path;
  }

  Future<Map<String, String>?> showNuovoIngredienteDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => NuovoIngredienteDialog(msg: "Qual è il prossimo ingrediente?"),
    );
  }

  Future? showNuovoPassaggioDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => NuovoPassaggioDialog(msg: "Qual è il prossimo step?"),
    );
  }

  Future<Map<Categoria, bool>?> showCategorieDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => MyCategoriaDialog(selezioneCategorie: selezioneCategorie),
    );
  }

  void generaDifficoltaInAutomatico() {
    int diffPassaggi;
    if (passaggiInseriti.length <= 4) {
      diffPassaggi = 1;
    } else if (passaggiInseriti.length<= 6) {
      diffPassaggi = 2;
    } else if (passaggiInseriti.length <= 8) {
      diffPassaggi = 3;
    } else if (passaggiInseriti.length <= 10) {
      diffPassaggi = 4;
    } else {
      diffPassaggi = 5;
    }

    int diffTempo;
    if (minutiPreparazione! <= 15) {
      diffTempo = 1;
    } else if (minutiPreparazione! <= 30) {
      diffTempo = 2;
    } else if (minutiPreparazione! <= 60) {
      diffTempo = 3;
    } else if (minutiPreparazione! <= 90) {
      diffTempo = 4;
    } else {
      diffTempo = 5;
    }

    // il calcolo della difficolta prende in considerazione:
    //
    // - num. di passaggi necessari per completare la ricetta (peso 70%);
    // - minuti di preparazione necessari (peso 30%).
    //
    // se ne calcola la media pesata e si arrotonda per difetto (e.g. 3.51 --> 4 , 3.49 --> 3 , 3.50 --> 3)
    setState(() {
      this.difficolta = ((diffPassaggi*0.7 + diffTempo*0.3)-0.01).round();
    });
  }
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    void unfocus(){
      FocusScope.of(context).unfocus();
    }

    return Consumer2<ColorsProvider, RicetteProvider>(
      builder: (context, colorsModel, ricetteModel, _) {
        return Scaffold(
          appBar: AppBar(),
          body: GestureDetector(
            onTap: (){
              unfocus();
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // titolo (si adatta alle dimensioni così da essere sempre su un rigo)
                    Center(
                      child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "Crea una nuova ricetta",
                        style: GoogleFonts.encodeSans(
                          textStyle: TextStyle(
                            color: colorsModel.getColoreTitoli(context),
                            fontSize: 35,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    ),
                    SizedBox(height: 20),
            
                    // inserimento dati relativi alla ricetta
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                // titolo
                                Text(
                                  "Titolo",
                                  style: GoogleFonts.encodeSans(
                                    textStyle: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Spacer(),
                                SizedBox(
                                  width: screenWidth * 0.68,
                                  child: TextFormField(
                                    textInputAction: TextInputAction.done,
                                    onFieldSubmitted: (_){},
                                    focusNode: _focusNode_titolo,
                                    textAlign: TextAlign.start,
                                    textAlignVertical: TextAlignVertical.top,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Inserire il titolo della ricetta";
                                      } else if (value.length > 40) {
                                        return "Max 40 caratteri";
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      titolo = value;
                                    },
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20)
                                      ),
                                      hintStyle: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
            
                          // descrizione
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Spacer(),
                                    Text(
                                      "Descrizione",
                                      style: GoogleFonts.encodeSans(
                                        textStyle: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                  ],
                                ),
                                SizedBox(
                                  height: screenHeight * 0.15,
                                  child: TextFormField(
                                    textInputAction: TextInputAction.done,
                                    onFieldSubmitted: (_){},
                                    focusNode: _focusNode_descrizione,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Inserire una descrizione";
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      descrizione = value;
                                    },
                                    maxLines: 5,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20)
                                      ),
                                      hintStyle: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
            
                          //categorie
            
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Center(
                                      child: Text(
                                        "Categorie",
                                        style: GoogleFonts.encodeSans(
                                          textStyle: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Spacer(),
            
                                    // tasto
                                    Row(
                                      children: [
                                        Spacer(),
                                        ElevatedButton(
                                          onPressed: () async {
                                            selezioneCategorie= (await showCategorieDialog(context))!;
                                            if (selezioneCategorie.isNotEmpty) {
                                              List<String> categorieSelezionate = [];
                                              for (MapEntry<Categoria, bool> entry in selezioneCategorie.entries ){
                                                if(entry.value){
                                                  categorieSelezionate.add(entry.key.nome);
                                                }
                                              }
                                              setState(() {
                                                categorie.clear();
                                                categorie.addAll(categorieSelezionate);
                                              });
                                            }
                                            unfocus();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: colorsModel.getColoreSecondario(),
                                          ),
                                          child: Icon(Icons.add, color: Colors.white, size: 25),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
            
                                // vista delle categorie inserite
                                categorie.isEmpty
                                    ? Center(
                                        child: Text(
                                          "\nInserisci le categorie di cui il\npiatto fa parte :]",
                                          style: GoogleFonts.encodeSans(
                                            color: Colors.grey,
                                            fontSize: 20,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: SizedBox(
                                          height: categorie.length * 88 <110 ? 110 : min(categorie.length * 70, 470),
                                          width: screenWidth *0.9,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(20),
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: categorie.length,
                                                itemBuilder: (context, index) {
                                                  String cat = categorie.elementAt(index);
                                                  return Padding(
                                                    padding: const EdgeInsets.only(top: 8.0, right: 8, left: 8),
                                                    child: Slidable(
                                                      endActionPane: ActionPane(
                                                        motion: DrawerMotion(),
                                                        children: [
                                                          SlidableAction(
                                                            onPressed: (context) {
                                                              setState(() {
                                                                categorie.remove(cat);
                                                                for (var entry in selezioneCategorie.entries){
                                                                  if (entry.key.nome == cat){
                                                                    selezioneCategorie[entry.key] = false;
                                                                  }
                                                                }
                                                              });
                                                            },
                                                            borderRadius: BorderRadius.circular(20),
                                                            icon: Icons.delete_outline,
                                                            backgroundColor: Colors.red,
                                                          )
                                                        ],
                                                      ),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.circular(20),
                                                        ),
                                                        child: ListTile(
                                                          title: Text(
                                                            cat,
                                                            style: GoogleFonts.encodeSans(
                                                                    fontSize: 22,
                                                                    fontWeight: FontWeight.w500,
                                                                    color: Colors.black, 
                                                                  ),
                                                          )
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
            
                          // ingredienti
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Center(
                                      child: Text(
                                        "Ingredienti",
                                        style: GoogleFonts.encodeSans(
                                          textStyle: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Spacer(),
            
                                    // tasto
                                    Row(
                                      children: [
                                        Spacer(),
                                        ElevatedButton(
                                          onPressed: () async {
                                            Map<String, String>? nuovoIngrediente = await showNuovoIngredienteDialog(context);
                                            if (nuovoIngrediente != null && nuovoIngrediente.isNotEmpty) {
                                              setState(() {
                                                ingredientiInseriti.addAll(nuovoIngrediente);
                                              });
                                            }
                                            unfocus();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: colorsModel.getColoreSecondario(),
                                          ),
                                          child: Icon(Icons.add, color: Colors.white, size: 25),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
            
                                // vista degli ingredienti inseriti
                                ingredientiInseriti.isEmpty
                                    ? Center(
                                        child: Text(
                                          "\nAncora nessun ingrediente :/",
                                          style: GoogleFonts.encodeSans(
                                            color: Colors.grey,
                                            fontSize: 20,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: SizedBox(
                                          height: ingredientiInseriti.length * 88 <110 ? 110 : min(ingredientiInseriti.length * 88, 470),
                                          width: screenWidth *0.9,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(20),
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: ingredientiInseriti.length,
                                                itemBuilder: (context, index) {
                                                  String key = ingredientiInseriti.keys.elementAt(index);
                                                  String value = ingredientiInseriti[key]!;
                                                  return Padding(
                                                    padding: const EdgeInsets.only(top: 8.0, right: 8, left: 8),
                                                    child: Slidable(
                                                      endActionPane: ActionPane(
                                                        motion: DrawerMotion(),
                                                        children: [
                                                          SlidableAction(
                                                            onPressed: (context) {
                                                              setState(() {
                                                                ingredientiInseriti.remove(key);
                                                              });
                                                            },
                                                            borderRadius: BorderRadius.circular(20),
                                                            icon: Icons.delete_outline,
                                                            backgroundColor: Colors.red,
                                                          )
                                                        ],
                                                      ),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.circular(20),
                                                        ),
                                                        child: ListTile(
                                                          title: Text(
                                                            "$key".toUpperCase(),
                                                            style: GoogleFonts.encodeSans(
                                                              fontSize: 22,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                          subtitle: Text(
                                                            "$value",
                                                            style: GoogleFonts.encodeSans(
                                                              fontSize: 18,
                                                              fontWeight: FontWeight.w300,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
            
                          // passaggi
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Center(
                                      child: Text(
                                        "Passaggi",
                                        style: GoogleFonts.encodeSans(
                                          textStyle: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Spacer(),
            
                                    // tasto
                                    Row(
                                      children: [
                                        Spacer(),
                                        ElevatedButton(
                                          onPressed: () async {
                                            String? nuovoPassaggio = await showNuovoPassaggioDialog(context);
                                            if (nuovoPassaggio != null && nuovoPassaggio.isNotEmpty) {
                                              setState(() {
                                                passaggiInseriti.add(nuovoPassaggio);
                                              });
                                            }
                                            unfocus();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: colorsModel.getColoreSecondario(),
                                          ),
                                          child: Icon(Icons.add, color: Colors.white, size: 25),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
            
                                // vista dei passaggi inseriti
                                passaggiInseriti.isEmpty
                                    ? Center(
                                        child: Text(
                                          "\nInserisci i passaggi da eseguire :)",
                                          style: GoogleFonts.encodeSans(
                                            color: Colors.grey,
                                            fontSize: 20,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: SizedBox(
                                          height: passaggiInseriti.length * 88 <110 ? 110 : min(passaggiInseriti.length * 88, 470),
                                          width: screenWidth *0.9,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(20),
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: passaggiInseriti.length,
                                                itemBuilder: (context, index) {
                                                  String pass = passaggiInseriti.elementAt(index);
                                                  return Padding(
                                                    padding: const EdgeInsets.only(top: 8.0, right: 8, left: 8),
                                                    child: Slidable(
                                                      endActionPane: ActionPane(
                                                        motion: DrawerMotion(),
                                                        children: [
                                                          SlidableAction(
                                                            onPressed: (context) {
                                                              setState(() {
                                                                passaggiInseriti.remove(pass);
                                                              });
                                                            },
                                                            borderRadius: BorderRadius.circular(20),
                                                            icon: Icons.delete_outline,
                                                            backgroundColor: Colors.red,
                                                          )
                                                        ],
                                                      ),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.circular(20),
                                                        ),
                                                        child: ListTile(
                                                          title: RichText(
                                                            text: TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                  text: "STEP ${(index + 1).toString()}",
                                                                  style: GoogleFonts.encodeSans(
                                                                    fontSize: 22,
                                                                    fontWeight: FontWeight.w700,
                                                                    color: Colors.black, 
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                  text: ": "+pass,
                                                                  style: GoogleFonts.encodeSans(
                                                                    fontSize: 22,
                                                                    fontWeight: FontWeight.w500,
                                                                    color: Colors.black, 
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                              
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
            
                          // tempo
            
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Tempo di Preparazione",
                              style: GoogleFonts.encodeSans(
                                fontSize: 25,
                                fontWeight: FontWeight.w700
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  "Minuti:",
                                  style: GoogleFonts.encodeSans(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
                                Spacer(),
                                SizedBox(
                                  width: screenWidth * 0.68,
                                  child: TextFormField(
                                    textInputAction: TextInputAction.done,
                                    onFieldSubmitted: (_){},
                                    focusNode: _focusNode_tempo,
                                    keyboardType: TextInputType.numberWithOptions(),
                                    textAlign: TextAlign.center,
                                    textAlignVertical: TextAlignVertical.top,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Inserire i minuti necessari";
                                      }
                                      if (int.tryParse(value) == null) {
                                        return "Inserire un valore numerico";
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      try {
                                        minutiPreparazione = int.parse(value);
                                      } catch (e) {
                                        print("Errore di parsing: $e");
                                      }
                                    },
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      hintStyle: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
            
                          // difficoltà
            
                          Stack(
                            children: [
                              Padding(padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  "Difficoltà",
                                  style: GoogleFonts.encodeSans(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w700
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (minutiPreparazione!=null && passaggiInseriti.isNotEmpty){
                                        generaDifficoltaInAutomatico();
                                      }else{
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text("Inserire tempo di preparazione e passaggi per sbloccare la generazione automatica.", style: TextStyle(color: Colors.white, fontSize: 18),), backgroundColor: Colors.red),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      elevation: (minutiPreparazione!=null && passaggiInseriti.isNotEmpty) ? 1 : 0,
                                      backgroundColor: (minutiPreparazione!=null && passaggiInseriti.isNotEmpty) ? colorsModel.getColoreSecondario() : colorsModel.getColoreSecondario().withOpacity(.5) ,
                                    ),
                                    child: Icon(Icons.auto_awesome_rounded , color: Colors.white, size: 25),
                                  ),
                                ),
                              ],
                            ),
                            ]
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: SizedBox(
                              width: screenWidth *0.9,
                              height: 360,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                                child: Column(
                                  children: [
            
                                    // list tile per le difficoltà
            
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                                      child: GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            difficolta = 1;
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(
                                              width: 1.5,
                                              color: difficolta == 1 ? colorsModel.getColoreSecondario() : Colors.transparent
                                            )
                                          ),
                                          child: ListTile(
                                            title: Row(
                                              children: [
                                                Text(
                                                  "Principiante",
                                                  style: GoogleFonts.encodeSans(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600
                                                  ),
                                                ),
                                                Spacer(),
                                                Row(
                                                  children: [
                                                    Icon(Icons.restaurant_menu_rounded, color: colorsModel.coloreSecondario, size: 30),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                                      child: GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            difficolta = 2;
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(
                                              width: 1.5,
                                              color: difficolta == 2 ? colorsModel.getColoreSecondario() : Colors.transparent
                                            )
                                          ),
                                          child: ListTile(
                                            title: Row(
                                              children: [
                                                Text(
                                                  "Amatoriale",
                                                  style: GoogleFonts.encodeSans(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600
                                                  ),
                                                ),
                                                Spacer(),
                                                Row(
                                                  children: [
                                                    Icon(Icons.restaurant_menu_rounded, color: colorsModel.coloreSecondario, size: 30),
                                                    Icon(Icons.restaurant_menu_rounded, color: colorsModel.coloreSecondario, size: 30),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                                      child: GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            difficolta = 3;
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(
                                              width: 1.5,
                                              color: difficolta == 3 ? colorsModel.getColoreSecondario() : Colors.transparent
                                            )
                                          ),
                                          child: ListTile(
                                            title: Row(
                                              children: [
                                                Text(
                                                  "Intermedio",
                                                  style: GoogleFonts.encodeSans(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600
                                                  ),
                                                ),
                                                Spacer(),
                                                Row(
                                                  children: [
                                                    Icon(Icons.restaurant_menu_rounded, color: colorsModel.coloreSecondario, size: 30),
                                                    Icon(Icons.restaurant_menu_rounded, color: colorsModel.coloreSecondario, size: 30),
                                                    Icon(Icons.restaurant_menu_rounded, color: colorsModel.coloreSecondario, size: 30),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                                      child: GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            difficolta = 4;
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(
                                              width: 1.5,
                                              color: difficolta == 4 ? colorsModel.getColoreSecondario() : Colors.transparent
                                            )
                                          ),
                                          child: ListTile(
                                            title: Row(
                                              children: [
                                                Text(
                                                  "Chef",
                                                  style: GoogleFonts.encodeSans(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600
                                                  ),
                                                ),
                                                Spacer(),
                                                Row(
                                                  children: [
                                                    Icon(Icons.restaurant_menu_rounded, color: colorsModel.coloreSecondario, size: 30),
                                                    Icon(Icons.restaurant_menu_rounded, color: colorsModel.coloreSecondario, size: 30),
                                                    Icon(Icons.restaurant_menu_rounded, color: colorsModel.coloreSecondario, size: 30),
                                                    Icon(Icons.restaurant_menu_rounded, color: colorsModel.coloreSecondario, size: 30),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                                      child: GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            difficolta = 5;
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(
                                              width: 1.5,
                                              color: difficolta == 5 ? colorsModel.getColoreSecondario() : Colors.transparent
                                            )
                                          ),
                                          child: ListTile(
                                            title: Row(
                                              children: [
                                                Text(
                                                  "Chef Stellato",
                                                  style: GoogleFonts.encodeSans(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600
                                                  ),
                                                ),
                                                Spacer(),
                                                Row(
                                                  children: [
                                                    Icon(Icons.restaurant_menu_rounded, color: colorsModel.coloreSecondario, size: 30),
                                                    Icon(Icons.restaurant_menu_rounded, color: colorsModel.coloreSecondario, size: 30),
                                                    Icon(Icons.restaurant_menu_rounded, color: colorsModel.coloreSecondario, size: 30),
                                                    Icon(Icons.restaurant_menu_rounded, color: colorsModel.coloreSecondario, size: 30),
                                                    Icon(Icons.restaurant_menu_rounded, color: colorsModel.coloreSecondario, size: 30),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ),
                            ),
                          ),
            
                          // foto
            
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Column(
                                  children: [
                                    Center(
                                      child: Text(
                                        "Foto",
                                        style: GoogleFonts.encodeSans(
                                          textStyle: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // tasti per il caricamento della foto
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Spacer(),
            
                                          // carica dalla camera
                                          ElevatedButton(
                                            onPressed: () => pickImageFromCamera(),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: colorsModel.getColoreSecondario(),
                                            ),
                                            child: Icon(Icons.camera_alt_rounded, color: Colors.white, size: 25),
                                          ),
                                          SizedBox(width: 30),
            
                                          //carica dalla galleria
                                          ElevatedButton(
                                            onPressed: () => pickImageFromGallery(),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: colorsModel.getColoreSecondario(),
                                            ),
                                            child: Icon(Icons.photo_library_rounded, color: Colors.white, size: 25),
                                          ),
                                          Spacer()
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
            
                                // preview immagine selezionata
                                percorsoImmagine==null
                                    ? Center(
                                        child: Text(
                                          "\nCarica la foto della tua creazione :P",
                                          style: GoogleFonts.encodeSans(
                                            color: Colors.grey,
                                            fontSize: 20,
                                          ),
                                        ),
                                      )
                                    : Center(
                                      child: Slidable(
                                        endActionPane: ActionPane(
                                        motion: DrawerMotion(),
                                        children: [
                                          SlidableAction(
                                            onPressed: (context) {
                                              setState(() {
                                                percorsoImmagine = null;
                                              });
                                            },
                                            borderRadius: BorderRadius.circular(20),
                                            icon: Icons.delete_outline,
                                            backgroundColor: Colors.red,
                                          )
                                        ],
                                      ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                          child: Stack(
                                            children: [
                                              Image.asset(
                                                percorsoImmagine!,
                                                height: screenHeight*0.45,
                                                fit: BoxFit.cover,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                              ],
                            ),
                          ),
            
                          //tasto per la creazoine della ricetta
                          ElevatedButton(
                            onPressed: (){
                              // controllo che sia stato inserito tutto e nel caso avviso l'utente su cosa manca
                              if (_formKey.currentState!.validate()){
                                if(categorie.isEmpty){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Selezionare le categorie", style: TextStyle(color: Colors.white, fontSize: 18),), backgroundColor: Colors.red),
                                  );
                                }else if(ingredientiInseriti.isEmpty){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Inserire gli ingredienti", style: TextStyle(color: Colors.white, fontSize: 18),), backgroundColor: Colors.red),
                                  );
                                }else if(passaggiInseriti.isEmpty){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Inserire i passaggi", style: TextStyle(color: Colors.white, fontSize: 18),), backgroundColor: Colors.red),
                                  );
                                }else if(difficolta==null){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Selezionare la difficoltà", style: TextStyle(color: Colors.white, fontSize: 18),), backgroundColor: Colors.red),
                                  );
                                }else if(percorsoImmagine==null){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Inserire la foto", style: TextStyle(color: Colors.white, fontSize: 18),), backgroundColor: Colors.red),
                                  );
                                }else{
                                  Ricetta nuovaRicetta = Ricetta(
                                    percorsoImmagine: percorsoImmagine!, 
                                    categorie: categorie, 
                                    descrizione: descrizione!, 
                                    ingredienti: ingredientiInseriti, 
                                    passaggi: passaggiInseriti, 
                                    titolo: titolo!, 
                                    minutiPreparazione: minutiPreparazione!, 
                                    dataAggiunta: DateTime.now(),
                                    difficolta: difficolta!
                                  );
                                  ricetteModel.aggiungiNuovaRicetta(nuovaRicetta);
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Ricetta inserita correttamente", style: TextStyle(color: Colors.white, fontSize: 18),), backgroundColor: Color.fromRGBO(26, 35, 126, 1)),
                                  );
                                  print(ricetteModel.ricette.length.toString());
                                }
                              }
                            }, 
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorsModel.getColoreSecondario()
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0, top: 6, right: 30, left:30),
                              child: Text(
                                "Crea Ricetta",
                                style: GoogleFonts.encodeSans(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700
                                ),
                              ),
                            )
                          )
                        ],
                      ),
                    ),
            
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
