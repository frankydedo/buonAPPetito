// ignore_for_file: must_be_immutable

import 'package:auto_size_text/auto_size_text.dart';
import 'package:buonappetito/models/Ricetta.dart';
import 'package:buonappetito/providers/ColorsProvider.dart';
import 'package:buonappetito/providers/RicetteProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AggiuntiDiRecenteTile extends StatefulWidget {

  Ricetta ricetta;
  
  AggiuntiDiRecenteTile({super.key, required this.ricetta});

  @override
  State<AggiuntiDiRecenteTile> createState() => _AggiuntiDiRecenteTileState();
}

class _AggiuntiDiRecenteTileState extends State<AggiuntiDiRecenteTile> {
  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Consumer2<ColorsProvider, RicetteProvider>(
      builder: (context, colorsModel, ricetteModel, _) {
      return Container(
        width: 250,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.1),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 3),
            )
          ]
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      widget.ricetta.percorsoImmagine,
                      height: 170,
                      width: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    left: 208,
                    child: GestureDetector(
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
                        Icon(Icons.favorite_rounded, size: 30, color: Colors.white, shadows: [Shadow(blurRadius: 180.0,color: Colors.black,offset: Offset(0, 0))])
                        :
                        Icon(Icons.favorite_border_rounded, size: 30, color: Colors.white, shadows: [Shadow(blurRadius: 90.0,color: Colors.black,offset: Offset(0, 0))])
                      ),
                    ),
                  )
                ]
              ),

              //imposto il testo in maniera tale che vada a coprire alpiù due righi
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: AutoSizeText(
                  widget.ricetta.titolo,
                  style: GoogleFonts.encodeSans(
                    color: colorsModel.getColoreTitoli(context),
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 2,
                  minFontSize: 16, 
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10,0,10,0),
                child: AutoSizeText(
                  widget.ricetta.getCategorie(),
                  style: GoogleFonts.encodeSans(
                    color: colorsModel.getColoreTitoli(context),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  minFontSize: 16, 
                  overflow: TextOverflow.ellipsis,
                ),
              ),              
              Spacer(),

              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // diccifoltà
                          Icon(Icons.restaurant_menu_rounded, color: widget.ricetta.difficolta!>0 ? colorsModel.coloreSecondario : Colors.grey.withOpacity(0.35), size: 25),
                          Icon(Icons.restaurant_menu_rounded, color: widget.ricetta.difficolta!>1 ? colorsModel.coloreSecondario : Colors.grey.withOpacity(0.35), size: 25),
                          Icon(Icons.restaurant_menu_rounded, color: widget.ricetta.difficolta!>2 ? colorsModel.coloreSecondario : Colors.grey.withOpacity(0.35), size: 25),
                          Icon(Icons.restaurant_menu_rounded, color: widget.ricetta.difficolta!>3 ? colorsModel.coloreSecondario : Colors.grey.withOpacity(0.35), size: 25),
                          Icon(Icons.restaurant_menu_rounded, color: widget.ricetta.difficolta!>4 ? colorsModel.coloreSecondario : Colors.grey.withOpacity(0.35), size: 25),
                        ],
                      ),
                    ),
                
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // tempo
                        Icon(Icons.timer_outlined, color: widget.ricetta.minutiPreparazione>0 ? colorsModel.coloreSecondario : Colors.grey.withOpacity(0.35), size: 25),
                        Icon(Icons.timer_outlined, color: widget.ricetta.minutiPreparazione>14 ? colorsModel.coloreSecondario : Colors.grey.withOpacity(0.35), size: 25),
                        Icon(Icons.timer_outlined, color: widget.ricetta.minutiPreparazione>29 ? colorsModel.coloreSecondario : Colors.grey.withOpacity(0.35), size: 25),
                        Icon(Icons.timer_outlined, color: widget.ricetta.minutiPreparazione>59 ? colorsModel.coloreSecondario : Colors.grey.withOpacity(0.35), size: 25),
                        Icon(Icons.timer_outlined, color: widget.ricetta.minutiPreparazione>89 ? colorsModel.coloreSecondario : Colors.grey.withOpacity(0.35), size: 25),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
      });
  }
}