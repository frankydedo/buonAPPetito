import 'package:buonappetito/models/Ricetta.dart';
import 'package:buonappetito/providers/ColorsProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CaroselloTile extends StatelessWidget {
  final Ricetta ricetta;

  const CaroselloTile({required this.ricetta, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    //double screenWidth = MediaQuery.of(context).size.width;
    return Consumer<ColorsProvider>(builder: (context, colorsModel, _) {
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Image.asset(
                ricetta.percorsoImmagine,
                height: screenHeight*0.45,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Column(
                  children: [
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(left: 3.0),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          ricetta.getCategorie(),
                          style: GoogleFonts.encodeSans(
                            textStyle: TextStyle(
                              shadows: [
                                Shadow(
                                  blurRadius: 40.0,
                                  color: Colors.black,
                                  offset: Offset(0, 0),
                                ),
                              ],
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w600
                            )
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          ricetta.titolo,
                          style: GoogleFonts.encodeSans(
                            textStyle: TextStyle(
                              shadows: [
                                Shadow(
                                  blurRadius: 90.0,
                                  color: Colors.black,
                                  offset: Offset(0, 0),
                                ),
                              ],
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.w800
                            )
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          // diccifoltà
                          Icon(Icons.restaurant_menu_rounded, shadows: [Shadow(blurRadius: 120.0,color: Colors.black,offset: Offset(0, 0),),], color: ricetta.difficolta!>0 ? colorsModel.coloreSecondario : colorsModel.coloreSecondario.withOpacity(0.4), size: 30),
                          Icon(Icons.restaurant_menu_rounded, shadows: [Shadow(blurRadius: 120.0,color: Colors.black,offset: Offset(0, 0),),], color: ricetta.difficolta!>1 ? colorsModel.coloreSecondario : colorsModel.coloreSecondario.withOpacity(0.4), size: 30),
                          Icon(Icons.restaurant_menu_rounded, shadows: [Shadow(blurRadius: 120.0,color: Colors.black,offset: Offset(0, 0),),], color: ricetta.difficolta!>2 ? colorsModel.coloreSecondario : colorsModel.coloreSecondario.withOpacity(0.4), size: 30),
                          Icon(Icons.restaurant_menu_rounded, shadows: [Shadow(blurRadius: 120.0,color: Colors.black,offset: Offset(0, 0),),], color: ricetta.difficolta!>3 ? colorsModel.coloreSecondario : colorsModel.coloreSecondario.withOpacity(0.4), size: 30),
                          Icon(Icons.restaurant_menu_rounded, shadows: [Shadow(blurRadius: 120.0,color: Colors.black,offset: Offset(0, 0),),], color: ricetta.difficolta!>4 ? colorsModel.coloreSecondario : colorsModel.coloreSecondario.withOpacity(0.4), size: 30),
                
                          Spacer(),
                          // tempo
                          Icon(Icons.timer_outlined, shadows: [Shadow(blurRadius: 120.0,color: Colors.black,offset: Offset(0, 0),),], color: ricetta.minutiPreparazione>0 ? colorsModel.coloreSecondario : colorsModel.coloreSecondario.withOpacity(0.4), size: 30),
                          Icon(Icons.timer_outlined, shadows: [Shadow(blurRadius: 120.0,color: Colors.black,offset: Offset(0, 0),),], color: ricetta.minutiPreparazione>14 ? colorsModel.coloreSecondario : colorsModel.coloreSecondario.withOpacity(0.4), size: 30),
                          Icon(Icons.timer_outlined, shadows: [Shadow(blurRadius: 120.0,color: Colors.black,offset: Offset(0, 0),),], color: ricetta.minutiPreparazione>29 ? colorsModel.coloreSecondario : colorsModel.coloreSecondario.withOpacity(0.4), size: 30),
                          Icon(Icons.timer_outlined, shadows: [Shadow(blurRadius: 120.0,color: Colors.black,offset: Offset(0, 0),),], color: ricetta.minutiPreparazione>59 ? colorsModel.coloreSecondario : colorsModel.coloreSecondario.withOpacity(0.4), size: 30),
                          Icon(Icons.timer_outlined, shadows: [Shadow(blurRadius: 120.0,color: Colors.black,offset: Offset(0, 0),),], color: ricetta.minutiPreparazione>89 ? colorsModel.coloreSecondario : colorsModel.coloreSecondario.withOpacity(0.4), size: 30),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
