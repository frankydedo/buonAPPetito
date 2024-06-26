// ignore_for_file: prefer_const_constructors, must_be_immutable, prefer_const_literals_to_create_immutables, unused_import, unnecessary_import, unused_local_variable, deprecated_member_use

import 'package:buonappetito/models/Categoria.dart';
import 'package:buonappetito/models/Ricetta.dart';
import 'package:buonappetito/pages/SearchPage.dart';
import 'package:buonappetito/providers/ColorsProvider.dart';
import 'package:buonappetito/providers/RicetteProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MyCategoriaDialog extends StatefulWidget {
  Map<Categoria, bool> selezioneCategorie;

  MyCategoriaDialog({super.key, required this.selezioneCategorie});

  @override
  State<MyCategoriaDialog> createState() => _MyCategoriaDialogState();
}

class _MyCategoriaDialogState extends State<MyCategoriaDialog> {

  Map<Categoria, bool> selezionePrecedente = {};

  @override
  void initState(){
    super.initState();
    for(var entry in widget.selezioneCategorie.entries){
      selezionePrecedente.addAll({entry.key : entry.value});
    }
  }

  void _showAddCategoryDialog(RicetteProvider ricetteModel) {
    TextEditingController categoriaController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text("Aggiungi Categoria"),
          content: TextField(
            controller: categoriaController,
            decoration: InputDecoration(
              hintText: "Nome Categoria",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Annulla", style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: () {
                String newCategoriaNome = categoriaController.text.trim();
                if (newCategoriaNome.isNotEmpty) {
                  Categoria newCategoria = Categoria(nome: newCategoriaNome);
                  setState(() {
                    ricetteModel.aggiungiNuovaCategoria(newCategoria);
                    widget.selezioneCategorie[newCategoria] = false;
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Provider.of<ColorsProvider>(context, listen: false).getColoreSecondario()
              ),
              child: Text("Aggiungi", style: TextStyle(color: Colors.white),),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ColorsProvider, RicetteProvider>(
      builder: (context, colorsModel, ricetteModel, _) {
        return WillPopScope(
          onWillPop: () async {
            Navigator.pop(context, selezionePrecedente);
            return false;
          },
          child: AlertDialog(
            backgroundColor: Colors.white,
            content: SizedBox(
              width: 400,
              height: 500,
              child: Column(
                children: [
                  Stack(
                    children:[
                      Center(
                        child: Icon(
                          Icons.checklist_rounded,
                          color: colorsModel.getColoreSecondario(),
                          size: 70,
                        ),
                      ),
                      Row(
                        children: [
                          //tasto return
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context, selezionePrecedente);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.arrow_back_ios, color:colorsModel.getColoreSecondario()),
                            )
                          ),
                          Spacer(),
                          //tasto aggiugni categoria
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () => _showAddCategoryDialog(ricetteModel),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: colorsModel.getColoreSecondario(),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                elevation: 5,
                                shadowColor: Colors.black,
                              ),
                              child: Icon(Icons.add, color: Colors.white),
                            ),
                          ),
                        ],
                      )
                    ]
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ricetteModel.categorie.isNotEmpty
                        ? ListView.builder(
                            itemCount: ricetteModel.categorie.length,
                            itemBuilder: (context, index) {
                              Categoria categoria = ricetteModel.categorie[index];
                              bool isSelected = widget.selezioneCategorie[categoria] ?? false;
                              return CheckboxListTile(
                                activeColor: colorsModel.getColoreSecondario(),
                                title: Text(
                                  categoria.nome,
                                  style: GoogleFonts.encodeSans(
                                    textStyle: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                value: isSelected,
                                onChanged: (val) {
                                  setState(() {
                                    widget.selezioneCategorie[categoria] = val!;
                                  });
                                },
                              );
                            },
                          )
                        : Center(
                            child: Text(
                              'Nessuna categoria disponibile :/',
                              style: GoogleFonts.encodeSans(
                                color: Colors.grey,
                                fontSize: 20
                              )
                            ),
                          ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //reset button
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            widget.selezioneCategorie.updateAll((key, value) => false);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, 
                          backgroundColor: colorsModel.getColoreSecondario(),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          elevation: 5,
                          shadowColor: Colors.black,
                        ),                          
                        child: Text(
                          "Reset",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // save button
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, widget.selezioneCategorie);
                        }, 
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, 
                          backgroundColor: colorsModel.getColoreSecondario(),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          elevation: 5,
                          shadowColor: Colors.black,
                        ),                          
                        child: Text(
                          "Salva",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
