import 'package:buonappetito/models/Categoria.dart';
import 'package:buonappetito/models/Ricetta.dart';
import 'package:hive/hive.dart';

class RicetteDB {

  List<Ricetta> ricette = [];
  List<Categoria> categorie = [];
  String percorsoFotoProfilo = 'assets/images/logoAPPetito-1024.png';
  String nomeProfilo = "your name";
  List<Ricetta> preferiti = [];
  List<String> carrello =[];

  final _ricetteBox = Hive.box('Ricette');


  void createInitialDataRicette (){

    // inizializzo con 3 ricette di 'default'
    ricette = [
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
    ];
  
    // inizializzo le 4 categorie 'di base'
    categorie = [
    Categoria(nome: "Primi",
      ricette: [
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
      ]
    ),
    Categoria(nome: "Secondi",
    ricette: [
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
    ]),
    Categoria(nome: "Carne",
    ricette: [
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
  ),
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

    ]),
    Categoria(nome: "Pesce",
    ricette: [
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
    ])
  ];
  
    // foto profilo di default
    percorsoFotoProfilo = 'assets/images/logoAPPetito-1024.png';

    // nome profilo di default
    nomeProfilo = "*clicca qui*";

    //altro
    carrello =[];
    preferiti= [];

    updateDatabaseRicette();
  }

  void loadDataRicette () {
    ricette = (_ricetteBox.get("ricette") as List?)?.cast<Ricetta>() ?? [];
    categorie = (_ricetteBox.get("categorie") as List?)?.cast<Categoria>() ?? [];
    percorsoFotoProfilo = _ricetteBox.get("percorsoFotoProfilo", defaultValue: 'assets/images/logoAPPetito-1024.png');
    nomeProfilo = _ricetteBox.get("nomeProfilo", defaultValue: "*clicca qui*");
    carrello = (_ricetteBox.get("carrello") as List?)?.cast<String>() ?? [];
    preferiti = (_ricetteBox.get("preferiti") as List?)?.cast<Ricetta>() ?? [];
  }

  void updateDatabaseRicette () {
    _ricetteBox.put('ricette', ricette);
    _ricetteBox.put('categorie', categorie);
    _ricetteBox.put('percorsoFotoProfilo', percorsoFotoProfilo);
    _ricetteBox.put('nomeProfilo', nomeProfilo);
    _ricetteBox.put('carrello', carrello);
    _ricetteBox.put('preferiti', preferiti); 
  }
}