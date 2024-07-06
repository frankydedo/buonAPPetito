

import 'package:buonappetito/models/Ricetta.dart';
import 'package:hive/hive.dart';

class RicetteListDB {

  List<Ricetta>? RecipesList;

  final _RicetteBox = Hive.box('Recipies');


  void createInitialData (){
    RecipesList = [
    Ricetta(
    categorie: ["Primi", "Carne"],
    percorsoImmagine: "assets/foto_piatti/ZitiAllaGenovese_2.jpg",
    descrizione: "Ziti spezzati a mano alla genovese",
    ingredienti: {
      "Ziti": "120 g / testa",
      "Carne di bovino": "120 g / testa",
      "Cipolle": "100 g / testa",
      "Pecorino": "q.b.",
      "Pepe": "q.b."
    },
    passaggi: [
      "Scottare la carne per qualche secondo",
      "caramellare le cipolle",
      "Unire carne e cipolle col brodo",
      "Apettare 2 ore",
      "Bollire gli ziti",
      "Mantecare con formaggio",
      "Ricoprire con pepe"
    ],
    titolo: "Ziti alla Genovese",
    minutiPreparazione: 180,
    difficolta: 2,
    dataAggiunta: DateTime.now(),
   ),

   Ricetta(
    categorie: ["Primi", "Pesce"],
    percorsoImmagine: "assets/foto_piatti_gz/SpaghettiAlleVongole_1.jpg.avif",
    descrizione: "Spaghetti alle vongole",
    ingredienti: {
      "Spaghetti": "120 g / testa",
      "Vongole": "120 g / testa",
      "Sale": "q.b.",
      "Pepe": "q.b."
    },
    passaggi: [
      "Far aprire le vongole in padella",
      "Bollire la pasta",
      "Scolare la pasta nelle vongole",
      "Mantecare con olio e.v.o a filo"
    ],
    titolo: "Spaghetti alle Vongole",
    minutiPreparazione: 12,
    difficolta: 0,
    dataAggiunta: DateTime.now().subtract(Duration(days: 8)),
   ),

   Ricetta(
    categorie: ["Secondi", "Carne"],
    percorsoImmagine: "assets/foto_piatti_gz/Ribs_1.jpg.avif",
    descrizione: "Ribs speziate alla brace",
    ingredienti: {
      "Ribs di maiale": "100 g / testa",
      "Salsa BBQ": "q.b.",
      "Spezie": "q.b.",
      "Sale": "q.b.",
      "Pepe": "q.b."
    },
    passaggi: [
      "Riscaldare la brace",
      "Massaggiare la carne con le spezie",
      "Spennellare con salsa BBQ",
      "Cuocere a 120° per 2 ore"
    ],
    titolo: "Ribs alla brace",
    minutiPreparazione: 130,
    difficolta: 1,
    dataAggiunta: DateTime.now().subtract(Duration(days: 20)),
   )
  ];}


  Future<void> loadData () async {
   RecipesList = _RicetteBox.get('RecipesList');
  }

  Future<void> updateDatabase () async {
   _RicetteBox.put('RecipiesList',RecipesList);
  }
}