// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Ricetta.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RicettaAdapter extends TypeAdapter<Ricetta> {
  @override
  final int typeId = 0;

  @override
  Ricetta read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Ricetta(
      percorsoImmagine: fields[0] as String,
      categorie: (fields[4] as List).cast<String>(),
      descrizione: fields[2] as String,
      ingredienti: (fields[3] as Map).cast<String, String>(),
      passaggi: (fields[5] as List).cast<String>(),
      titolo: fields[1] as String,
      minutiPreparazione: fields[7] as int,
      difficolta: fields[6] as int,
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

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RicettaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
