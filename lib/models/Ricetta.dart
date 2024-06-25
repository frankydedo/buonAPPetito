//import 'dart:math';

class Ricetta{

  String percorsoImmagine;
  String titolo;
  String descrizione;
  Map<String, String> ingredienti;    //si tiene traccia del nome dell'ingrediente e della quantità
  List <String> categorie;
  List<String> passaggi;
  int ?difficolta;
  int minutiPreparazione;
  DateTime dataAggiunta;


  Ricetta({
    required this.percorsoImmagine,
    required this.categorie,
    required this.descrizione,
    required this.ingredienti,
    required this.passaggi,
    required this.titolo,
    required this.minutiPreparazione,
    this.difficolta,
    required this.dataAggiunta
  });

  /*String getCategorie(){
    String c="";
    for(String cat in categorie){
      c+=" "+cat;
    }
    return c;
  }*/

  String getCategorie() {
    String c = "";
    for (int i = 0; i < categorie.length; i++) {
      if (i == 0) {
        c += categorie[i]; 
      }  else {
        c += ' | ' + categorie[i];
      }
    }
    return c;
  }

  void setTitolo(String titoloNuovo){
    this.titolo = titoloNuovo;
  }

  void setDescrizione(String descrizioneNuova){
    this.descrizione = descrizioneNuova;
  }

  void aggiungiIngrediente(String ingrediente, String dose){
    ingredienti.addAll({ingrediente: dose});
  }

  void rimuoviIngrediente(String ingrediente){
    ingredienti.remove(ingrediente);
  }

  void aggiungiPassaggio(String passaggio){
    passaggi.add(passaggio);
  }

  void rimuoviPassaggio(String passaggio){
    passaggi.remove(passaggio);
  }

  void setDifficolta(int difficoltaNuova){
    difficolta = difficoltaNuova;
  }

  void setMinutiPreparazione(int minuti){
    minutiPreparazione = minuti;
  } 

  void generaDifficoltaInAutomatico() {
    int diffIngredienti;
    if (ingredienti.length <= 4) {
      diffIngredienti = 1;
    } else if (ingredienti.length <=6) {
      diffIngredienti = 2;
    } else if (ingredienti.length <= 8) {
      diffIngredienti = 3;
    } else if (ingredienti.length <= 10) {
      diffIngredienti = 4;
    } else {
      diffIngredienti = 5;
    }

    int diffTempo;
    if (minutiPreparazione <= 15) {
      diffTempo = 1;
    } else if (minutiPreparazione <= 30) {
      diffTempo = 2;
    } else if (minutiPreparazione <= 60) {
      diffTempo = 3;
    } else if (minutiPreparazione <= 90) {
      diffTempo = 4;
    } else {
      diffTempo = 5;
    }

    this.difficolta = ((diffIngredienti + diffTempo) / 2) as int?;
  }

}