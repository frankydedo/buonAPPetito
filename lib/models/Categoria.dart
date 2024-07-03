import 'package:buonappetito/models/Ricetta.dart';

class Categoria{

  String nome;
  List<Ricetta> ricette;

  Categoria({
    required this.nome,
    required this.ricette
  });

  void aggiungiRicetta (Ricetta r){
    ricette.add(r);
  }
  void riumoviRicetta (Ricetta r){
    ricette.remove(r);
  }

}