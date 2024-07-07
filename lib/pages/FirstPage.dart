// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, prefer_const_constructors_in_immutables

import 'package:buonappetito/pages/DashboardPage.dart';
import 'package:buonappetito/pages/PreferitiPage.dart';
import 'package:buonappetito/pages/SearchPage.dart';
import 'package:buonappetito/providers/ColorsProvider.dart';
import 'package:buonappetito/providers/RicetteProvider.dart';
import 'package:buonappetito/utils/CarrelloIcon.dart';
import 'package:buonappetito/utils/CategoriaIcon.dart';
import 'package:buonappetito/utils/IconButtonCircolareFoto.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FirstPage extends StatefulWidget {
  FirstPage({super.key});

  @override
  State<StatefulWidget> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List _pages = [DashboardPage(), SearchPage(), PreferitiPage()];

  @override
  Widget build(BuildContext context) {
    return Consumer2<ColorsProvider, RicetteProvider>(
        builder: (context, colorsModel, ricetteModel, _) {
      int cartItemsNumber =Provider.of<RicetteProvider>(context, listen: false).carrello.length;
      int numberOfCategory = Provider.of<RicetteProvider>(context, listen:false).categorie.length;
      return Scaffold(
        appBar: AppBar(
          backgroundColor: colorsModel.backgroudColor,
          iconTheme: IconThemeData(
            color: colorsModel.coloreSecondario,
            size: 28.0,
          ),
          title: Row(
            children: [
              Spacer(),
              IconButtonCircolareFoto(
                onPressed: (){
                  Navigator.pushNamed(context, '/impostazionipage');
                },
                coloreBordo: colorsModel.coloreSecondario,
                percorsoImmagine: ricetteModel.percorsoFotoProfilo,
                raggio: 43
              ),
              CarrelloIcon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/carrellopage').then((_) {
                      setState(() {
                        cartItemsNumber = ricetteModel.carrello.length;
                      });
                    });
                  },
                  showNumber: cartItemsNumber),
              CategoriaIcon(
                onPressed: () {
                  Navigator.pushNamed(context, '/categoriapage').then((_){
                    setState((){
                      numberOfCategory=ricetteModel.categorie.length;
                    });
                  });
                }, showNumber: numberOfCategory,
              )
            ],
          ),
        ),
        drawer: Drawer(
          backgroundColor: colorsModel.backgroudColor,
          child: ListView(
            children: [
              DrawerHeader(
                  child: Image.asset('assets/images/logo_arancio.png')),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 8),
                child: ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, '/firstpage');
                  },
                  leading: Icon(Icons.home_rounded,
                      color: colorsModel.coloreSecondario),
                  title: Text(
                    "HOME",
                    style: TextStyle(
                        color: colorsModel.coloreSecondario,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, '/impostazionipage');
                  },
                  leading: Icon(Icons.settings_rounded,
                      color: colorsModel.coloreSecondario),
                  title: Text(
                    "IMPOSTAZIONI",
                    style: TextStyle(
                        color: colorsModel.coloreSecondario,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: colorsModel.backgroudColor,
            selectedItemColor: colorsModel.coloreSecondario,
            unselectedItemColor: colorsModel.coloreSecondario,
            selectedIconTheme: IconThemeData(
              size: 30,
              opacity: 1,
            ),
            unselectedIconTheme: IconThemeData(
              size: 25,
              opacity: .5,
            ),
            selectedLabelStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.normal,
            ),
            currentIndex: _selectedIndex,
            onTap: _navigateBottomBar,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.restaurant_menu_rounded),
                label: "DASHBOARD",
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search_rounded), label: "CERCA"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite_rounded), label: "PREFERITI"),
            ]),
      );
    });
  }
}
