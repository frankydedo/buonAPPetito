// ignore_for_file: unused_import, unnecessary_import


import 'package:buonappetito/utils/MyDifficolta.dart';
import 'package:buonappetito/providers/ColorsProvider.dart';
import 'package:buonappetito/providers/TimeProvider.dart';
import 'package:buonappetito/providers/RicetteProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class MyTime extends StatelessWidget {
  final Function(int) onSelectionChanged;
  final int selectedTimeIndex;

  MyTime({Key? key, required this.onSelectionChanged, required this.selectedTimeIndex});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ColorsProvider, Timeprovider>(
      builder: (context, colorsModel, timeModel, _) {
        return AlertDialog(
          backgroundColor: colorsModel.dialogBackgroudColor,
          content: SizedBox(
            width: 400,
            height: 450,
            child: Column(
              children: [
                Icon(
                  Icons.schedule_rounded,
                  color: colorsModel.coloreSecondario,
                  size: 50,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: timeModel.allDifficulties.length,
                    itemBuilder: (context, index) {
                      String time = timeModel.allDifficulties[index];
                      bool isSelected = timeModel.selectedDifficulties.contains(time);
                      return CheckboxListTile(
                        side: BorderSide(color: colorsModel.textColor),
                        activeColor: colorsModel.coloreSecondario,
                        title: Text(
                          time,
                          style: TextStyle(
                            color: colorsModel.textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        value:isSelected,
                        onChanged: (val) {
                          if(index!=selectedTimeIndex)
                          {
                            timeModel.setSelectedTimeIndex(index);
                            timeModel.selectedDifficulties.add(time);
                            onSelectionChanged(index);
                          }                          
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: timeModel.hasSelection 
                      ?() {
                        timeModel.setSelectedTimeIndex(-1);
                        onSelectionChanged(-1);
                      }
                      : null,
                      style: ElevatedButton.styleFrom(
                        foregroundColor:  Colors.white,
                        backgroundColor: colorsModel.coloreSecondario,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        elevation: 5,
                        shadowColor: Colors.black,
                      ),
                      child: Text(
                        "Reset",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: colorsModel.coloreSecondario,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        elevation: 5,
                        shadowColor: Colors.black,
                      ),
                      child: Text(
                        "Salva",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
