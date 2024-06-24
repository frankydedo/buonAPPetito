// ignore_for_file: unused_local_variable

import 'package:buonappetito/models/MyDialog.dart';
import 'package:buonappetito/providers/ColorsProvider.dart';
import 'package:buonappetito/providers/RicetteProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});


  @override
  State<SearchPage> createState() => _SearchPageState();
}


class _SearchPageState extends State<SearchPage> {

void showMyDialog(){

    setState(() {
      showDialog(
        context: context, 
        builder: (context){
          return MyDialog();
        }
      );
    });
  }

  
TextEditingController controller = TextEditingController();
 bool isButtonPressed1 = false;
  bool isButtonPressed2 = false;
   bool isButtonPressed3 = false;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Consumer2<ColorsProvider,RicetteProvider>(builder: (context,colorsModel,ricetteModel,_)
    {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
           margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
           child: TextField(
            controller: controller,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Cerca una ricetta...',
              border: OutlineInputBorder(
               borderRadius: BorderRadius.circular(20),
               borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: colorsModel.getColoreSecondario(), width: 2.0),
                ),
              ),
              )
            ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
         children: [
          //first button
          SizedBox(
            width: screenWidth * 0.3,
            child: ElevatedButton.icon(
              onPressed: () {
                 setState(() {
                          isButtonPressed1 = !isButtonPressed1;
                        });
                showMyDialog();
              }, 
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, 
                  backgroundColor: isButtonPressed1 ? colorsModel.getColoreSecondario() : colorsModel.getColoreSecondario().withOpacity(.4)  , // Cambia il colore in base allo stato del bottone,
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  elevation: 5,
                  shadowColor: Colors.black,
                ),
              icon:Icon(Icons.checklist_rounded,
              size: 15),
              label: Text("Categorie",
                style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                ),
              ), 
            ),
          ),

          //second button
          SizedBox(
            width: screenWidth*0.3,
            child: ElevatedButton.icon(
              onPressed: () {
                 setState(() {
                          isButtonPressed2 = !isButtonPressed2;
                        });
                print("scegli difficoltà");
              }, 
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, 
                  backgroundColor: isButtonPressed2 ? colorsModel.getColoreSecondario() : colorsModel.getColoreSecondario().withOpacity(.4)  , // Cambia il colore in base allo stato del bottone,
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  elevation: 5,
                  shadowColor: Colors.black,
                ),
              icon:Icon(Icons.restaurant_menu_rounded,
              size: 15,),
              label: Text("difficoltà",
                style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                ),
              ), 
            ),
          ),

          //third button
          SizedBox(
            width: screenWidth *0.25,
            child: ElevatedButton.icon(
              onPressed: () {
                 setState(() {
                          isButtonPressed3 = !isButtonPressed3;
                        });
                print("scegli tempo");
              }, 
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, 
                  backgroundColor: isButtonPressed3 ? colorsModel.getColoreSecondario() : colorsModel.getColoreSecondario().withOpacity(.4)  , // Cambia il colore in base allo stato del bottone,
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  elevation: 5,
                  shadowColor: Colors.black,
                ),
              icon:Icon(Icons.schedule_rounded,
              size: 15,),
              label: Text("tempo",
                style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                ),
              ), 
            ),
          ),
         ],
        ),
        ],
      ),
    );
    });
  }
}