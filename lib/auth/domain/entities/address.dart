// import 'package:equatable/equatable.dart';
// import 'package:hive_flutter/adapters.dart';
// import 'package:uuid/uuid.dart';

// part 'address.g.dart';

// @HiveType(typeId: 2)
// class Addresses extends Equatable {
//   @HiveField(0)
//   final String id;
//   @HiveField(1)
//   final String fullName;
//   @HiveField(2)
//   final String phone;
//   @HiveField(3)
//   final String street;
//   @HiveField(4)
//   final String city;
//   @HiveField(5)
//   final String state;
//   @HiveField(6)
//   final String country;
//   @HiveField(7)
//   final String zipCode;
//   @HiveField(8)
//   final bool isDefault;
//   @HiveField(9)
//   final DateTime createdAt;

//   Addresses(
//       {required this.id,
//       required this.fullName,
//       required this.phone,
//       required this.street,
//       required this.city,
//       required this.state,
//       required this.country,
//       required this.zipCode,
//       required this.isDefault,
//       required this.createdAt});

//   factory Addresses.create({
//     required String fullName,
//     required String phone,
//     required String street,
//     required String city,
//     String? state,
//     required String zipCode,
//     String country = 'USA',
//   }) {
//     return Addresses(
//       id: const Uuid().v4(),
//       fullName: fullName,
//       phone: phone,
//       street: street,
//       city: city,
//       state: state ?? '',
//       country: country,
//       zipCode: zipCode,
//       isDefault: false,
//       createdAt: DateTime.now(),
//     );
//   }
//   Addresses copyWith({
//     String? id,
//     String? fullName,
//     String? phone,
//     String? street,
//     String? city,
//     String? state,
//     String? country,
//     String? zipCode,
//     bool? isDefault,
//     DateTime? createdAt,
//   }){
//     return Addresses(
//       id: id ?? this.id,
//       fullName: fullName ?? this.fullName,
//       phone: phone ?? this.phone,
//       street: street ?? this.street,
//       city: city ?? this.city,
//       state: state ?? this.state,
//       country: country ?? this.country,
//       zipCode: zipCode ?? this.zipCode,
//       isDefault: isDefault ?? this.isDefault,
//       createdAt: createdAt ?? this.createdAt,
//     );
//   }
//   Map<dynamic,dynamic> toMap() {
//     return {
//       'id': id,
//       'fullName': fullName,
//       'phone': phone,
//       'street': street,
//       'city': city,
//       'state': state,
//       'country': country,
//       'zipCode': zipCode,
//       'isDefault': isDefault,
//       'createdAt': createdAt.toIso8601String(),
//     };
//   }

//   factory Addresses.fromMap(Map<dynamic,dynamic> map) {
//     return Addresses(
//       id: map['id'] as String,
//       fullName: map['fullName'] as String,
//       phone: map['phone'] as String,
//       street: map['street'] as String,
//       city: map['city'] as String,
//       state: map['state'] as String? ?? '',
//       country: map['country'] as String,
//       zipCode: map['zipCode'] as String? ?? 'USA',
//       isDefault: map['isDefault'] as bool? ?? false,
//       createdAt: DateTime.parse(map['createdAt'] as String),
//     );
//   }

//   String get displayString => '$fullName\n$street, $city, $state, $country';

//   bool get isValid => fullName.isNotEmpty &&
//         phone.isNotEmpty &&
//         street.isNotEmpty &&
//         city.isNotEmpty &&
//         state.isNotEmpty &&
//         country.isNotEmpty &&
//         zipCode.isNotEmpty;

//   @override
//   List<Object?> get props => [
//         id,
//         fullName,
//         phone,
//         street,
//         city,
//         state,
//         country,
//         zipCode,
//         isDefault,
//         createdAt
//       ];
// }
