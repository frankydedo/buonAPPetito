import 'package:flutter/material.dart';

class ColorsProvider extends ChangeNotifier {

  Color colorePrimario_light = Colors.white;
  Color colorePrimario_dark = Colors.grey.shade800;
  Color coloreSecondario = Colors.orange.shade600;

  Color getColorePrimario(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    return isLightMode ? colorePrimario_light : colorePrimario_dark;
  }

  Color getColoreSecondario(){
    return coloreSecondario;
  }

  void setColoreSecondario(Color newColor){
    coloreSecondario = newColor;
    notifyListeners();
  }
  
}