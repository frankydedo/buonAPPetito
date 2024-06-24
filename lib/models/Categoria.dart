import 'package:buonappetito/models/Ricetta.dart';

class Categoria{

  String nome;
  List<Ricetta> ricette = [];

  Categoria({
    required this.nome
  });

  void aggiungiRicetta(Ricetta r){
    ricette.add(r);
  }

  void rimuoviRicetta(Ricetta r){
    ricette.remove(r);
  }

}