import 'package:finsavvy/models/user_local.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth;
  final Isar _isar;
  AuthBloc({required FirebaseAuth firebaseAuth, required Isar isar})
    : _firebaseAuth = firebaseAuth,
      _isar = isar,
      super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterAccount);
    on<AuthCheckRequested>(_onAuthCheckRequested);

    add(
      AuthCheckRequested(),
    ); // Ejecutamos AuthCheckRequest apenas inicie el BLoC
  }

  _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        emit(AuthSuccessState(user));
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthErrorState('Error verificando autenticación'));
    }
  }

  _onLoginRequested(AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

    try {
      final UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(
            email: event.email,
            password: event.password,
          );

      final User? user = userCredential.user;

      if (user != null) {
        _saveUserLocal(userCredential.user!);
        emit(AuthSuccessState(userCredential.user!));
      } else {
        emit(AuthErrorState('Error al ingresar'));
      }
    } on FirebaseAuthException catch (e) {
      _getFirebaseErrorMessage(e);
      emit(AuthErrorState(_getFirebaseErrorMessage(e)));
    } catch (_) {
      emit(AuthErrorState(_getFirebaseErrorMessage('Error al ingresar')));
    }
  }

  _onRegisterAccount(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());

    try {
      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(
            email: event.email,
            password: event.password,
          );

      _saveUserLocal(userCredential.user!);
      emit(AuthSuccessState(userCredential.user!));
    } on FirebaseAuthException catch (e) {
      emit(AuthErrorState(_getFirebaseErrorMessage(e)));
    } catch (_) {
      emit(AuthErrorState('Error al registrar'));
    }
  }

  _saveUserLocal(User user) {
    final userLocal = UserLocal()
      ..uid = user.uid
      ..email = user.email
      ..lastLogin = DateTime.now();
    _isar.writeTxn(() => _isar.userLocals.put(userLocal));
  }

  String _getFirebaseErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'email-already-in-use':
          return 'El correo ya está registrado';
        case 'invalid-email':
          return 'Correo electrónico inválido';
        case 'operation-not-allowed':
          return 'Operación no permitida';
        case 'weak-password':
          return 'Contraseña débil';
        default:
          return 'Error desconocido: ${error.code}';
      }
    }
    return 'Error al registrar: ${error.toString()}';
  }
}
