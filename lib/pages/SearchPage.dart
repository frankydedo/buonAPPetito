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
  List<Ricetta> ListaRicette = []; 
  List<Ricetta> RicetteAttuali = [];
  
  List <Ricetta> ListaFiltrata = [];
  List<String> activeFilters = [];

  bool isButtonPressed1 = false;
  bool isButtonPressed2 = false;
  bool isButtonPressed3 = false;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Consumer3<ColorsProvider, RicetteProvider, DifficultyProvider>(
      builder: (context, colorsModel, ricetteModel, difficultyModel, _) {
        ListaRicette = ricetteModel.ricette; // Inizializzazione di ListaRicette 
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
                      label: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "Categorie",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
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
                      label: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "Difficoltà",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
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
                      label: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "Tempo",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: ListaFiltrata.length,
                  itemBuilder: (context, index) {
                    final recipeScroll = ListaFiltrata[index];
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
    ListaFiltrata = ListaFiltrata.where((Ricetta ricetta) {
      final recipeName = ricetta.titolo.toLowerCase();
      final recipeIngredients =
          ricetta.ingredienti.keys.map((key) => key.toLowerCase()).join(' ');
      final input = query.toLowerCase();

      return recipeName.contains(input) || recipeIngredients.contains(input);
    }).toList();

    setState(() {});
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
  showDialog(
    context: context,
    builder: (context) {
      return MyDifficolta(
        onSelectionChanged: (selectedDifficultyIndex) {
          difficultyProvider.setSelectedDifficultyIndex(selectedDifficultyIndex);
          setState(() {
            isButtonPressed2 = selectedDifficultyIndex != -1;
            toggleFilter('difficulty');
          });
        },
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
            isButtonPressed3 = selectedTimeIndex != -1;
            toggleFilter('time');
            });
            // Aggiorna il filtro per il tempo
            // Esegui un nuovo filtro basato sullo stato aggiornato di isButtonPressed3
          },
        );
      },
    );
  }
  
List <Ricetta> applyDifficultyFilter() {

  // Ottenere le istanze dei provider
  DifficultyProvider difficultyProvider = Provider.of<DifficultyProvider>(context, listen: false);
  
  // Ottenere la difficoltà selezionata, se presente
  int selectedDifficultyIndex = difficultyProvider.selectedDifficultyIndex;

  // Filtrare per difficoltà, se selezionata
  if (selectedDifficultyIndex != -1) {
    String selectedDifficulty = difficultyProvider.allDifficulties[selectedDifficultyIndex];
    int selectedDifficultyLevel = difficultyProvider.difficultyLevels[selectedDifficulty] ?? 0;

    // Filtrare le ricette in base alla difficoltà selezionata
    switch(selectedDifficultyLevel)
    {
      case 1:
       ListaFiltrata = ListaFiltrata.where((ricetta) => ricetta.difficolta! <= 1).toList();
       break;
      case 2:
       ListaFiltrata = ListaFiltrata.where((ricetta) => ricetta.difficolta! <= 2).toList();
       break;
      case 3:
       ListaFiltrata = ListaFiltrata.where((ricetta) => ricetta.difficolta! <= 3).toList();
       break;
      case 4:
       ListaFiltrata = ListaFiltrata.where((ricetta) => ricetta.difficolta! <= 4).toList();
       break;
      case 5:
       ListaFiltrata = ListaFiltrata.where((ricetta) => ricetta.difficolta! <= 5).toList();
       break;
      default :
      ListaFiltrata = ListaFiltrata.where((ricetta) => ricetta.difficolta! > 0).toList();
      
    }
  }
  return ListaFiltrata;

}

List<Ricetta> applyTimeFilter() {
  Timeprovider timeProvider = Provider.of<Timeprovider>(context, listen: false);
  int selectedTimeIndex = timeProvider.selectedTimeIndex;
  List<Ricetta> filteredTime = ListaFiltrata;

  if (selectedTimeIndex != -1) {
    String selectedTime = timeProvider.allDifficulties[selectedTimeIndex];

    // Applicare il filtro basato sull'intervallo di tempo selezionato
    switch (selectedTime) {
      case "< 15":
        filteredTime = filteredTime.where((ricetta) => ricetta.minutiPreparazione < 15).toList();
        break;
      case "< 30":
        filteredTime = filteredTime.where((ricetta) => ricetta.minutiPreparazione < 30).toList();
        break;
      case "< 60":
        filteredTime = filteredTime.where((ricetta) => ricetta.minutiPreparazione < 60).toList();
        break;
      case "< 90":
        filteredTime = filteredTime.where((ricetta) => ricetta.minutiPreparazione < 90).toList();
        break;
      case "> 90":
        filteredTime = filteredTime.where((ricetta) => ricetta.minutiPreparazione > 0).toList();
        break;
      default:
        break;
    }
  }

  return filteredTime; // Assicura che la funzione restituisca sempre un valore
}

// Funzione per applicare i filtri attivi
  void applyActiveFilters() {
    // Copia la lista filtrata iniziale
    ListaFiltrata = List.from(ListaRicette);

    // Applica ogni filtro attivo
    for (String filter in activeFilters) {
      switch (filter) {
        case 'categories':
          // Esempio di applicazione del filtro per categorie
          //ListaFiltrata = applyCategoriesFilter();
          break;
        case 'difficulty':
          // Esempio di applicazione del filtro per difficoltà
          ListaFiltrata = applyDifficultyFilter();
          break;
        case 'time':
          // Esempio di applicazione del filtro per tempo
          ListaFiltrata = applyTimeFilter();
          break;
        // Aggiungi altri casi per ulteriori tipi di filtri
      }
    }

    setState(() {});
  }

// Funzione per attivare o disattivare un filtro
  void toggleFilter(String filter) {
    if (activeFilters.contains(filter)) {
      activeFilters.remove(filter); // Rimuovi il filtro se è attivo
    } else {
      activeFilters.add(filter); // Aggiungi il filtro se non è attivo
    }

    applyActiveFilters(); // Rapplica i filtri attivi
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
