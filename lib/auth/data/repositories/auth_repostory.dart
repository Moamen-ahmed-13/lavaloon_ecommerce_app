// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// class AuthRepostory {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FlutterSecureStorage _storage = FlutterSecureStorage();

//   Future<User?> login(String email, String password,
//       {bool rememberMe = false}) async {
//     UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//         email: email, password: password);
//     if (rememberMe) {
//       await _storage.write(key: 'token', value: userCredential.user?.uid);
//       _auth.setPersistence(Persistence.LOCAL);
//     }
//     return userCredential.user;
//   }

//   Future<void> logout() async {
//     await _auth.signOut();
//     await _storage.delete(key: 'token');
//   }

//   Future<User?> register(String email, String password) async{
//     UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//         email: email, password: password);
//     return userCredential.user;
//   }

//   Future<void> forgotPassword(String email) async {
//     await _auth.sendPasswordResetEmail(email: email);
//   }

//   Future<User?> checkSession() async {
//     String? token = await _storage.read(key: 'token');
//     if (token != null) {
//       return _auth.currentUser;
//     }
//     return null;
//   }
// }
