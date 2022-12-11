import 'package:calendar_schedule/const/colors.dart';
import 'package:calendar_schedule/database/drift_database.dart';
import 'package:calendar_schedule/model/schedule_with_color.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class TodayBanner extends StatelessWidget {
  DateTime selectedDay;
  TodayBanner({
    required this.selectedDay,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${selectedDay.year}년 ${selectedDay.month}월 ${selectedDay.day}일',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            StreamBuilder<List<ScheduleWithColor>>(
                stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDay),
                builder: (context, snapshot) {
                  int count = 0;

                  if (snapshot.hasData) {
                    count = snapshot.data!.length;
                  }

                  return Text(
                    '$count개',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
