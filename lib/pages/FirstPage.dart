
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, prefer_const_constructors_in_immutables

import 'package:buonappetito/pages/DashboardPage.dart';
import 'package:buonappetito/pages/PreferitiPage.dart';
import 'package:buonappetito/pages/SearchPage.dart';
import 'package:buonappetito/providers/ColorsProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class FirstPage extends StatefulWidget{

  FirstPage({super.key});
  
  @override
  State<StatefulWidget> createState() => _FirstPageState();
}
class _FirstPageState extends State<FirstPage>{
  
  int _selectedIndex = 0;

  void _navigateBottomBar(int index){
    setState(() {
      _selectedIndex=index;
    });
  }

  final List _pages= [
    DashboardPage(), SearchPage(), PreferitiPage()
  ];



  @override 
  Widget build(BuildContext context){
    return Consumer<ColorsProvider>(builder: (context, colorsModel, _) {
      return Scaffold(

        appBar: AppBar(),
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
                  onTap:() {Navigator.pushNamed(context, '/impostazionipage');},
                  leading: Icon(Icons.settings_rounded, color: colorsModel.getColoreSecondario()),
                  title: Text("IMPOSTAZIONI", style: TextStyle(color: colorsModel.getColoreSecondario(), fontWeight: FontWeight.bold),),
                ),
              )
            ],
          ),
        ),
        
        body: _pages[_selectedIndex],

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _navigateBottomBar,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu_rounded),
              label: "DASHBOARD",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_rounded),
              label: "CERCA"
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_rounded),
              label: "PREFERITI"
            ),
          ]
        ),

      );
    });
  }
}