import 'package:equatable/equatable.dart';

class AddressEntity extends Equatable {
  final String fullName;
  final String phone;
  final String street;
  final String city;
  final String state;
  final String country;
  final String zipCode;

  const AddressEntity({
    required this.fullName,
    required this.phone,
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.zipCode,
  });

  @override
  List<Object?> get props => [
    fullName,
    phone,
    street,
    city,
    state,
    country,
    zipCode,
  ];
  
}