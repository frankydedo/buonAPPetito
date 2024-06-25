// ignore_for_file: unused_import, unnecessary_import

import 'package:buonappetito/models/MyDialog.dart';
import 'package:buonappetito/models/MyDifficolta.dart';
import 'package:buonappetito/providers/ColorsProvider.dart';
import 'package:buonappetito/providers/TimeProvider.dart';
import 'package:buonappetito/providers/RicetteProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class MyTime extends StatelessWidget {
  final Function(bool) onSelectionChanged;

  MyTime({Key? key, required this.onSelectionChanged});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ColorsProvider, Timeprovider>(
      builder: (context, colorsModel, timeModel, _) {
        return AlertDialog(
          backgroundColor: colorsModel.getColorePrimario(context),
        content: SizedBox(
            width: 400,
            height: 350,
            child: Column(
              children: [
                Icon(
                  Icons.restaurant_menu_rounded,
                  color: colorsModel.getColoreSecondario(),
                  size: 50,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: timeModel.allDifficulties.length,
                    itemBuilder: (context, index) {
                      String difficulty = timeModel.allDifficulties[index];
                      return CheckboxListTile(
                        activeColor: colorsModel.getColoreSecondario(),
                        title: Text(
                          difficulty,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        value: timeModel.selectedDifficulties.contains(difficulty),
                        onChanged: (val) {
                          if (val!) {
                            timeModel.setSelectedTimeIndex(index);
                          } else {
                            timeModel.setSelectedTimeIndex(-1);
                          }
                          onSelectionChanged(val);
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
                      onPressed: () {
                        timeModel.setSelectedTimeIndex(-1);
                        onSelectionChanged(false);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: colorsModel.getColorePrimario(context),
                        backgroundColor: colorsModel.getColoreSecondario(),
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
                          fontSize: 14,
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
                        backgroundColor: colorsModel.getColoreSecondario(),
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
                          fontSize: 14,
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
