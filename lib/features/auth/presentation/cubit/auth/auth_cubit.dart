import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lavaloon_ecommerce_app/features/auth/data/repositories/auth_repostory.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepostory repostory=AuthRepostory();
  AuthCubit() : super(AuthInitial());

  Future<void> login(String email, String password,
      {bool rememberMe = false}) async {
    emit(AuthLoadingState());
    try {
      User? user =
          await repostory.login(email, password, rememberMe: rememberMe);
      if (user != null) {
        emit(AuthSuccessState(user: user!));
      }else{
        emit(AuthErrorState(message: 'User not found'));
      }
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }

  Future<void> register(String email, String password) async {
    emit(AuthLoadingState());
    try {
      User? user = await repostory.register(email, password);
      if (user != null) {
        emit(AuthSuccessState(user: user!));
      }
      else{
        emit(AuthErrorState(message: 'Registration failed'));
      }
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }

  Future<void> logout() async {
    emit(AuthLoadingState());
    try {
      await repostory.logout();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }

  Future<void> checkSession() async {
    emit(AuthLoadingState());
    try {
      User? user = await repostory.checkSession();
      if (user != null) {
        emit(AuthSuccessState(user: user!));
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }

  Future<void> forgotPassword(String email) async {
    emit(AuthLoadingState());
    try {
      await repostory.forgotPassword(email);
      emit(AuthInitial());
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }
}
