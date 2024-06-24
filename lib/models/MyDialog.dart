// ignore_for_file: prefer_const_constructors, must_be_immutable, prefer_const_literals_to_create_immutables, unused_import, unnecessary_import

import 'package:buonappetito/models/MyDialog.dart';
import 'package:buonappetito/models/Ricetta.dart';
import 'package:buonappetito/providers/ColorsProvider.dart';
import 'package:buonappetito/providers/RicetteProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MyDialog extends StatelessWidget {
MyDialog({super.key});


  @override
  Widget build(BuildContext context) {
    return Consumer2<ColorsProvider,RicetteProvider>(builder: (context,colorsModel,ricetteModel,_){
    return AlertDialog(
      backgroundColor: Colors.white,
      content: SizedBox(
        width: 400,
        height: 350,
        child: Column(
          children: [
            Icon(
              Icons.checklist_rounded,
              color: Colors.orange.shade600,
              size: 70,
            ),
            Spacer(),
            Expanded(
              child:ListView.builder(
                  itemCount: ricetteModel.categorie.length,
                  itemBuilder: (context,index){
                  return Row(
                    children: [
                      RadioListTile(
                        title: Text(
                          ricetteModel.categorie.elementAt(index).nome,
                          style: GoogleFonts.encodeSans(
                            textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600 )
                          ),
                        ),
                        value: index+1, 
                        groupValue: index+1, 
                        onChanged: (val){},
                      ),  
                    ],
                  ); 
                  },
                ),
            ),
            Spacer(),
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(12),
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.orange.shade600,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white,
                        width: 1.5
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5), 
                          spreadRadius: 1.5, 
                          blurRadius: 4, 
                          offset: Offset(0, 2), 
                        ),
                        
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "OK",
                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
  );
  }
}