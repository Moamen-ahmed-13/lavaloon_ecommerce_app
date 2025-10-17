import 'package:hive/hive.dart';
import 'package:lavaloon_ecommerce_app/features/auth/data/models/user_model.dart';

class AuthLocalDataSource {
  final Box userBox = Hive.box('user');

  Future<void> cacheUser(UserModel user) async {
    await userBox.put('current_user', user.toJson());
  }

  Future<UserModel?> getCachedUser() async {
    final userData = userBox.get('current_user');
    if (userData != null) {
      return UserModel.fromJson(Map<dynamic, dynamic>.from(userData));
    }
    return null;
  }

  Future<void> clearUser() async {
    await userBox.delete('current_user');
  }
}
