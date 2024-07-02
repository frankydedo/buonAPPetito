// ignore_for_file: must_be_immutable

import 'package:buonappetito/providers/ColorsProvider.dart';
import 'package:buonappetito/providers/RicetteProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IconButtonCircolareFoto extends StatelessWidget {

  void Function()? onPressed;
  void Function()? onLongPress;
  Color coloreBordo;
  String percorsoImmagine;
  double raggio;

  IconButtonCircolareFoto({super.key, required this.onPressed, this.onLongPress, required this.coloreBordo, required this.percorsoImmagine, required this.raggio});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ColorsProvider, RicetteProvider>(builder: (context, colorsModel, ricetteModel, _) {
      return TextButton(
        onPressed: onPressed,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: raggio,
            width: raggio,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(75),
              border: Border.all(
                color: coloreBordo,
                width: 3,
              ),
            ),
            child: Container(
              height: raggio,
              width: raggio,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(75),
                border: Border.all(
                  color: Colors.transparent,
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: Image.asset(
                  percorsoImmagine,
                  fit: BoxFit.cover,
                  width: raggio,
                  height: raggio,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}