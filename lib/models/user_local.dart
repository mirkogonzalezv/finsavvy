import 'package:isar/isar.dart';

part 'user_local.g.dart';

@collection
class UserLocal {
  Id id = Isar.autoIncrement;
  @Index()
  String? uid;
  String? email;
  DateTime? lastLogin;
}
