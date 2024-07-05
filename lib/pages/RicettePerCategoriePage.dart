// ignore_for_file: unused_import

import 'package:buonappetito/models/Categoria.dart';
import 'package:buonappetito/models/Ricetta.dart';
import 'package:buonappetito/pages/RicettaPage.dart';
import 'package:buonappetito/pages/SearchPage.dart';
import 'package:buonappetito/providers/ColorsProvider.dart';
import 'package:buonappetito/providers/RicetteProvider.dart';
import 'package:buonappetito/utils/RicettaTileOrizzontale.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class RicettePerCategoriePage extends StatefulWidget {
  final String nomeCategorie;

  RicettePerCategoriePage({super.key, required this.nomeCategorie});

  @override
  State<RicettePerCategoriePage> createState() => RicettePerCategorieState();
}

class RicettePerCategorieState extends State<RicettePerCategoriePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<ColorsProvider, RicetteProvider>(
        builder: (context, colorsModel, ricetteModel, _) {
      final List<Ricetta> ricettaPerCategoria =
          trovaRicetta(widget.nomeCategorie, ricetteModel.ricette);
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
          ),
          body: ListView.builder(
              itemCount: ricettaPerCategoria.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                   onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context){return RicettaPage(recipe: ricettaPerCategoria[index]);}));
                      },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RicettaTileOrizzontale(
                        ricetta: ricettaPerCategoria[index]),
                  ),
                );
              }));
    });
  }
}

List<Ricetta> trovaRicetta(String categoria, List<Ricetta> ricette) {
  List<Ricetta> ricettaPerCategoria = [];
  for (Ricetta ricetta in ricette) {
    if (ricetta.getCategorie().contains(categoria)) {
      ricettaPerCategoria.add(ricetta);
    }
  }
  return ricettaPerCategoria;
}
