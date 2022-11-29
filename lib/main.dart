import 'package:calendar_schedule/screen/home_screen.dart';
import 'package:flutter/material.dart';
// intl 패키지 import
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  // 플루터 init 기다리기
  WidgetsFlutterBinding.ensureInitialized();
  // 데이트 포멧 init
  await initializeDateFormatting();
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
