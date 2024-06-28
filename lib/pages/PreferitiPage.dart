import 'package:buonappetito/models/Ricetta.dart';
import 'package:buonappetito/pages/RicettaPage.dart';
import 'package:buonappetito/providers/ColorsProvider.dart';
import 'package:buonappetito/providers/RicetteProvider.dart';
import 'package:flutter/material.dart';
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
          appBar: AppBar(
            centerTitle: true,
            title: Text(
            'Le tue Ricette Preferite',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
                color: colorsModel.getColoreSecondario()
              ),
            ),
            //backgroundColor: colorsModel.getColorePrimario(context),
          ),
          body: Container(
            margin: EdgeInsets.all(16),
            child: preferiti.isNotEmpty
                ? ListView.builder(
                    itemCount: preferiti.length,
                    itemBuilder: (context, index) {
                      final ricetta = preferiti[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(
                            color: colorsModel.getColoreSecondario(),
                            width: 1.5,
                          ),
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
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Container(
                                  width: screenWidth * 0.2,
                                  height: screenHeight * 0.1,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: colorsModel.getColoreSecondario(),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
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
                                            color: const Color.fromARGB(255, 16, 0, 0),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        ricetta.getCategorie(),
                                        style: GoogleFonts.encodeSans(
                                          textStyle: TextStyle(
                                            color: Color.fromARGB(255, 9, 0, 0),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete_rounded,
                                  color: colorsModel.getColoreSecondario(),
                                  ),
                                  onPressed: () {
                                    ricetteModel.rimuoviDaiPreferiti(ricetta);
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite_border,
                          color: colorsModel.getColoreSecondario(),
                          size: 80,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Non hai ricette preferite.',
                          style: GoogleFonts.encodeSans(
                            textStyle: TextStyle(
                              color: colorsModel.getColoreSecondario(),
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
