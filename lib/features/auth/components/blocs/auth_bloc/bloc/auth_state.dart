part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoadingState extends AuthState {}

final class AuthErrorState extends AuthState {}

final class AuthSuccessState extends AuthState {
  final User user;
  const AuthSuccessState(this.user); // Objeto de usuario de respuesta

  @override
  List<Object> get props => [user]; // Debe ir el objeto de usuario de respuesta
}
