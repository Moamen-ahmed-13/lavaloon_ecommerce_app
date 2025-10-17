import 'package:lavaloon_ecommerce_app/features/checkout/domain/entities/address_entity.dart';

class AddressModel extends AddressEntity {
  const AddressModel(
      {required super.city,
      required super.street,
      required super.zipCode,
      required super.fullName,
      required super.phone,
      required super.state,
      required super.country});

  factory AddressModel.fromJson(Map<dynamic, dynamic> json) => AddressModel(
      city: json['city'],
      street: json['street'],
      zipCode: json['zipCode'],
      fullName: json['fullName'],
      phone: json['phone'],
      state: json['state'],
      country: json['country']);

  Map<dynamic, dynamic> toJson() => {
        'city': city,
        'street': street,
        'zipCode': zipCode,
        'fullName': fullName,
        'phone': phone,
        'state': state,
        'country': country
      };
}
