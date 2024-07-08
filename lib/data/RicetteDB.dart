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

    // inizializzo con 10 ricette di 'default'
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
      ),
      Ricetta(
        categorie: ["Secondi", "Pesce"],
        percorsoImmagine: "assets/foto_piatti_gz/Baccala-alla-livornese_780x520_wm.jpg.avif",
        descrizione: "Baccalà alla livornese",
        ingredienti: {
          "Baccalà": "200 g",
          "Pomodori": "300 g",
          "Aglio": "2 spicchi",
          "Prezzemolo": "q.b.",
          "Peperoncino": "q.b.",
          "Olio e.v.o.": "q.b."
        },
        passaggi: [
          "Tagliare il baccalà a pezzi",
          "Soffriggere aglio e peperoncino",
          "Aggiungere pomodori e cuocere per 20 minuti",
          "Unire il baccalà e cuocere per altri 20 minuti",
          "Servire con prezzemolo fresco"
        ],
        titolo: "Baccalà alla livornese",
        minutiPreparazione: 45,
        difficolta: 1,
        dataAggiunta: DateTime.now().subtract(Duration(days: 15)),
      ),
      Ricetta(
        categorie: ["Secondi", "Pesce"],
        percorsoImmagine: "assets/foto_piatti_gz/branzino-cartoccio.jpg",
        descrizione: "Branzino al cartoccio",
        ingredienti: {
          "Branzino": "1 intero",
          "Limone": "1",
          "Rosmarino": "2 rametti",
          "Aglio": "2 spicchi",
          "Olio e.v.o.": "q.b.",
          "Sale": "q.b.",
          "Pepe": "q.b."
        },
        passaggi: [
          "Pulire il branzino",
          "Inserire limone, rosmarino e aglio nel pesce",
          "Condire con olio, sale e pepe",
          "Chiudere il pesce in un cartoccio di alluminio",
          "Cuocere in forno a 180° per 25 minuti"
        ],
        titolo: "Branzino al cartoccio",
        minutiPreparazione: 30,
        difficolta: 1,
        dataAggiunta: DateTime.now().subtract(Duration(days: 12)),
      ),
      Ricetta(
        categorie: ["Secondi", "Carne"],
        percorsoImmagine: "assets/foto_piatti_gz/filetto-al-pepe-verde.jpg.avif",
        descrizione: "Filetto al pepe verde",
        ingredienti: {
          "Filetto di manzo": "200 g",
          "Pepe verde": "1 cucchiaio",
          "Panna": "200 ml",
          "Burro": "30 g",
          "Brandy": "50 ml",
          "Sale": "q.b."
        },
        passaggi: [
          "Cuocere il filetto nel burro",
          "Flambare con brandy",
          "Aggiungere panna e pepe verde",
          "Cuocere fino a riduzione della salsa",
          "Servire caldo"
        ],
        titolo: "Filetto al pepe verde",
        minutiPreparazione: 20,
        difficolta: 2,
        dataAggiunta: DateTime.now().subtract(Duration(days: 10)),
      ),
      Ricetta(
        categorie: ["Dolci"],
        percorsoImmagine: "assets/foto_piatti_gz/tiramisu.jpg.avif",
        descrizione: "Tiramisù classico",
        ingredienti: {
          "Savoiardi": "200 g",
          "Mascarpone": "250 g",
          "Uova": "3",
          "Zucchero": "100 g",
          "Caffè": "200 ml",
          "Cacao amaro": "q.b."
        },
        passaggi: [
          "Montare i tuorli con lo zucchero",
          "Aggiungere il mascarpone",
          "Montare gli albumi a neve e unirli al composto",
          "Inzuppare i savoiardi nel caffè",
          "Alternare strati di savoiardi e crema",
          "Spolverare con cacao e refrigerare"
        ],
        titolo: "Tiramisù classico",
        minutiPreparazione: 30,
        difficolta: 1,
        dataAggiunta: DateTime.now().subtract(Duration(days: 5)),
      ),
      Ricetta(
        categorie: ["Dolci"],
        percorsoImmagine: "assets/foto_piatti_gz/panna cotta-1.jpg.avif",
        descrizione: "Panna cotta",
        ingredienti: {
          "Panna fresca": "500 ml",
          "Zucchero": "100 g",
          "Vaniglia": "1 bacca",
          "Gelatina": "8 g",
          "Frutti di bosco": "200 g"
        },
        passaggi: [
          "Scaldare la panna con zucchero e vaniglia",
          "Ammollare la gelatina e aggiungerla alla panna",
          "Versare negli stampini",
          "Refrigerare per almeno 4 ore",
          "Servire con salsa ai frutti di bosco"
        ],
        titolo: "Panna cotta",
        minutiPreparazione: 20,
        difficolta: 0,
        dataAggiunta: DateTime.now().subtract(Duration(days: 6)),
      ),
      Ricetta(
        categorie: ["Dolci"],
        percorsoImmagine: "assets/foto_piatti_gz/crostata-di-frutta-2.jpg.avif",
        descrizione: "Crostata di frutta",
        ingredienti: {
          "Pasta frolla": "1 base",
          "Crema pasticcera": "500 g",
          "Frutta fresca": "500 g",
          "Gelatina": "q.b."
        },
        passaggi: [
          "Cuocere la base di pasta frolla",
          "Riempire con crema pasticcera",
          "Decorare con frutta fresca",
          "Lucidare con gelatina",
          "Refrigerare prima di servire"
        ],
        titolo: "Crostata di frutta",
        minutiPreparazione: 60,
        difficolta: 1,
        dataAggiunta: DateTime.now().subtract(Duration(days: 7)),
      ),
      Ricetta(
        categorie: ["Antipasti", "Verdure"],
        percorsoImmagine: "assets/foto_piatti_gz/bruschette.jpg.avif",
        descrizione: "Bruschette al pomodoro",
        ingredienti: {
          "Pane": "4 fette",
          "Pomodori": "200 g",
          "Aglio": "1 spicchio",
          "Basilico": "q.b.",
          "Olio e.v.o.": "q.b.",
          "Sale": "q.b.",
          "Pepe": "q.b."
        },
        passaggi: [
          "Tostare il pane",
          "Strofinare l'aglio sul pane",
          "Tagliare i pomodori a cubetti",
          "Condire con olio, sale, pepe e basilico",
          "Disporre i pomodori sul pane tostato",
          "Servire subito"
        ],
        titolo: "Bruschette al pomodoro",
        minutiPreparazione: 15,
        difficolta: 0,
        dataAggiunta: DateTime.now().subtract(Duration(days: 3)),
      ),
    ];

    // inizializzo le categorie 'di base'
    categorie = [
      Categoria(nome: "Primi", ricette: [
        ricette[0],
        ricette[1],
      ]),
      Categoria(nome: "Secondi", ricette: [
        ricette[2],
        ricette[3],
        ricette[4],
        ricette[5],
      ]),
      Categoria(nome: "Dolci", ricette: [
        ricette[6],
        ricette[7],
        ricette[8],
      ]),
      Categoria(nome: "Antipasti", ricette: [
        ricette[9],
      ]),
      Categoria(nome: "Carne", ricette: [
        ricette[0],
        ricette[2],
        ricette[5],
      ]),
      Categoria(nome: "Pesce", ricette: [
        ricette[1],
        ricette[3],
        ricette[4],
      ]),
      Categoria(nome: "Verdure", ricette: [
        ricette[9],
      ]),
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
