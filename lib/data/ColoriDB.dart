import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ColoriDB {

  bool toInitialize = true;
  String temaAttuale = "Sistema Operativo";
  Color coloreSecondario = Colors.orange.shade600;
  Color coloreSecondario_dark = Colors.orange.shade400;

  Box<dynamic>? _coloriBox;

  Future<void> init() async {
    _coloriBox = await Hive.openBox('Colori');
    loadDataColori();
  }

  void createInitialDataColori() {
    temaAttuale = "Sistema Operativo";
    coloreSecondario = Colors.orange.shade600;
    coloreSecondario_dark = Colors.orange.shade400;
    toInitialize = false;

    updateDatabaseColori();
  }

  void loadDataColori() {
    temaAttuale = _coloriBox?.get("temaAttuale", defaultValue: "Sistema Operativo") ?? "Sistema Operativo";
    coloreSecondario = Color(_coloriBox?.get("coloreSecondario", defaultValue: Colors.orange.shade600.value) ?? Colors.orange.shade600.value);
    coloreSecondario_dark = Color(_coloriBox?.get("coloreSecondarioDark", defaultValue: Colors.orange.shade400.value) ?? Colors.orange.shade400.value);
    toInitialize = _coloriBox?.get("toInitialize", defaultValue: true) ?? true;
  }

  Future<void> updateDatabaseColori() async {
    await _coloriBox?.put('temaAttuale', temaAttuale);
    await _coloriBox?.put('coloreSecondario', coloreSecondario.value);
    await _coloriBox?.put('coloreSecondarioDark', coloreSecondario_dark.value);
    await _coloriBox?.put('toInitialize', toInitialize);
  }
}
