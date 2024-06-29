import 'package:buonappetito/providers/ColorsProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImpostazioniPage extends StatefulWidget {
  const ImpostazioniPage({super.key});

  @override
  State<ImpostazioniPage> createState() => _ImpostazioniPageState();
}

class _ImpostazioniPageState extends State<ImpostazioniPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ColorsProvider>(builder: (context, colorsModel, _) {
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
              // Padding(
              //   padding: const EdgeInsets.only(left: 8.0, top: 8),
              //   child: ListTile(
              //     onTap:() {Navigator.pushNamed(context, '/carrellopage');},
              //     leading: Icon(Icons.shopping_cart_rounded, color: colorsModel.getColoreSecondario()),
              //     title: Text("CARRELLO", style: TextStyle(color: colorsModel.getColoreSecondario(), fontWeight: FontWeight.bold),),
              //   ),
              // ),
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


      body: Column(
        children: [
          Text("impostazioni")
        ],
      ),
    );
    });
  }
}