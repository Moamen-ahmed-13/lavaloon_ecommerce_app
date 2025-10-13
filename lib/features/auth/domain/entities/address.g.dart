// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AddressesAdapter extends TypeAdapter<Addresses> {
  @override
  final int typeId = 2;

  @override
  Addresses read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Addresses(
      id: fields[0] as String,
      fullName: fields[1] as String,
      phone: fields[2] as String,
      street: fields[3] as String,
      city: fields[4] as String,
      state: fields[5] as String,
      country: fields[6] as String,
      zipCode: fields[7] as String,
      isDefault: fields[8] as bool,
      createdAt: fields[9] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Addresses obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fullName)
      ..writeByte(2)
      ..write(obj.phone)
      ..writeByte(3)
      ..write(obj.street)
      ..writeByte(4)
      ..write(obj.city)
      ..writeByte(5)
      ..write(obj.state)
      ..writeByte(6)
      ..write(obj.country)
      ..writeByte(7)
      ..write(obj.zipCode)
      ..writeByte(8)
      ..write(obj.isDefault)
      ..writeByte(9)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddressesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
