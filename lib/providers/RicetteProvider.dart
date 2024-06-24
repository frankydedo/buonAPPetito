import 'dart:math';

import 'package:buonappetito/models/Categoria.dart';
import 'package:buonappetito/models/Ricetta.dart';
import 'package:flutter/material.dart';

class RicetteProvider extends ChangeNotifier{

  List <Categoria> categorie = [];
  List <Ricetta> ricette = [
    Ricetta(
      categorie: ["Primi", "Carne"],
      percorsoImmagine: "assets/foto_piatti/ZitiAllaGenovese_2.jpg",
      descrizione: "Ziti spezzati a mano alla genovese",
      ingredienti: ({"Ziti":"120 g / testa", "Carne di bovino":"120 g / testa", "Cipolle":"100 g / testa", "Pecorino":"q.b.", "Pepe":"q.b."}),
      passaggi: ["Scottare la carne per qualche secondo","caramellare le cipolle", "Unire carne e cipolle col brodo", "Apettare 2 ore", "Bollire gli ziti", "Mantecare con formaggio", "Ricoprire con pepe"],
      titolo: "Ziti alla Genovese",
      minutiPreparazione: 180,
      difficolta: 3,
      dataAggiunta: DateTime.now()
    ),
    Ricetta(
      categorie: ["Primi", "Pesce"],
      percorsoImmagine: "assets/foto_piatti_gz/SpaghettiAlleVongole_1.jpg.avif",
      descrizione: "Spaghetti alle vongole",
      ingredienti: ({"Spagghetti":"120 g / testa", "Vongole":"120 g / testa", "Sale":"q.b.", "Pepe":"q.b."}),
      passaggi: ["Far aprire le vongole in padella","Bollire la pasta", "Scolare la pasta nelle vongole", "Mantecare con olio e.v.o a filo"],
      titolo: "Spaghetti alle Vongole",
      minutiPreparazione: 12,
      difficolta: 1,
      dataAggiunta: DateTime.now()
    ),
    Ricetta(
      categorie: ["Secondi", "Carne"],
      percorsoImmagine: "assets/foto_piatti_gz/Ribs_1.jpg.avif",
      descrizione: "Ribs speziate alla brace",
      ingredienti: ({"Ribs di maiale":"100 g / testa","Salsa BBQ":"q.b.", "Spezie":"q.b.", "Sale":"q.b.", "Pepe":"q.b."}),
      passaggi: ["Riscaldare la brace", "Massaggiare la carne con le spezie", "Spennellare con salsa BBQ", "Cuocere a 120° per 2 ore"],
      titolo: "Ribs alla brace",
      minutiPreparazione: 130,
      difficolta: 2,
      dataAggiunta: DateTime.now()
    )
  ];
  
  void aggiugniNuovaRicetta(Ricetta r){
    for (String nomeCategoria in r.categorie){
      for(Categoria c in categorie){
        if (c.nome == nomeCategoria){
          c.aggiungiRicetta(r);
        }
      }
    }
    ricette.add(r);
    notifyListeners();
  }

  void rimuoviRicetta(Ricetta r){
    for(String nomeCategoria in r.categorie){
      for(Categoria c in categorie){
        if (c.nome == nomeCategoria){
          c.rimuoviRicetta(r);

          if (c.ricette.isEmpty){
            categorie.remove(c);
          }
        }
      }
    }
    ricette.remove(r);
    notifyListeners();
  }

  List<Ricetta> generaRicetteCarosello(){
    List <Ricetta> ric = [];

    if (ricette.length < 4){
      return ricette;
    }else{
      Random random = Random();
      Set<int> indici = Set();
      while (indici.length < 3){
        indici.add(random.nextInt(ricette.length));
      }
      for (int i in indici){
        ric.add(ricette.elementAt(i));
      }

      return ric;
    }

  }

  void inizializza(){
    categorie.addAll([
      Categoria(nome: "Primi"),
      Categoria(nome: "Secondi"),
      Categoria(nome: "Carne"),
      Categoria(nome: "Pesce")
    ]);

    Ricetta r1 = Ricetta(
      categorie: ["Primi", "Carne"],
      percorsoImmagine: "assets/foto_piatti/ZitiAllaGenovese_2.jpg",
      descrizione: "Ziti spezzati a mano alla genovese",
      ingredienti: ({"Ziti":"120 g / testa", "Carne di bovino":"120 g / testa", "Cipolle":"100 g / testa", "Pecorino":"q.b.", "Pepe":"q.b."}),
      passaggi: ["Scottare la carne per qualche secondo","caramellare le cipolle", "Unire carne e cipolle col brodo", "Apettare 2 ore", "Bollire gli ziti", "Mantecare con formaggio", "Ricoprire con pepe"],
      titolo: "Ziti alla Genovese",
      minutiPreparazione: 180,
      difficolta: 3,
      dataAggiunta: DateTime.now()
    );

    aggiugniNuovaRicetta(r1);

    Ricetta r2 = Ricetta(
      categorie: ["Primi", "Pesce"],
      percorsoImmagine: "assets/foto_piatti/spagettiAlleVongole_1.JPG",
      descrizione: "Spaghetti alle vongole",
      ingredienti: ({"Spagghetti":"120 g / testa", "Vongole":"120 g / testa", "Sale":"q.b.", "Pepe":"q.b."}),
      passaggi: ["Far aprire le vongole in padella","Bollire la pasta", "Scolare la pasta nelle vongole", "Mantecare con olio e.v.o a filo"],
      titolo: "Spaghetti alle Vongole",
      minutiPreparazione: 12,
      difficolta: 1,
      dataAggiunta: DateTime.now()
    );

    aggiugniNuovaRicetta(r2);

    Ricetta r3 = Ricetta(
      categorie: ["Secondi", "Carne"],
      percorsoImmagine: "assets/foto_piatti/RibsAllaBrace_1.JPG",
      descrizione: "Ribs speziate alla brace",
      ingredienti: ({"Ribs di maiale":"100 g / testa","Salsa BBQ":"q.b.", "Spezie":"q.b.", "Sale":"q.b.", "Pepe":"q.b."}),
      passaggi: ["Riscaldare la brace", "Massaggiare la carne con le spezie", "Spennellare con salsa BBQ", "Cuocere a 120° per 2 ore"],
      titolo: "Ribs alla brace",
      minutiPreparazione: 130,
      difficolta: 2,
      dataAggiunta: DateTime.now()
    );

    aggiugniNuovaRicetta(r3);

  }
  
}
