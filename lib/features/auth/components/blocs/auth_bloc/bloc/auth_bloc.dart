import 'dart:developer';

import 'package:finsavvy/models/user_local.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
    on<AuthExistCurrentAccount>(_onAccountExist);
    on<CloseSessionAccount>(_onCloseSession);
    on<AuthWithGoogleAccount>(_authWithGoogleAccount);

    add(AuthExistCurrentAccount());
  }

  _authWithGoogleAccount(
    AuthWithGoogleAccount event,
    Emitter<AuthState> emit,
  ) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final firebaseAuth = await FirebaseAuth.instance.signInWithCredential(
      credential,
    );

    log("Login With Google");
    log(firebaseAuth.toString());
    log("Login With Google");
  }

  _onAccountExist(
    AuthExistCurrentAccount event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final currentUser = _firebaseAuth.currentUser;

      if (currentUser == null) {
        return emit(AuthInitial());
      }

      final userLocal = await _isar.userLocals
          .filter()
          .uidEqualTo(currentUser.uid)
          .findFirst();

      if (userLocal == null) {
        await _saveUserLocal(currentUser);
      }

      return emit(AuthSuccessState(currentUser));
    } catch (e) {
      return emit(AuthErrorState(e.toString()));
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
        emit(AuthInitial());
      }
    } on FirebaseAuthException catch (e) {
      e;
      emit(AuthErrorState(""));
    } catch (_) {
      emit(AuthErrorState('Error al ingresar'));
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
      emit(AuthErrorState(""));
    } catch (_) {
      emit(AuthErrorState('Error al registrar'));
    }
  }

  _onCloseSession(CloseSessionAccount event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

    await _firebaseAuth.signOut();

    await _clearLocalUser();

    emit(AuthInitial());
  }

  _saveUserLocal(User user) async {
    final userLocal = UserLocal()
      ..uid = user.uid
      ..email = user.email
      ..lastLogin = DateTime.now();
    _isar.writeTxn(() => _isar.userLocals.put(userLocal));
  }

  _clearLocalUser() async {
    await _isar.writeTxn(() async {
      await _isar.userLocals.clear();
    });
  }
}
