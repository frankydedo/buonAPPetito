// ignore_for_file: unused_import, unnecessary_import, unused_local_variable

import 'package:buonappetito/models/MyDialog.dart';
import 'package:buonappetito/models/MyDifficolta.dart';
import 'package:buonappetito/models/MyTime.dart';
import 'package:buonappetito/models/Ricetta.dart';
import 'package:buonappetito/providers/ColorsProvider.dart';
import 'package:buonappetito/providers/DifficultyProvider.dart';
import 'package:buonappetito/providers/TimeProvider.dart';
import 'package:buonappetito/providers/RicetteProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  
  TextEditingController controller = TextEditingController();
  List<Ricetta> ListaRicette = []; // Dichiarazione di ListaRicette come variabile di istanza
  List<Ricetta> RicetteAttuali = [];

  bool isButtonPressed1 = false;
  bool isButtonPressed2 = false;
  bool isButtonPressed3 = false;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Consumer3<ColorsProvider, RicetteProvider, DifficultyProvider>(
      builder: (context, colorsModel, ricetteModel, difficultyModel, _) {
        ListaRicette = ricetteModel.ricette; // Inizializzazione di ListaRicette qui
        return Scaffold(
          body: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Cerca una ricetta...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: colorsModel.getColoreSecondario(), width: 2.0),
                    ),
                  ),
                  onChanged: (query) => searchRecipe(query, ricetteModel),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //first button
                  SizedBox(
                    width: screenWidth * 0.3,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        showCategoriesDialog();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: isButtonPressed1
                            ? colorsModel.getColoreSecondario()
                            : colorsModel.getColoreSecondario().withOpacity(.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        elevation: isButtonPressed1 ? 5 : 0,
                        shadowColor: Colors.black,
                      ),
                      icon: Icon(Icons.checklist_rounded, size: 15),
                      label: Text(
                        "Categorie",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  //second button
                  SizedBox(
                    width: screenWidth * 0.3,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        showDifficultyDialog(context, difficultyModel);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: isButtonPressed2
                            ? colorsModel.getColoreSecondario()
                            : colorsModel.getColoreSecondario().withOpacity(.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        elevation: isButtonPressed2 ? 5 : 0,
                        shadowColor: Colors.black,
                      ),
                      icon: Icon(Icons.restaurant_menu_rounded, size: 15),
                      label: Text(
                        "difficoltà",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  //third button
                  SizedBox(
                    width: screenWidth * 0.25,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        showTimeDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: isButtonPressed3
                            ? colorsModel.getColoreSecondario()
                            : colorsModel.getColoreSecondario().withOpacity(.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        elevation: isButtonPressed3 ? 5 : 0,
                        shadowColor: Colors.black,
                      ),
                      icon: Icon(Icons.schedule_rounded, size: 15),
                      label: Text(
                        "tempo",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: RicetteAttuali.length,
                  itemBuilder: (context, index) {
                    final recipeScroll = RicetteAttuali[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlaceholderPage(),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: colorsModel.getColoreSecondario(),
                              width: 1.5,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Image.asset(
                              recipeScroll.percorsoImmagine,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text(
                          recipeScroll.titolo,
                          style: GoogleFonts.encodeSans(
                              textStyle: TextStyle(
                                  color: const Color.fromARGB(255, 16, 0, 0),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800)),
                        ),
                        subtitle: Text(
                          recipeScroll.getCategorie(),
                          style: GoogleFonts.encodeSans(
                              textStyle: TextStyle(
                                  color: Color.fromARGB(255, 9, 0, 0),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400)),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void searchRecipe(String query, RicetteProvider ricetteProvider) {
    final suggested = ListaRicette.where((Ricetta ricetta) {
      final recipeName = ricetta.titolo.toLowerCase();
      final recipeIngredients =
          ricetta.ingredienti.keys.map((key) => key.toLowerCase()).join(' ');
      final input = query.toLowerCase();

      return recipeName.contains(input) || recipeIngredients.contains(input);
    }).toList();

    setState(() => RicetteAttuali = suggested);
  }

  void showCategoriesDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return MyDialog(
          onSelectionChanged: (isSelected) {
            setState(() {
              isButtonPressed1 = isSelected;
            });
          },
        );
      },
    );
  }

  void showDifficultyDialog(BuildContext context, DifficultyProvider difficultyProvider) {
   setState(() {
      showDialog(
        context: context, 
        builder: (context){
          return MyDifficolta(
            onSelectionChanged: (isSelected) {
              setState(()
              {
                isButtonPressed2 = isSelected;
              });
            }
          );
        }
      );
    });
  }

  void showTimeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return MyTime(
          onSelectionChanged: (isSelected) {
            setState(() {
              isButtonPressed3 = isSelected;
            });
            // Aggiorna il filtro per il tempo
            // Esegui un nuovo filtro basato sullo stato aggiornato di isButtonPressed3
          },
        );
      },
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Placeholder Page'),
      ),
      body: Center(
        child: Text('This is a placeholder page.'),
      ),
    );
  }
}
