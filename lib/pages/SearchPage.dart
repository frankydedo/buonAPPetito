import 'package:buonappetito/models/Categoria.dart';
import 'package:buonappetito/pages/RicettaPage.dart';
import 'package:buonappetito/utils/MyCategoriaDialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:buonappetito/models/Ricetta.dart';
import 'package:buonappetito/providers/ColorsProvider.dart';
import 'package:buonappetito/providers/DifficultyProvider.dart';
import 'package:buonappetito/providers/TimeProvider.dart';
import 'package:buonappetito/providers/RicetteProvider.dart';
import 'package:buonappetito/utils/MyDifficolta.dart';
import 'package:buonappetito/utils/MyTime.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  TextEditingController controller = TextEditingController();
  List<Ricetta> ListaRicette = [];
  List<Ricetta> ListaFiltrata = [];
  List<Ricetta> ListaInizialeFiltrata = [];
  List<String> activeFilters = [];

  Map<Categoria, bool> selezioneCategorie = {};
  List<String> categorieSelezionate =[];

  bool isButtonPressed1 = false;
  bool isButtonPressed2 = false;
  bool isButtonPressed3 = false;

  @override
  void initState() {
    super.initState();
    ListaRicette = Provider.of<RicetteProvider>(context, listen: false).ricette;
    applyInitialFiltering();
  }

  // Applica la ricerca iniziale quando il widget viene inizializzato
  void applyInitialFiltering() {
    searchAndFilterRecipes('');
  }

  Future<void> showCategoriesDialog() async {
    selezioneCategorie = (await showCategorieDialog(context))!;
    categorieSelezionate.clear();
    for(var entry in selezioneCategorie.entries){
      if(entry.value){
        categorieSelezionate.add(entry.key.nome);
      }
    }
    if(categorieSelezionate.isEmpty){
      setState(() {
        isButtonPressed1=false;
        if(activeFilters.contains('categories')){
          toggleFilter('categories');
        }
      });
    }else{
      setState(() {
        isButtonPressed1=true;
        if(!activeFilters.contains('categories')){
          toggleFilter('categories');
        }
      });
    }
    print(categorieSelezionate.length.toString());
    searchAndFilterRecipes(controller.text);
  }

  Future<Map<Categoria, bool>?> showCategorieDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => MyCategoriaDialog(selezioneCategorie: selezioneCategorie),
    );
  }


  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Consumer3<ColorsProvider, RicetteProvider, DifficultyProvider>(
      builder: (context, colorsModel, ricetteModel, difficultyModel, _) {
        //ListaRicette = ricetteModel.ricette; // Aggiorna ListaRicette da Provider
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
                  onChanged: (query) => searchAndFilterRecipes(query),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Primo pulsante (Categorie)
                    SizedBox(
                      width: screenWidth * 0.30,
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
                          elevation: isButtonPressed1 ? 3 : 0,
                          shadowColor: Colors.black,
                        ),
                        icon: Icon(Icons.checklist_rounded, size: 20),
                        label: FittedBox(
                          child: Text(
                            "Categ.",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                
                    // Secondo pulsante (Difficoltà)
                    SizedBox(
                      width: screenWidth * 0.30,
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
                          elevation: isButtonPressed2 ? 3 : 0,
                          shadowColor: Colors.black,
                        ),
                        icon: Icon(Icons.restaurant_menu_rounded, size: 20),
                        label: FittedBox(
                          //fit: BoxFit.scaleDown,
                          child: Text(
                            "Diffic.",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    Spacer(),
                
                    // Terzo pulsante (Tempo)
                    SizedBox(
                      width: screenWidth * 0.30,
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
                          elevation: isButtonPressed3 ? 3 : 0,
                          shadowColor: Colors.black,
                        ),
                        icon: Icon(Icons.schedule_rounded, size: 20),
                        label: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "Tempo",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              Expanded(
                child: ListView.builder(
                  itemCount: ListaFiltrata.length,
                  itemBuilder: (context, index) {
                    final recipeScroll = ListaFiltrata[index];
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){return RicettaPage(recipe: recipeScroll);})).then((_){
                          setState(() {
                            ListaRicette = Provider.of<RicetteProvider>(context, listen: false).ricette;
                            searchAndFilterRecipes(controller.text);
                          });
                        });
                      },
                      child: ListTile(
                        leading: Container(
                          width: 55,
                          height: 55,
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

  void searchAndFilterRecipes(String query) {

    setState(() {
      // Resetta la lista filtrata all'inizio della ricerca
      ListaFiltrata = List.from(ListaRicette);

      if (query.isNotEmpty) {
        ListaFiltrata = ListaFiltrata.where((ricetta) {
          final recipeName = ricetta.titolo.toLowerCase();
          final recipeIngredients = ricetta.ingredienti.keys.map((key) => key.toLowerCase()).join(' ');
          final input = query.toLowerCase();

          return recipeName.contains(input) || recipeIngredients.contains(input);
        }).toList();
      }

      // Applica i filtri attivi sulla lista filtrata
      for (String filter in activeFilters) {
        switch (filter) {
          case 'difficulty':
            ListaFiltrata = applyDifficultyFilter();
            break;
          case 'time':
            ListaFiltrata = applyTimeFilter();
            break;
          case 'categories':
            ListaFiltrata = applyCategoriesFilter();
        }
      }
    });
  }

  void showDifficultyDialog(BuildContext context, DifficultyProvider difficultyProvider) {
    showDialog(
      context: context,
      builder: (context) {
        return MyDifficolta(
          onSelectionChanged: (selectedDifficultyIndex) {
            difficultyProvider.setSelectedDifficultyIndex(selectedDifficultyIndex);
            setState(() {
              if(selectedDifficultyIndex == -1)
              {
               toggleFilter('difficulty');
              }
              else
              {
                activeFilters.add('difficulty');
                searchAndFilterRecipes(controller.text);
              }
            isButtonPressed2 = selectedDifficultyIndex != -1;
            });
          },
          selectedDifficultyIndex: difficultyProvider.selectedDifficultyIndex,
        );
      },
    );
  }

  void showTimeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return MyTime(
          onSelectionChanged: (selectedTimeIndex) {
            Timeprovider timeProvider = Provider.of<Timeprovider>(context, listen: false);
            timeProvider.setSelectedTimeIndex(selectedTimeIndex);
            setState(() {   
              if(selectedTimeIndex == -1)
              {
               toggleFilter('time');
              }
              else
              {
                activeFilters.add('time');
                searchAndFilterRecipes(controller.text);
              }
            isButtonPressed3 = selectedTimeIndex != -1;
            });
          },
          selectedTimeIndex: Provider.of<Timeprovider>(context, listen: false).selectedTimeIndex,
        );
      },
    );
  }

List<Ricetta> applyDifficultyFilter() {
  DifficultyProvider difficultyProvider = Provider.of<DifficultyProvider>(context, listen: false);
  int selectedDifficultyIndex = difficultyProvider.selectedDifficultyIndex;
  List<Ricetta> filteredRecipes = List.from(ListaFiltrata); // Creare una copia della lista filtrata

  if (selectedDifficultyIndex != -1) {
    String selectedDifficulty = difficultyProvider.allDifficulties[selectedDifficultyIndex];
    int selectedDifficultyLevel = difficultyProvider.difficultyLevels[selectedDifficulty] ?? 0;

    filteredRecipes = filteredRecipes.where((ricetta) => ricetta.difficolta! <= selectedDifficultyLevel).toList();
  }

  return filteredRecipes;
}

  // metodi per il filtraggio delle ricette in base alle categorie

  List<Ricetta> applyCategoriesFilter() {
    return ListaFiltrata.where(categoriaDaMostrare).toList();
  }

  bool categoriaDaMostrare(Ricetta r) {
    return r.categorie.any((nomeCat) => categorieSelezionate.contains(nomeCat));
  }



  List<Ricetta> applyTimeFilter() {
    Timeprovider timeProvider = Provider.of<Timeprovider>(context, listen: false);
    int selectedTimeIndex = timeProvider.selectedTimeIndex;
    List<Ricetta> filteredRecipes = ListaFiltrata;

    if (selectedTimeIndex != -1) {
      String selectedTime = timeProvider.allDifficulties[selectedTimeIndex];

      switch (selectedTime) {
        case "< 15":
          filteredRecipes = filteredRecipes.where((ricetta) => ricetta.minutiPreparazione < 15).toList();
          break;
        case "< 30":
          filteredRecipes = filteredRecipes.where((ricetta) => ricetta.minutiPreparazione < 30).toList();
          break;
        case "< 60":
          filteredRecipes = filteredRecipes.where((ricetta) => ricetta.minutiPreparazione < 60).toList();
          break;
        case "< 90":
          filteredRecipes = filteredRecipes.where((ricetta) => ricetta.minutiPreparazione < 90).toList();
          break;
        case "> 90":
          filteredRecipes = filteredRecipes.where((ricetta) => ricetta.minutiPreparazione > 0).toList();
          break;
      }
    }

    return filteredRecipes;
  }

  void toggleFilter(String filter) {
    if (activeFilters.contains(filter)) {
      activeFilters.remove(filter);
    } else {
      activeFilters.add(filter);
    }
    print(activeFilters.toList().toString());
    searchAndFilterRecipes(controller.text); // ricerca con i filtri aggiornati
  }
}
