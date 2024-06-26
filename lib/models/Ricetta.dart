class Ricetta {
  String percorsoImmagine;
  String titolo;
  String descrizione;
  Map<String, String> ingredienti; // si tiene traccia del nome dell'ingrediente e della quantità
  List<String> categorie;
  List<String> passaggi;
  int? difficolta;
  int minutiPreparazione;
  DateTime dataAggiunta;
  bool isFavourite = false;

  Ricetta({
    required this.percorsoImmagine,
    required this.categorie,
    required this.descrizione,
    required this.ingredienti,
    required this.passaggi,
    required this.titolo,
    required this.minutiPreparazione,
    required this.difficolta,
    required this.dataAggiunta,
  });

  String getCategorie() {
    String c = "";
    for (String cat in categorie) {
      c += " " + cat;
    }
    return c;
  }

  void setPreferita() {
    isFavourite = true;
  }

  void resetPreferita() {
    isFavourite = false;
  }

  void setTitolo(String titoloNuovo) {
    this.titolo = titoloNuovo;
  }

  void setDescrizione(String descrizioneNuova) {
    this.descrizione = descrizioneNuova;
  }

  void aggiungiIngrediente(String ingrediente, String dose) {
    ingredienti.addAll({ingrediente: dose});
  }

  void rimuoviIngrediente(String ingrediente) {
    ingredienti.remove(ingrediente);
  }

  void aggiungiPassaggio(String passaggio) {
    passaggi.add(passaggio);
  }

  void rimuoviPassaggio(String passaggio) {
    passaggi.remove(passaggio);
  }

  void setDifficolta(int difficoltaNuova) {
    difficolta = difficoltaNuova;
  }

  void setMinutiPreparazione(int minuti) {
    minutiPreparazione = minuti;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Ricetta &&
        _compareMaps(ingredienti, other.ingredienti) &&
        _compareLists(passaggi, other.passaggi);
  }

  @override
  int get hashCode => ingredienti.hashCode ^ passaggi.hashCode;

  bool _compareMaps(Map<String, String> map1, Map<String, String> map2) {
    if (map1.length != map2.length) return false;
    for (String key in map1.keys) {
      if (!map2.containsKey(key) || map1[key] != map2[key]) {
        return false;
      }
    }
    return true;
  }

  bool _compareLists(List<String> list1, List<String> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }
}
