import 'package:hive/hive.dart';
import 'Ricetta.dart';

part 'Categoria.g.dart'; // Questa direttiva deve essere presente

@HiveType(typeId: 1)
class Categoria {
  @HiveField(0)
  String nome;

  @HiveField(1)
  List<Ricetta> ricette;

  Categoria({
    required this.nome,
    required this.ricette,
  });

  void aggiungiRicetta(Ricetta r) {
    ricette.add(r);
  }

  void rimuoviRicetta(Ricetta r) {
    ricette.remove(r);
  }
}
