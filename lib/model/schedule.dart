import 'package:drift/drift.dart';

// 스케줄 스키마 생성
class Schedules extends Table {
  // id (PRIMARY_KEY, AUTOINCREMENT)
  IntColumn get id => integer().autoIncrement()();

  // content
  TextColumn get content => text()();

  // 일정 날짜
  DateTimeColumn get date => dateTime()();

  // 시작시간
  IntColumn get startTime => integer()();

  // 종료시간
  IntColumn get endTime => integer()();

  // 색상 테이블 ID
  IntColumn get colorId => integer()();

  // 등록일시 (clientDefault 로 기본값 넣기)
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
}
