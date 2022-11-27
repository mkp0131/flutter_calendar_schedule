import 'package:calendar_schedule/component/calendar_componenet.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: CalendarComponent(),
        ),
      ),
    );
  }
}
