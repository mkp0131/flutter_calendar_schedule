import 'dart:io';
import 'package:calendar_schedule/model/schedule_with_color.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:calendar_schedule/model/schedule.dart';
import 'package:calendar_schedule/model/category_color.dart';
import 'package:path/path.dart' as p;

// private 값도 모두 불러온다.
part 'drift_database.g.dart';

// 데이터 베이스 객체를 만들 스키마 import
@DriftDatabase(
  tables: [
    Schedules,
    CategoryColors,
  ],
)
// 만들어진 데이터 베이스 객체로 쿼리 생성
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  // schedules 테이블에 데이터를 넣고, PRIMARY_KEY 를 return 받는다.
  Future<int> createSchedule(SchedulesCompanion data) =>
      into(schedules).insert(data);

  // schedule row select
  Future<Schedule> getSchedule(int id) =>
      (select(schedules)..where((tbl) => tbl.id.equals(id))).getSingle();

  // schedule row 삭제
  Future<int> removeSchedule(int id) =>
      (delete(schedules)..where((tbl) => tbl.id.equals(id))).go();

  Future<int> updateSchedule(
    int id,
    SchedulesCompanion data,
  ) =>
      (update(schedules)..where((tbl) => tbl.id.equals(id))).write(data);

  // categoryColors 테이블에 데이터를 넣고, PRIMARY_KEY 를 return 받는다.
  Future<int> createCategoryColor(CategoryColorsCompanion data) =>
      into(categoryColors).insert(data);

  // categoryColors 테이블 get
  Future<List<CategoryColor>> getCategoryColors() =>
      select(categoryColors).get();

  // 지속적으로 업데이트된 schedule 보기
  Stream<List<ScheduleWithColor>> watchSchedules(DateTime selectedDay) {
    final query = select(schedules).join([
      innerJoin(categoryColors, categoryColors.id.equalsExp(schedules.colorId))
    ]);

    query.where(schedules.date.equals(selectedDay));

    query.orderBy([OrderingTerm.asc(schedules.startTime)]);

    // ScheduleWithColor 타입으로 맵핑을 해야한다.
    return query.watch().map(
          (rows) => rows
              .map(
                (row) => ScheduleWithColor(
                  schedule: row.readTable(schedules),
                  categoryColor: row.readTable(categoryColors),
                ),
              )
              .toList(),
        );

    // 축약을 이용해서 한줄로도 표현 가능
    // return (select(schedules)..where((tbl) => tbl.date.equals(selectedDay)))
    //     .watch();
  }

  // 스키마 버전 정의
  @override
  int get schemaVersion => 1;
}

// 데이터베이스 연결 / 저장
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    // 운영체제가 자동으로 할당한 저장가능한 폴더 위치
    // path_provider 패키지의 getApplicationDocumentsDirectory() 함수
    final dbFolder = await getApplicationDocumentsDirectory();
    // 해당경로에 `db.sqlite` 파일 생성
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
