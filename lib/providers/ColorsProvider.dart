import 'package:flutter/material.dart';

class ColorsProvider extends ChangeNotifier {
  bool isLightMode = true;

  String _temaAttuale = "Sistema Operativo";

  String get temaAttuale => _temaAttuale;

  Color _colorePrimario = Colors.grey.shade100;
  Color _colorePrimario_dark = Color.fromARGB(255, 9, 9, 9);
  Color _coloreSecondario = Colors.orange.shade600;
  Color _coloreSecondario_dark = Colors.orange.shade600;
  Color _coloreTitoli = Colors.indigo.shade800;
  // Color _coloreTitoli_dark = Colors.indigo.shade200;

  Color get coloreTitoli => isLightMode ? _coloreTitoli : _colorePrimario;
  Color get colorePrimario => isLightMode ? _colorePrimario : _colorePrimario_dark;
  Color get coloreSecondario => isLightMode ? _coloreSecondario : _coloreSecondario_dark;
  Color get backgroudColor => isLightMode ? _colorePrimario : _colorePrimario_dark;
  Color get tileBackGroudColor => isLightMode ? Colors.white : const Color.fromARGB(255, 36, 36, 36);
  Color get textColor => !isLightMode ? Colors.white : Colors.black;
  Color get dialogBackgroudColor=> isLightMode ? _colorePrimario : const Color.fromARGB(255, 36, 36, 36);
  

  void setTemaAttualeChiaroScuro(BuildContext context, String nuovoTema){
    _temaAttuale = nuovoTema;
    isLightMode = _temaAttuale == "Chiaro" ? true : false;
  }

  void setTemaAttualeSistemaOperativo(BuildContext context){
    _temaAttuale = "Sistema Operativo";
    initLightMode(context);
  }

  void initLightMode(BuildContext context) {
    if(_temaAttuale == "Sistema Operativo"){
      final brightness = MediaQuery.of(context).platformBrightness;
      isLightMode = brightness == Brightness.light;
      notifyListeners();
    }
  }

  void updateLightMode(BuildContext context) {
    if(_temaAttuale == "Sistema Operativo"){
      final brightness = MediaQuery.of(context).platformBrightness;
      isLightMode = brightness != Brightness.light;
      notifyListeners();
    }
  }

  void setViolaColoreSecondario() {
    _coloreSecondario = Colors.purple.shade600;
    _coloreSecondario_dark = Colors.purple.shade400;
    notifyListeners();
  }

  void setArancioneColoreSecondario() {
    _coloreSecondario = Colors.orange.shade600;
    _coloreSecondario_dark = Colors.orange.shade400;
    notifyListeners();
  }

  void setBluColoreSecondario() {
    _coloreSecondario = Colors.indigo.shade800;
    _coloreSecondario_dark = Colors.indigo.shade300;
    notifyListeners();
  }

  void setVerdeColoreSecondario() {
    _coloreSecondario = Colors.green.shade800;
    _coloreSecondario_dark = Colors.green.shade600;
    notifyListeners();
  }
}
