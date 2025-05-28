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
  final GoogleSignIn _googleSignIn;
  AuthBloc({
    required FirebaseAuth firebaseAuth,
    required Isar isar,
    required GoogleSignIn googleSignIn,
  }) : _firebaseAuth = firebaseAuth,
       _isar = isar,
       _googleSignIn = googleSignIn,
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
    emit(AuthLoadingState());
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    if (googleUser == null) {
      emit(AuthInitial());
      return;
    }

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _firebaseAuth.signInWithCredential(credential);

    await _saveUserLocal(userCredential.user!);

    emit(AuthSuccessState(userCredential.user!));
  }

  _onAccountExist(
    AuthExistCurrentAccount event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final currentUser = _firebaseAuth.currentUser;

      if (currentUser == null) {
        await _clearLocalUser();
        return emit(AuthInitial());
      }

      final isGoogleUser = currentUser.providerData.any(
        (userInfo) => userInfo.providerId == 'google.com',
      );

      if (isGoogleUser) {
        try {
          final token = await currentUser.getIdTokenResult(true);
          if (token.token == null ||
              token.expirationTime!.isBefore(DateTime.now())) {
            await _forceSignOut();
            return emit(AuthInitial());
          }
        } catch (e) {
          await _forceSignOut();
          return emit(AuthInitial());
        }
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
      return emit(AuthErrorState());
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
        emit(AuthSuccessState(user));
      } else {
        emit(AuthInitial());
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

  _onCloseSession(CloseSessionAccount event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

    await _forceSignOut();

    emit(AuthInitial());
  }

  Future<void> _forceSignOut() async {
    await _firebaseAuth.signOut();

    await _googleSignIn.signOut();

    await _clearLocalUser();
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
