import 'package:calendar_schedule/database/drift_database.dart';
import 'package:calendar_schedule/screen/home_screen.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
// intl 패키지 import
import 'package:intl/date_symbol_data_local.dart';

const DEFAULT_COLORS = [
  // 빨강
  'F44336',
  // 주황
  'FF9800',
  // 노랑
  'FFEB3B',
  // 초록
  'FCAF50',
  // 파랑
  '2196F3',
  // 남
  '3F51B5',
  // 보라
  '9C27B0',
];

void main() async {
  // 플루터 init 기다리기
  WidgetsFlutterBinding.ensureInitialized();
  // 데이트 포멧 init
  await initializeDateFormatting();

  // 데이터 베이스 연결
  final database = LocalDatabase();
  final colors = await database.getCategoryColors();

  if (colors.isEmpty) {
    for (String hexCode in DEFAULT_COLORS) {
      await database.createCategoryColor(CategoryColorsCompanion(
        hexCode: Value(hexCode),
      ));
    }
  }

  print('--------------COlORS---------------');
  print(await database.getCategoryColors());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        fontFamily: 'NotoSansKR',
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
