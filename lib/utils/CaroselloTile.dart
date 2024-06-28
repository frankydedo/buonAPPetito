import 'package:buonappetito/models/Ricetta.dart';
import 'package:buonappetito/providers/ColorsProvider.dart';
import 'package:buonappetito/providers/RicetteProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CaroselloTile extends StatefulWidget {
  final Ricetta ricetta;

  const CaroselloTile({required this.ricetta, Key? key}) : super(key: key);

  @override
  State<CaroselloTile> createState() => _CaroselloTileState();
}

class _CaroselloTileState extends State<CaroselloTile> {
  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    //double screenWidth = MediaQuery.of(context).size.width;
    return Consumer2<ColorsProvider, RicetteProvider>(builder: (context, colorsModel, ricetteModel, _) {
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Image.asset(
                widget.ricetta.percorsoImmagine,
                height: screenHeight*0.45,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Spacer(),
                        GestureDetector(
                          onTap: (){
                            if (widget.ricetta.isFavourite){
                              setState(() {
                                ricetteModel.rimuoviDaiPreferiti(widget.ricetta);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Ricetta rimossa dai preferiti", style: TextStyle(color: Colors.white, fontSize: 18),), backgroundColor: Color.fromRGBO(26, 35, 126, 1)),
                                );
                              });
                            }else{
                              setState(() {
                                ricetteModel.aggiungiAiPreferiti(widget.ricetta);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Ricetta aggiunta ai preferiti", style: TextStyle(color: Colors.white, fontSize: 18),), backgroundColor: Color.fromRGBO(26, 35, 126, 1)),
                                );
                              });
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: 
                            widget.ricetta.isFavourite ?
                            Icon(Icons.favorite_rounded, size: 35, color: Colors.white, shadows: [Shadow(blurRadius: 180.0,color: Colors.black,offset: Offset(0, 0))])
                            :
                            Icon(Icons.favorite_border_rounded, size: 35, color: Colors.white, shadows: [Shadow(blurRadius: 90.0,color: Colors.black,offset: Offset(0, 0))])
                          )
                        )
                      ],
                    ),
                    Spacer(),
                    // categorie ricetta
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          widget.ricetta.getCategorie(),
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
                    // titolo ricetta
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          widget.ricetta.titolo,
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
                          Icon(Icons.restaurant_menu_rounded, shadows: [Shadow(blurRadius: 120.0,color: Colors.black,offset: Offset(0, 0),),], color: widget.ricetta.difficolta!>0 ? colorsModel.coloreSecondario : Colors.white.withOpacity(0.5), size: 30),
                          Icon(Icons.restaurant_menu_rounded, shadows: [Shadow(blurRadius: 120.0,color: Colors.black,offset: Offset(0, 0),),], color: widget.ricetta.difficolta!>1 ? colorsModel.coloreSecondario : Colors.white.withOpacity(0.5), size: 30),
                          Icon(Icons.restaurant_menu_rounded, shadows: [Shadow(blurRadius: 120.0,color: Colors.black,offset: Offset(0, 0),),], color: widget.ricetta.difficolta!>2 ? colorsModel.coloreSecondario : Colors.white.withOpacity(0.5), size: 30),
                          Icon(Icons.restaurant_menu_rounded, shadows: [Shadow(blurRadius: 120.0,color: Colors.black,offset: Offset(0, 0),),], color: widget.ricetta.difficolta!>3 ? colorsModel.coloreSecondario : Colors.white.withOpacity(0.5), size: 30),
                          Icon(Icons.restaurant_menu_rounded, shadows: [Shadow(blurRadius: 120.0,color: Colors.black,offset: Offset(0, 0),),], color: widget.ricetta.difficolta!>4 ? colorsModel.coloreSecondario : Colors.white.withOpacity(0.5), size: 30),
                
                          Spacer(),
                          // tempo
                          Icon(Icons.timer_outlined, shadows: [Shadow(blurRadius: 120.0,color: Colors.black,offset: Offset(0, 0),),], color: widget.ricetta.minutiPreparazione>0 ? colorsModel.coloreSecondario : Colors.white.withOpacity(0.5), size: 30),
                          Icon(Icons.timer_outlined, shadows: [Shadow(blurRadius: 120.0,color: Colors.black,offset: Offset(0, 0),),], color: widget.ricetta.minutiPreparazione>14 ? colorsModel.coloreSecondario : Colors.white.withOpacity(0.5), size: 30),
                          Icon(Icons.timer_outlined, shadows: [Shadow(blurRadius: 120.0,color: Colors.black,offset: Offset(0, 0),),], color: widget.ricetta.minutiPreparazione>29 ? colorsModel.coloreSecondario : Colors.white.withOpacity(0.5), size: 30),
                          Icon(Icons.timer_outlined, shadows: [Shadow(blurRadius: 120.0,color: Colors.black,offset: Offset(0, 0),),], color: widget.ricetta.minutiPreparazione>59 ? colorsModel.coloreSecondario : Colors.white.withOpacity(0.5), size: 30),
                          Icon(Icons.timer_outlined, shadows: [Shadow(blurRadius: 120.0,color: Colors.black,offset: Offset(0, 0),),], color: widget.ricetta.minutiPreparazione>89 ? colorsModel.coloreSecondario : Colors.white.withOpacity(0.5), size: 30),
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
