import 'package:isar/isar.dart';

part 'transaction.g.dart';

@collection
class Transaction {
  Id id = Isar.autoIncrement;

  @Index()
  DateTime? date;

  double? amount;

  @Index()
  String? category;

  String? description;

  @Index()
  bool? isExpense; //true=gasto; false=ingreso

  String? attachmentUrl;
}
