import 'package:drift/drift.dart';

class CategoryColors extends Table {
  // id
  IntColumn get id => integer().autoIncrement()();

  // 색상 HEX Code
  TextColumn get hexCode => text()();
}
