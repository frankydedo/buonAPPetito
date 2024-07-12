import 'package:buonappetito/models/Categoria.dart';
import 'package:buonappetito/pages/RicettaPage.dart';
import 'package:buonappetito/utils/MyCategoriaDialog.dart';
import 'package:buonappetito/utils/RicettaTileOrizzontale.dart';
import 'package:flutter/material.dart';
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
    searchAndFilterRecipes(controller.text);
  }

  Future<Map<Categoria, bool>?> showCategorieDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => MyCategoriaDialog(selezioneCategorie: selezioneCategorie, canAddNewCategory: false),
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
          backgroundColor: colorsModel.backgroudColor,
          body: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: TextField(
                  controller: controller,
                  cursorColor: colorsModel.coloreSecondario,
                  style: TextStyle(
                    color: colorsModel.textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                    hintText: 'Cerca una ricetta...',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: colorsModel.coloreSecondario, width: 2.0),
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
                      height: 50,
                      width: screenWidth * 0.30,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          showCategoriesDialog();
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: isButtonPressed1
                              ? colorsModel.coloreSecondario
                              : colorsModel.coloreSecondario.withOpacity(.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
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
                      height: 50,
                      width: screenWidth * 0.30,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          showDifficultyDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: isButtonPressed2
                              ? colorsModel.coloreSecondario
                              : colorsModel.coloreSecondario.withOpacity(.4),
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
                      height: 50,
                      width: screenWidth * 0.30,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          showTimeDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: isButtonPressed3
                              ? colorsModel.coloreSecondario
                              : colorsModel.coloreSecondario.withOpacity(.4),
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
                    return GestureDetector(
                      onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context){return RicettaPage(recipe: ListaFiltrata[index]);})).then((_){
                          setState(() {
                            ListaRicette = ricetteModel.ricette;
                            searchAndFilterRecipes(controller.text);
                          });
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RicettaTileOrizzontale(ricetta: ListaFiltrata[index]),
                      )
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

Future<void> showDifficultyDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (context) {
      return MyDifficolta(
        onSelectionChanged: (selectedDifficultyIndices) {
          DifficultyProvider difficultyProvider = Provider.of<DifficultyProvider>(context, listen: false);
          difficultyProvider.resetSelection();
          selectedDifficultyIndices.forEach((index) {
            difficultyProvider.toggleDifficultyIndex(index);
          });

          if (difficultyProvider.hasSelection) {
            if(!activeFilters.contains('difficulty'))
            {
              activeFilters.add('difficulty');
            }
          } else {
            activeFilters.remove('difficulty');
          }
          isButtonPressed2 = difficultyProvider.hasSelection;

          setState(() {
            // Aggiorna il pulsante di difficoltà
            isButtonPressed2 = difficultyProvider.hasSelection;

            // Richiama la funzione di filtro e ricerca
            searchAndFilterRecipes(controller.text);
          });
        },
        selectedDifficultyIndices: Provider.of<DifficultyProvider>(context, listen: false).selectedDifficultyIndices,
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
  List<int> selectedDifficulties = difficultyProvider.selectedDifficultyIndices;
  List<Ricetta> filteredRecipes = [];

  // Filtra le ricette in base alle difficoltà selezionate
  filteredRecipes = ListaFiltrata.where((ricetta) {
    // Verifica se la ricetta è compatibile con almeno una delle difficoltà selezionate
    return selectedDifficulties.contains(ricetta.difficolta);
  }).toList();

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
        case "oltre":
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
    searchAndFilterRecipes(controller.text); // ricerca con i filtri aggiornati
  }
}
