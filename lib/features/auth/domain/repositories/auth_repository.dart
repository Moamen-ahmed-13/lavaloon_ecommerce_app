import 'package:dartz/dartz.dart';
import 'package:lavaloon_ecommerce_app/core/errors/failures.dart';
import 'package:lavaloon_ecommerce_app/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signIn(String email, String password);
  Future<Either<Failure, UserEntity>> signUp(String email, String password,String name);
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, void>> resetPassword(String email);
  Future<Either<Failure, UserEntity?>> getCurrentUser();
}
