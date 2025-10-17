import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lavaloon_ecommerce_app/core/errors/failures.dart';
import 'package:lavaloon_ecommerce_app/features/auth/data/DataSources/auth_local_DataSource.dart';
import 'package:lavaloon_ecommerce_app/features/auth/data/models/user_model.dart';
import 'package:lavaloon_ecommerce_app/features/auth/domain/entities/user_entity.dart';
import 'package:lavaloon_ecommerce_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth firebaseAuth;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.firebaseAuth,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, UserEntity>> signIn(
      String email, String password) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      final user = UserModel(
        id: userCredential.user!.uid,
        email: userCredential.user!.email!,
        name: userCredential.user!.displayName ?? 'User',
      );

      await localDataSource.cacheUser(user);
      return Right(user);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? "Authentication failed"));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final cachedUser = await localDataSource.getCachedUser();
      return Right(cachedUser);
    } catch (e) {
      return Left(CacheFailure("Failed to get user: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? 'Password reset failed'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await firebaseAuth.signOut();
      await localDataSource.clearUser();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUp(
      String email, String password, String name) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      await userCredential.user!.updateDisplayName(name);

      final user = UserModel(
        id: userCredential.user!.uid,
        email: userCredential.user!.email!,
        name: name,
      );
      await localDataSource.cacheUser(user);
      return Right(user);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? "Sign up failed"));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
}
