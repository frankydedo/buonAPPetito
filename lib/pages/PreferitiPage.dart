// ignore_for_file: unused_import

import 'package:buonappetito/models/Ricetta.dart';
import 'package:buonappetito/providers/ColorsProvider.dart';
import 'package:buonappetito/providers/RicetteProvider.dart';
import 'package:buonappetito/utils/RicettaTileOrizzontale.dart';
import 'package:buonappetito/utils/TilePreferiti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PreferitiPage extends StatefulWidget {
  const PreferitiPage({super.key});

  @override
  State<PreferitiPage> createState() => _PreferitiPageState();
}

class _PreferitiPageState extends State<PreferitiPage> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Consumer2<ColorsProvider, RicetteProvider>(
      builder: (context, colorsModel, ricetteModel, _) {
        final List<Ricetta> preferiti = ricetteModel.preferiti;
        return Scaffold(
          body: Container(
            child: preferiti.isNotEmpty
                ? Column(
                  children: [
                    Text(
                    'LE TUE RICETTE PREFERITE',
                      style: GoogleFonts.encodeSans(
                        color: colorsModel.getColoreTitoli(context),
                        fontSize: 22,
                        fontWeight: FontWeight.w800
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: preferiti.length,
                          itemBuilder: (context, index) {
                            final ricetta = preferiti[index];
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(12.0, 24, 12, 0),
                              child: Slidable(
                                endActionPane: ActionPane(
                                  motion: DrawerMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) {
                                        setState(() {
                                          ricetteModel.rimuoviDaiPreferiti(ricetta);
                                        });
                                      },
                                      borderRadius: BorderRadius.circular(20),
                                      icon: Icons.heart_broken_rounded,
                                      backgroundColor: colorsModel.getColoreSecondario(),
                                      foregroundColor: Colors.white,
                                    )
                                  ],
                                ),
                                child: TilePreferiti(ricetta: ricetta)
                              ),
                            );
                          },
                        ),
                    ),
                  ],
                )

                  // da mostrare in caso di lista vuota
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
                          'Non hai ricette preferite',
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
                          'Aggiungi le tue ricette preferite \nper vederle qui.',
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
          ),
        );
      },
    );
  }
}
