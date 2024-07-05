// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DataModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RicettaAdapter extends TypeAdapter<Ricetta> {
  @override
  final int typeId = 1;

  @override
  Ricetta read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Ricetta(
      percorsoImmagine: fields[0] as String,
      titolo: fields[1] as String,
      descrizione: fields[2] as String,
      ingredienti: (fields[3] as Map).cast<String, String>(),
      categorie: (fields[4] as List).cast<String>(),
      passaggi: (fields[5] as List).cast<String>(),
      difficolta: fields[6] as int,
      minutiPreparazione: fields[7] as int,
      dataAggiunta: fields[8] as DateTime,
      isFavourite: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Ricetta obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.percorsoImmagine)
      ..writeByte(1)
      ..write(obj.titolo)
      ..writeByte(2)
      ..write(obj.descrizione)
      ..writeByte(3)
      ..write(obj.ingredienti)
      ..writeByte(4)
      ..write(obj.categorie)
      ..writeByte(5)
      ..write(obj.passaggi)
      ..writeByte(6)
      ..write(obj.difficolta)
      ..writeByte(7)
      ..write(obj.minutiPreparazione)
      ..writeByte(8)
      ..write(obj.dataAggiunta)
      ..writeByte(9)
      ..write(obj.isFavourite);
  }
}

class ItemCarrelloAdapter extends TypeAdapter<ItemCarrello> {
  @override
  final int typeId = 2;

  @override
  ItemCarrello read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ItemCarrello(
      nome: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ItemCarrello obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.nome);
  }
}