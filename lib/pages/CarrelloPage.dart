import 'package:buonappetito/providers/ColorsProvider.dart';
import 'package:buonappetito/providers/RicetteProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarrelloPage extends StatefulWidget {
  const CarrelloPage({super.key});

  @override
  State<CarrelloPage> createState() => _CarrelloPageState();
}

class _CarrelloPageState extends State<CarrelloPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<ColorsProvider, RicetteProvider>(builder: (context, colorsModel, ricetteModel, _) {
      return Scaffold(
        appBar: AppBar(
            
          ),
        
        drawer: Drawer(
            child: ListView(
              children: [
                DrawerHeader(child: Image.asset('assets/images/logo_arancio.png')),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 8),
                  child: ListTile(
                    onTap:() {Navigator.pushNamed(context, '/firstpage');},
                    leading: Icon(Icons.home_rounded, color: colorsModel.getColoreSecondario()),
                    title: Text("HOME", style: TextStyle(color: colorsModel.getColoreSecondario(), fontWeight: FontWeight.bold),),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 8),
                  child: ListTile(
                    onTap:() {Navigator.pushNamed(context, '/carrellopage');},
                    leading: Icon(Icons.shopping_cart_rounded, color: colorsModel.getColoreSecondario()),
                    title: Text("CARRELLO", style: TextStyle(color: colorsModel.getColoreSecondario(), fontWeight: FontWeight.bold),),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 8),
                  child: ListTile(
                    onTap:() {Navigator.pushNamed(context, '/impostazionipage');},
                    leading: Icon(Icons.settings_rounded, color: colorsModel.getColoreSecondario()),
                    title: Text("IMPOSTAZIONI", style: TextStyle(color: colorsModel.getColoreSecondario(), fontWeight: FontWeight.bold),),
                  ),
                )
              ],
            ),
          ),

        body: Center(
          child: Text("Carrello"),
        ),
      );
    });
  }
}