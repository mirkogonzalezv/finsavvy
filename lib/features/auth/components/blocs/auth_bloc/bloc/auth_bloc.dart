import 'dart:developer';

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
        emit(AuthSuccessState(user));
      } else {
        emit(AuthErrorState());
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log("Password muy debil");
      } else if (e.code == 'email-already-in-use') {
        log('El email ya existe en nuestros registros');
      }
      emit(AuthErrorState());
    } catch (_) {
      emit(AuthErrorState());
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
      log(e.code);
    } catch (_) {
      emit(AuthErrorState());
    }
  }

  _saveUserLocal(User user) {
    final userLocal = UserLocal()
      ..uid = user.uid
      ..email = user.email
      ..lastLogin = DateTime.now();
    _isar.writeTxn(() => _isar.userLocals.put(userLocal));
  }
}
