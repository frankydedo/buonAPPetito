import 'package:buonappetito/pages/NuovaRicettaPageCompleta.dart';
import 'package:buonappetito/providers/ColorsProvider.dart';
import 'package:buonappetito/providers/RicetteProvider.dart';
import 'package:buonappetito/utils/ConfermaDialog.dart';
import 'package:flutter/material.dart';
import 'package:buonappetito/models/Ricetta.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RicettaPage extends StatefulWidget {
  final Ricetta recipe;

  RicettaPage({required this.recipe});

  @override
  _RicettaPageState createState() => _RicettaPageState();
}

class _RicettaPageState extends State<RicettaPage> {

  String ingredientButtonText = "Aggiungi tutti";

  Future showConfermaDialog(BuildContext context, String domanda) {
    return showDialog(
      context: context,
      builder: (context) => ConfermaDialog(domanda: domanda,),
    );
  }

  @override
  void initState()
  {
    super.initState();
    if(!controlloCarrello())
    {
      ingredientButtonText = "Aggiungi tutti";
    }
    else
    {
      ingredientButtonText = "Rimuovi tutti";
    }
  }

  bool controlloCarrello()
  {
    List <String> carrello = Provider.of<RicetteProvider>(context, listen: false).carrello;
    for (String ingrediente in widget.recipe.ingredienti.keys)
    {
      if(!carrello.contains(ingrediente))
      {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Consumer2<ColorsProvider, RicetteProvider>(
      builder: (context, colorsModel, ricetteModel, _) {
        return Scaffold(
          backgroundColor: colorsModel.backgroudColor,
          appBar: AppBar(
            backgroundColor: colorsModel.backgroudColor,
            iconTheme: IconThemeData(
              color: colorsModel.coloreSecondario,
              size: 28.0,
            ),
            title: Row(
              children: [
                Spacer(),

                //tasto cancella
                IconButton(
                onPressed: () async{                
                  bool cancellare = await showConfermaDialog(context, "Sei sicuro di canellare la ricetta definitivamente?") as bool;
                    if (cancellare){
                      Navigator.pop(context);
                      ricetteModel.rimuoviRicetta(widget.recipe);
                      ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Ricetta cancellata correttamente", style: TextStyle(color: Colors.white, fontSize: 18),), backgroundColor: Color.fromRGBO(26, 35, 126, 1)),
                      );
                    }

                  },
                  icon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:Icon(Icons.delete_outline_rounded, size: 35, color: colorsModel.coloreSecondario),
                  ),
                ),
                //tasto modifica ricetta
                IconButton(
                onPressed: () async{                
                    Navigator.push(context,MaterialPageRoute(builder: (context) =>NuovaRicettaPageCompleta(recipe: widget.recipe,))).then((_){
                      setState(() {
                        
                      });
                    });

                }, 
                icon: Icon(Icons.edit_rounded, size: 35, color: colorsModel.coloreSecondario),
                ),
                // tasto rimuovi dai preferiti
                IconButton(
                onPressed: () async{                
                  if(widget.recipe.isFavourite){
                    ricetteModel.rimuoviDaiPreferiti(widget.recipe);
                    ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Ricetta rimossa dai preferiti", style: TextStyle(color: Colors.white, fontSize: 18),), backgroundColor: Color.fromRGBO(26, 35, 126, 1)),
                    );
                  } else {
                      ricetteModel.aggiungiAiPreferiti(widget.recipe);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Ricetta aggiunta ai preferiti", style: TextStyle(color: Colors.white, fontSize: 18),), backgroundColor: Color.fromRGBO(26, 35, 126, 1)),
                      );
                    }

                  },
                  icon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: widget.recipe.isFavourite ?  Icon(Icons.favorite_rounded, size: 35, color: colorsModel.coloreSecondario) : Icon(Icons.favorite_border_rounded, size: 35, color: colorsModel.coloreSecondario),
                  ),
                )
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              color: colorsModel.backgroudColor,
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        widget.recipe.percorsoImmagine,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 300,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.recipe.getCategorie().toUpperCase(),
                      style: GoogleFonts.encodeSans(
                        color: Colors.grey.shade600,
                        fontSize: 22,
                        fontWeight: FontWeight.w400
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.recipe.titolo,
                      style: GoogleFonts.encodeSans(
                        color: colorsModel.coloreTitoli,
                        fontSize: 40,
                        fontWeight: FontWeight.w800
                      )
                    ),
                  ),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: screenWidth * 0.8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Difficoltà
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Icon(Icons.restaurant_menu_rounded, color: colorsModel.coloreSecondario, size: 30,),
                                  SizedBox(width: 8),
                                  Text(
                                    "Difficoltà: ",
                                    style: GoogleFonts.encodeSans(
                                      color: colorsModel.textColor,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w400
                                    ),
                                  ),
                                  Text(
                                    widget.recipe.getDifficoltaAsString() + " ",
                                    style: GoogleFonts.encodeSans(
                                      color: colorsModel.textColor,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700
                                    ),
                                  )
                                ],
                              ),
                            ),
                            // Tempo di preparazione
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Icon(Icons.timer_outlined, color: colorsModel.coloreSecondario, size: 30,),
                                  SizedBox(width: 8),
                                  Text(
                                    "Preparazione: ",
                                    style: GoogleFonts.encodeSans(
                                      color: colorsModel.textColor,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w400
                                    ),
                                  ),
                                  Text(
                                    widget.recipe.minutiPreparazione.toString() + " min",
                                    style: GoogleFonts.encodeSans(
                                      color: colorsModel.textColor,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // descrizione

                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: screenWidth,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(
                                    "DESCRIZIONE",
                                    style: GoogleFonts.encodeSans(
                                      color: colorsModel.coloreTitoli,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700
                                    ),
                                  ),
                                  Spacer(),
                                ],
                              ),
                            ),
                          ),
                          Text(
                            widget.recipe.descrizione,
                            style: GoogleFonts.encodeSans(
                              color: colorsModel.textColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w400
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  //ingredienti

                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: screenWidth,
                      decoration: BoxDecoration(
                        color: colorsModel.isLightMode ?  Colors.grey.shade200 : Colors.grey.shade300,
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(
                                    "INGREDIENTI",
                                    style: GoogleFonts.encodeSans(
                                      color: colorsModel.isLightMode ? colorsModel.coloreTitoli : Colors.grey.shade700,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700
                                    ),
                                  ),
                                  Spacer(),

                                  // tasto aggiungi tutti

                                  GestureDetector(
                                    onTap: (){
                                      if(ingredientButtonText == "Aggiungi tutti"){
                                        for (String ingrediente in widget.recipe.ingredienti.keys){
                                          if (!ricetteModel.carrello.contains(ingrediente)){
                                            ricetteModel.aggiungiIngredienteAlCarrello(ingrediente);
                                          }
                                        }
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text("Tutti gli ingredienti sono stati aggiunti al carrello", style: TextStyle(color: Colors.white, fontSize: 18),), backgroundColor: Color.fromRGBO(26, 35, 126, 1)),
                                        );
                                        setState(() {
                                          ingredientButtonText = "Rimuovi tutti";
                                        });
                                      }else{
                                        for(String ingrediente in widget.recipe.ingredienti.keys){
                                          if (ricetteModel.carrello.contains(ingrediente)){
                                            ricetteModel.rimuoviIngredienteDalCarrello(ingrediente);
                                          }
                                        }
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text("Tutti gli ingredienti sono stati rimossi dal carrello", style: TextStyle(color: Colors.white, fontSize: 18),), backgroundColor: Color.fromRGBO(26, 35, 126, 1)),
                                        );
                                        setState(() {
                                          ingredientButtonText = "Aggiungi tutti";
                                        });
                                      }
                                    },
                                    child: Text(
                                      ingredientButtonText,
                                      style: GoogleFonts.encodeSans(
                                        color: colorsModel.coloreSecondario,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: widget.recipe.ingredienti.length,
                              itemBuilder: (context, index) {
                                Map<String, String> ingredienti = widget.recipe.ingredienti;
                                return Row(
                                  children: [
                                    Expanded(
                                      child: ListTile(
                                        title: Text(
                                          ingredienti.keys.elementAt(index),
                                          style: GoogleFonts.encodeSans(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w600
                                          ),
                                        ),
                                        subtitle: Text(
                                          ingredienti.values.elementAt(index),
                                          style: GoogleFonts.encodeSans(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400
                                          ),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: (){
                                        if(ricetteModel.carrello.contains(ingredienti.keys.elementAt(index))){
                                          ricetteModel.rimuoviIngredienteDalCarrello(ingredienti.keys.elementAt(index));
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text("L'ingrediente è stato rimosso dal carrello", style: TextStyle(color: Colors.white, fontSize: 18),), backgroundColor: Color.fromRGBO(26, 35, 126, 1)),
                                          );
                                        }else{
                                          ricetteModel.aggiungiIngredienteAlCarrello(ingredienti.keys.elementAt(index));
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text("L'ingrediente è stato aggiunto al carrello", style: TextStyle(color: Colors.white, fontSize: 18),), backgroundColor: Color.fromRGBO(26, 35, 126, 1)),
                                          );
                                        }
                                      }, 
                                      icon: !ricetteModel.carrello.contains(ingredienti.keys.elementAt(index)) ?
                                        Icon(Icons.add_shopping_cart_rounded, color: colorsModel.coloreSecondario, size: 35)
                                        :
                                        Icon(Icons.remove_shopping_cart_rounded, color: colorsModel.coloreSecondario, size: 35)
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  //passaggi

                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: screenWidth,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(
                                    "PREPARAZIONE",
                                    style: GoogleFonts.encodeSans(
                                      color: colorsModel.coloreTitoli,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700
                                    ),
                                  ),
                                  Spacer(),
                                ],
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: widget.recipe.passaggi.length,
                              itemBuilder: (context, index) {
                                List<String> step = widget.recipe.passaggi;
                                return ListTile(
                                  title: Text(
                                    "STEP "+ (index+1).toString(),
                                    style: GoogleFonts.encodeSans(
                                      color: colorsModel.textColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600
                                    ),
                                  ),
                                  subtitle: Text(
                                    step.elementAt(index),
                                    style: GoogleFonts.encodeSans(
                                      color: colorsModel.textColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
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
