import 'package:hive/hive.dart';

part 'DataModel.g.dart';

@HiveType(typeId: 0)
class Ricetta extends HiveObject{
  @HiveField(0)
  String percorsoImmagine;

  @HiveField(1)
  String titolo;

  @HiveField(2)
  String descrizione;

  @HiveField(3)
  Map<String, String> ingredienti;

  @HiveField(4)
  List<String> categorie;

  @HiveField(5)
  List<String> passaggi;

  @HiveField(6)
  int difficolta;

  @HiveField(7)
  int minutiPreparazione;

  @HiveField(8)
  DateTime dataAggiunta;

  @HiveField(9)
  bool isFavourite;

  Ricetta({
    required this.percorsoImmagine,
    required this.titolo,
    required this.descrizione,
    required this.ingredienti,
    required this.categorie,
    required this.passaggi,
    required this.difficolta,
    required this.minutiPreparazione,
    required this.dataAggiunta,
    this.isFavourite = false,
  });
}

@HiveType(typeId: 1)
class ItemCarrello extends HiveObject{
  @HiveField(0)
  String nome;

  ItemCarrello({required this.nome});
}