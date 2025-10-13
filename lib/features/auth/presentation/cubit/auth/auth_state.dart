part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}
class AuthLoadingState extends AuthState {}
class AuthSuccessState extends AuthState {
  final User user;
  AuthSuccessState({required this.user});

  @override
  List<Object> get props => [user];

}
class AuthErrorState extends AuthState {
  final String message;
  AuthErrorState({required this.message});


  @override
  List<Object> get props => [message];
}

class AuthMessage extends AuthState {
  final String message;
  AuthMessage({required this.message});
  @override
  List<Object> get props => [message];
}
