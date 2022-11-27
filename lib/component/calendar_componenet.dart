import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarComponent extends StatefulWidget {
  const CalendarComponent({Key? key}) : super(key: key);

  @override
  State<CalendarComponent> createState() => _CalendarComponentState();
}

class _CalendarComponentState extends State<CalendarComponent> {
  DateTime? selectedDay;

  @override
  Widget build(BuildContext context) {
    // 테이블 캘린더 패키지
    return TableCalendar(
        focusedDay: DateTime.now(), // 처음 init 되는 날짜
        firstDay: DateTime(1700), // 달력 시작 날짜
        lastDay: DateTime(3200), // 달력 종료 날짜
        // 달력 헤더 style
        headerStyle: HeaderStyle(
          formatButtonVisible: false, // 날짜를 얼마나 보여줄지 옵션 버튼 false
          titleCentered: true, // 날짜위치를 가운데로!
          // 날짜의 폰트 Style
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        // 날짜 선택 이벤트
        onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
          print(selectedDay);
          setState(() {
            this.selectedDay = selectedDay;
          });
        },
        // ✅ 날짜 선택 표시
        // 날짜 선택되었을시 기존과 다르다는 것 판단 기준
        // false: 선택안됨, true: 선택됨
        selectedDayPredicate: (DateTime day) {
          if (selectedDay == null) {
            return false;
          }

          return day.year == selectedDay!.year &&
              day.month == selectedDay!.month &&
              day.day == selectedDay!.day;
        });
  }
}
