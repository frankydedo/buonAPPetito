// ignore_for_file: must_be_immutable

import 'package:buonappetito/providers/ColorsProvider.dart';
import 'package:buonappetito/providers/RicetteProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FinestraTemporaleDialog extends StatefulWidget {
  //int selezioneAttuale;
  
  FinestraTemporaleDialog({super.key});

  @override
  State<FinestraTemporaleDialog> createState() => _FinestraTemporaleDialogState();
}

class _FinestraTemporaleDialogState extends State<FinestraTemporaleDialog> {

  Map<int, bool> listValues = {1: true, 2: false, 3: false, 4: false};
  //int groupValue = widget.selezioneAttuale;

  @override
  Widget build(BuildContext context) {
    return Consumer2<ColorsProvider, RicetteProvider>(
      builder: (context, colorsModel, ricetteModel, _) {
        return AlertDialog(
          backgroundColor: colorsModel.dialogBackgroudColor,
          content: SizedBox(
            width: 300,
            height: 400,
            child: Column(
              children: [
                Icon(
                  Icons.access_time,
                  color: colorsModel.coloreSecondario,
                  size: 50,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: listValues.length,
                    itemBuilder: (context, index) {
                      int key = listValues.keys.elementAt(index);
                      return RadioListTile<int>(
                        activeColor: colorsModel.coloreSecondario,
                        value: key,
                        groupValue: ricetteModel.finestraTemporale,
                        onChanged: (value) {
                          setState(() {
                            ricetteModel.finestraTemporale = value!;
                            listValues.updateAll((key, value) => false);
                            listValues[key] = true;
                          });
                        },
                        title: Text(
                          index==0
                          ? "1 Settimana"
                          : (index+1).toString() + " Settimane",
                          style: GoogleFonts.encodeSans(
                            color: colorsModel.textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
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
                    "Fatto",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
