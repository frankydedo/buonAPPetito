// ignore_for_file: prefer_const_constructors, must_be_immutable, prefer_const_literals_to_create_immutables, unused_import, unnecessary_import

import 'package:buonappetito/utils/MyDialog.dart';
import 'package:buonappetito/models/Ricetta.dart';
import 'package:buonappetito/pages/SearchPage.dart';
import 'package:buonappetito/providers/ColorsProvider.dart';
import 'package:buonappetito/providers/RicetteProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MyDialog extends StatelessWidget {
  final Function (bool) onSelectionChanged;
  MyDialog({super.key, required this.onSelectionChanged});


  @override
  Widget build(BuildContext context) {
    return Consumer2<ColorsProvider, RicetteProvider>(
      builder: (context, colorsModel, ricetteModel, _) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: SizedBox(
            width: 400,
            height: 350,
            child: Column(
              children: [
                Icon(
                  Icons.checklist_rounded,
                  color: Colors.orange.shade600,
                  size: 70,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ricetteModel.categorie.isNotEmpty
                      ? ListView.builder(
                          itemCount: ricetteModel.categorie.length,
                          itemBuilder: (context, index) {
                            return CheckboxListTile(
                              activeColor: colorsModel.getColoreSecondario(),
                              title: Text(
                                ricetteModel.categorie.elementAt(index).nome,
                                style: GoogleFonts.encodeSans(
                                  textStyle: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              value: ricetteModel.selectedCategories[index],
                              onChanged: (val) {
                                ricetteModel.toggleCategorySelection(index);
                                onSelectionChanged (
                                  ricetteModel.selectedCategories.contains(true)
                                );
                              },
                            );
                          },
                        )
                      : Center(
                          child: Text(
                            'No categories available',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
                            ricetteModel.resetSelections();
                            onSelectionChanged(false);
                          }, 
                            style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, 
                            backgroundColor:colorsModel.getColoreSecondario() , // Cambia il colore in base allo stato del bottone,
                            shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            elevation: 5,
                            shadowColor: Colors.black,
                          ),                          
                          child: 
                          Text(
                              "Reset",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // save button
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          }, 
                            style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, 
                            backgroundColor:colorsModel.getColoreSecondario() , // Cambia il colore in base allo stato del bottone,
                            shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            elevation: 5,
                            shadowColor: Colors.black,
                          ),                          
                          child: 
                          Text(
                              "Salva",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
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
