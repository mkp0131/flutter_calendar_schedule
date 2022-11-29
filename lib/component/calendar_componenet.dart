import 'package:calendar_schedule/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarComponent extends StatelessWidget {
  final DateTime selectedDay; // 선택 날짜, 액티브 되는 날짜, 처음에 값을 넣어주면 그날짜로 init
  final DateTime focusedDay;
  final OnDaySelected onDaySelected;

  CalendarComponent({
    required this.selectedDay,
    required this.focusedDay,
    required this.onDaySelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 달력 Day 기본 스타일 설정
    final defaultDayStyle = BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(6.0),
    );
    final defaultDayTextStyle = TextStyle(
      color: Colors.grey,
    );

    // 테이블 캘린더 패키지
    return TableCalendar(
        locale: 'ko_KR', // 한글로 언어 변경
        focusedDay: focusedDay, // 달력이 포커스되어있는 달
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
          // left Arrow
          leftChevronIcon: Icon(
            Icons.chevron_left,
            color: Colors.black,
          ),
          // right Arrow
          rightChevronIcon: Icon(
            Icons.chevron_right,
            color: Colors.black,
          ),
        ),
        // 달력 스타일
        calendarStyle: CalendarStyle(
          isTodayHighlighted: false, // 오늘 하이라이트 (기본값 true)
          defaultDecoration: defaultDayStyle, // 주중 기본 스타일 설정 (박스)
          weekendDecoration: defaultDayStyle, // 주말 기본 스타일 설정 (박스)
          // 선택한 Day 스타일 설정 (박스)
          selectedDecoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(color: PRIMARY_COLOR, width: 1),
          ),
          defaultTextStyle: defaultDayTextStyle, // 주중 기본 스타일 설정 (텍스트)
          weekendTextStyle: defaultDayTextStyle, // 주중 기본 스타일 설정 (텍스트)
          // 선택한 Day 스타일 설정 (텍스트)
          selectedTextStyle: TextStyle(
            color: PRIMARY_COLOR,
            fontWeight: FontWeight.w700,
          ),
          outsideDecoration: BoxDecoration(
            // 박스의 아웃라인 스타일
            shape: BoxShape.rectangle,
          ),
        ),
        // 날짜 선택 이벤트
        onDaySelected: onDaySelected,
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
