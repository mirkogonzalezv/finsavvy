import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
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
}
