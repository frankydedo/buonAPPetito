// ignore_for_file: unused_import

import 'package:buonappetito/models/Categoria.dart';
import 'package:buonappetito/models/Ricetta.dart';
import 'package:buonappetito/providers/ColorsProvider.dart';
import 'package:buonappetito/providers/RicetteProvider.dart';
import 'package:buonappetito/utils/AggiungiRicettaScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CategoriaPage extends StatefulWidget {
  const CategoriaPage({super.key});

  @override
  State<CategoriaPage> createState() => _CategoriaPageState();
}

class _CategoriaPageState extends State<CategoriaPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<ColorsProvider, RicetteProvider>(
      builder: (context, colorsModel, ricetteModel, _) {
        final List<Categoria> categorie = ricetteModel.categorie;
        final List<Ricetta> ricette = ricetteModel.ricette;
        Map<String, int> conteggioCategorie = _calcolaConteggioCategorie(ricette);

        return Scaffold(
          backgroundColor: colorsModel.backgroudColor,
          appBar: AppBar(
            backgroundColor: colorsModel.backgroudColor,
            title: Text(
              'LISTA DI CATEGORIE',
              style: GoogleFonts.encodeSans(
                color: colorsModel.coloreTitoli,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            iconTheme: IconThemeData(
              color: colorsModel.coloreSecondario,
              size: 28.0,
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: colorsModel.coloreSecondario),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: categorie.isNotEmpty
              ? Padding(               
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                child: Column(
                    children: [
                      // Text(
                      //   'LISTA DI CATEGORIE',
                      //   style: GoogleFonts.encodeSans(
                      //     color: colorsModel.coloreTitoli,
                      //     fontSize: 22,
                      //     fontWeight: FontWeight.w800,
                      //   ),
                      // ),
                      SizedBox(height: 20),
                      Expanded(
                        child: ListView.builder(
                          itemCount: categorie.length,
                          itemBuilder: (context, index) {
                            final categoria = categorie[index];
                            final int numeroRicette = conteggioCategorie[categoria.nome] ?? 0;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: InkWell(
                                onTap: () {
                                  print(categoria.nome);
                                  Navigator.pushNamed(context,'/ricettepercategoriepage',arguments: categoria.nome,);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: colorsModel.tileBackGroudColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.checklist_rounded,
                                            color: colorsModel.coloreSecondario,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            categoria.nome,
                                            style: GoogleFonts.encodeSans(
                                              color: colorsModel.coloreTitoli,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        '$numeroRicette ricette',
                                        style: GoogleFonts.encodeSans(
                                          color: colorsModel.coloreTitoli,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
              )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.checklist_rounded,
                        color: Colors.grey,
                        size: 80,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Nulla da vedere qui',
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
                        'Aggiungi nuove categorie \nper vederle qui.',
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
          floatingActionButton: FloatingActionButton(
            backgroundColor: colorsModel.coloreSecondario,
            child: Icon(Icons.add, color: Colors.white, size: 35),
            onPressed: () {
              Navigator.pushNamed(context,'/creacategoriapage',
                arguments: {
                  'onUpdate': () {
                    _aggiornaConteggioCategorie();
                  },
                },
              );
            },
          ),
        );
      },
    );
  }

  void _aggiornaConteggioCategorie() {
    setState(() {});
  }

  Map<String, int> _calcolaConteggioCategorie(List<Ricetta> ricette) {
    Map<String, int> conteggioCategorie = {};
    for (Ricetta ricetta in ricette) {
      List<String> categorieDellaRicetta = ricetta.getCategorie().split(' | ');
      for (String categoria in categorieDellaRicetta) {
        if (conteggioCategorie.containsKey(categoria)) {
          conteggioCategorie[categoria] = conteggioCategorie[categoria]! + 1;
        } else {
          conteggioCategorie[categoria] = 1;
        }
      }
    }
    return conteggioCategorie;
  }
}
