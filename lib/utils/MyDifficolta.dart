import 'package:flutter/material.dart';
import 'package:buonappetito/providers/ColorsProvider.dart';
import 'package:buonappetito/providers/DifficultyProvider.dart';
import 'package:provider/provider.dart';

class MyDifficolta extends StatelessWidget {
  final Function(List<int>) onSelectionChanged;
  final List<int> selectedDifficultyIndices;

  MyDifficolta({Key? key, required this.onSelectionChanged, required this.selectedDifficultyIndices});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ColorsProvider, DifficultyProvider>(
      builder: (context, colorsModel, difficultyModel, _) {
        return AlertDialog(
          backgroundColor: colorsModel.getColorePrimario(context),
          content: SizedBox(
            width: 400,
            height: 450,
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
                    itemCount: difficultyModel.allDifficulties.length,
                    itemBuilder: (context, index) {
                      String difficulty = difficultyModel.allDifficulties[index];
                      bool isSelected = difficultyModel.isSelected(index);
                      return CheckboxListTile(
                        activeColor: colorsModel.getColoreSecondario(),
                        title: Text(
                          difficulty,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        value: isSelected,
                        onChanged: (val) {
                          difficultyModel.toggleDifficultyIndex(index);
                          onSelectionChanged(difficultyModel.selectedDifficultyIndices.toList());
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
                      onPressed: difficultyModel.hasSelection 
                      ? () {
                          difficultyModel.resetSelection();
                          onSelectionChanged([]);
                        }
                      : null,
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
