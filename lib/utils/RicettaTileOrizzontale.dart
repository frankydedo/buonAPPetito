// ignore_for_file: must_be_immutable

import 'package:buonappetito/models/Ricetta.dart';
import 'package:buonappetito/pages/RicettaPage.dart';
import 'package:buonappetito/providers/ColorsProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RicettaTileOrizzontale extends StatelessWidget {

  Ricetta ricetta;

  RicettaTileOrizzontale({super.key, required this.ricetta});

  @override
  Widget build(BuildContext context) {
    return Consumer<ColorsProvider>(
    builder: (context, colorsModel, _) {
    return Card(
      margin: EdgeInsets.zero,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RicettaPage(recipe: ricetta),
            ),
          );
        },
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                // border: Border.all(
                //   color: colorsModel.getColoreSecondario(),
                //   width: 1.5,
                // ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  ricetta.percorsoImmagine,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ricetta.titolo,
                    style: GoogleFonts.encodeSans(
                      textStyle: TextStyle(
                        color: colorsModel.getColoreTitoli(context),
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    ricetta.getCategorie(),
                    style: GoogleFonts.encodeSans(
                      textStyle: TextStyle(
                        color: colorsModel.getColoreTitoli(context),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // IconButton(
            //   icon: Icon(Icons.delete_rounded,
            //   color: colorsModel.getColoreSecondario(),
            //   ),
            //   onPressed: () {
            //     ricetteModel.rimuoviDaiPreferiti(ricetta);
            //   },
            // )
          ],
        ),
      ),
    );
    });
  }
}