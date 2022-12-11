import 'package:calendar_schedule/component/bottom_sheet.dart';
import 'package:calendar_schedule/component/calendar_componenet.dart';
import 'package:calendar_schedule/component/custom_text_field.dart';
import 'package:calendar_schedule/component/schedule_card.dart';
import 'package:calendar_schedule/component/today_banner.dart';
import 'package:calendar_schedule/const/colors.dart';
import 'package:calendar_schedule/database/drift_database.dart';
import 'package:calendar_schedule/model/schedule_with_color.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDay = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime focusedDay = DateTime.now();
  onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      this.selectedDay = selectedDay;
      this.focusedDay = selectedDay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: renderFloatingActionButton(),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CalendarComponent(
              focusedDay: focusedDay,
              selectedDay: selectedDay,
              onDaySelected: onDaySelected,
            ),
            SizedBox(
              height: 10,
            ),
            TodayBanner(selectedDay: selectedDay),
            _ScheduleList(selectedDay: selectedDay),
          ],
        ),
      ),
    );
  }

  FloatingActionButton renderFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled:
              true, // 기본: false, 기본일 경우 최대 높이가 전체 높이의 50%, true 일 경우 전체 높이 100%
          builder: (context) {
            return BottomSheetComponent(
              selectedDay: selectedDay,
            );
          },
        );
      },
      child: Icon(Icons.add),
      backgroundColor: Colors.black,
    );
  }
}

class _ScheduleList extends StatelessWidget {
  final DateTime selectedDay;

  const _ScheduleList({
    required this.selectedDay,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: StreamBuilder<List<ScheduleWithColor>>(
            stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDay),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              // 데이터가 없을시
              if (snapshot.hasData && snapshot.data!.isEmpty) {
                return Center(child: Text('스케줄이 없습니다.'));
              }

              final filterSchedules = snapshot.data!;

              return ListView.separated(
                itemCount: filterSchedules.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Container(); // zero height: not visible
                  }

                  final scheduleWithColor = filterSchedules[index - 1];

                  // Dismissible 좌우방향으로 스크롤시 위젯을 없앤다.
                  return Dismissible(
                    key: ObjectKey(
                        scheduleWithColor.schedule.id), // 유니크 ID를 넣어준다.
                    direction: DismissDirection.endToStart, // 스크롤 방향
                    onDismissed: (direction) {
                      GetIt.I<LocalDatabase>()
                          .removeSchedule(scheduleWithColor.schedule.id);
                    }, // 스크롤이 끝까지 되었을시 이벤트
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled:
                              true, // 기본: false, 기본일 경우 최대 높이가 전체 높이의 50%, true 일 경우 전체 높이 100%
                          builder: (context) {
                            return BottomSheetComponent(
                              selectedDay: selectedDay,
                              scheduleId: scheduleWithColor.schedule.id,
                            );
                          },
                        );
                      },
                      child: ScheduleCard(
                        color: Color(int.parse(
                            'FF${scheduleWithColor.categoryColor.hexCode}',
                            radix: 16)),
                        startTime: scheduleWithColor.schedule.startTime,
                        endTime: scheduleWithColor.schedule.endTime,
                        txt: scheduleWithColor.schedule.content,
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(
                  height: 10,
                ),
              );
            }),
      ),
    );
  }
}
