import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lavaloon_ecommerce_app/features/auth/domain/entities/user_entity.dart';
import 'package:lavaloon_ecommerce_app/features/auth/domain/repositories/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  AuthCubit(this.authRepository) : super(AuthInitial()) {
    checkAuthStatus();
  }
  Future<void> checkAuthStatus() async {
    emit(AuthLoading());
    final result = await authRepository.getCurrentUser();
    result.fold((failure) {
      emit(
        UnAuthenticated(),
      );
    }, (user) {
      if (user == null) {
        emit(UnAuthenticated());
      } else {
        emit(Authenticated(user));
      }
    });
  }

  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    final result = await authRepository.signIn(email, password);
    result.fold((failure) {
      emit(AuthError(failure.message));
    }, (user) {
      emit(Authenticated(user));
    });
  }

  Future<void> signUp(String email, String password, String name) async {
    emit(AuthLoading());
    final result = await authRepository.signUp(email, password, name);
    result.fold((failure) {
      emit(AuthError(failure.message));
    }, (user) {
      emit(Authenticated(user));
    });
  }

  Future<void> signOut() async {
    emit(AuthLoading());
    final result = await authRepository.signOut();
    result.fold((failure) {
      emit(AuthError(failure.message));
    }, (user) {
      emit(UnAuthenticated());
    });
    
  }

  Future<void> resetPassword(String email) async {
    emit(AuthLoading());
    final result = await authRepository.resetPassword(email);
    result.fold((failure) {
      emit(AuthError(failure.message));
    }, (user) {
      emit(AuthPasswordResetSuccess ());
    });
  }
}
