import 'package:finsavvy/models/user_local.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../features/auth/components/blocs/auth_bloc/bloc/auth_bloc.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  final dir = await getApplicationDocumentsDirectory();

  // Firebase
  getIt.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);

  // Isar
  final isar = await Isar.open([UserLocalSchema], directory: dir.path);
  getIt.registerSingleton<Isar>(isar);

  // Google Sign In
  getIt.registerLazySingleton(() => GoogleSignIn.standard());

  // BLoC
  getIt.registerFactory(
    () => AuthBloc(firebaseAuth: getIt(), isar: getIt(), googleSignIn: getIt()),
  );
}
