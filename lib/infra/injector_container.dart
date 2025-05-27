import 'package:finsavvy/firebase_options.dart';
import 'package:finsavvy/models/user_local.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../features/auth/components/blocs/auth_bloc/bloc/auth_bloc.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  final dir = await getApplicationDocumentsDirectory();

  // Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  getIt.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);

  // Isar
  final isar = await Isar.open([UserLocalSchema], directory: dir.path);
  getIt.registerSingleton<Isar>(isar);

  // BLoC
  getIt.registerFactory(() => AuthBloc(firebaseAuth: getIt(), isar: getIt()));
}
