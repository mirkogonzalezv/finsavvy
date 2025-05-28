part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

final class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

final class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthRegisterRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

<<<<<<< HEAD
// events/auth_events.dart
class AuthCheckRequested extends AuthEvent {
=======
final class AuthExistCurrentAccount extends AuthEvent {}

final class AuthWithGoogleAccount extends AuthEvent {
  const AuthWithGoogleAccount();
  @override
  List<Object> get props => [];
}

final class CloseSessionAccount extends AuthEvent {
  const CloseSessionAccount();
>>>>>>> fix/ruta-register
  @override
  List<Object> get props => [];
}
