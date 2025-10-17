// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:hive_flutter/adapters.dart';
// import 'package:lavaloon_ecommerce_app/features/auth/domain/entities/address.dart';

// class AddressRepository {
//   Box<Addresses>? addressBox;


//   Future<Box<Addresses>> get _box async {
//   if (addressBox == null || !addressBox!.isOpen) {
//     addressBox = await Hive.openBox<Addresses>('addresses');
//   }
//   return addressBox!;
// }


//   Future<void> saveAddress(Addresses address, {String? userId}) async {
//     final box = await _box;
//     await box.put(address.id, address);

//     if (userId != null) {
//       await FirebaseFirestore.instance
//           .collection('users/$userId/addresses')
//           .doc(address.id)
//           .set(address.toMap());
//     }

//     if (address.isDefault) {
//       await _setDefaultAddress(address.id);
//     }
//   }

//   Future<List<Addresses>> getSavedAddresses() async {
//     final box = await _box;
//     return  box.values.toList();
//   }

//   Future<Addresses> getDefaultAddress()async
//    {
//     final box=await _box;
//     return box.values.firstWhere((address) => address.isDefault,
//         orElse: () => Addresses(
//             city: '',
//             country: '',
//             createdAt: DateTime.now(),
//             fullName: '',
//             id: '',
//             isDefault: false,
//             phone: '',
//             street: '',
//             state: '',
//             zipCode: ''));
//   }

//   Future<void> _setDefaultAddress(String addressId) async {
//     final addressBox = await _box;
//     final addresses = addressBox.values.toList();
//     for (var address in addresses) {
//       final updated = address.copyWith(isDefault: address.id == addressId);
//       addressBox.put(address.id, updated);
//     }
//   }

//   Future<void> deleteAddress(String addressId) async {
//     final box = await _box;
//     await box.delete(addressId);
//   }

//   Future<List<Addresses>> getAddressesFromFirestore(String userId) async {
//     final snapshot = await FirebaseFirestore.instance
//         .collection('users/$userId/addresses')
//         .get();
//     return snapshot.docs.map((doc) => Addresses.fromMap(doc.data())).toList();
//   }
// }
