import 'package:calendar_schedule/component/calendar_componenet.dart';
import 'package:calendar_schedule/component/custom_text_field.dart';
import 'package:calendar_schedule/component/schedule_card.dart';
import 'package:calendar_schedule/component/today_banner.dart';
import 'package:calendar_schedule/const/colors.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDay = DateTime(
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
            _ScheduleList(),
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
            // 기본 UI 가 차지하는 높이
            final bottomInset = MediaQuery.of(context).viewInsets.bottom;
            return GestureDetector(
              onTap: () {
                // 포커스되어있는 텍스트필드 해제하기
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: SafeArea(
                child: Container(
                  color: Colors.white,
                  // 디바이스 높이 / 2 + 기본 시스템 UI 높이
                  height: MediaQuery.of(context).size.height / 2 + bottomInset,
                  // 기본 시스템 UI 높이만큼 패딩 bottom 부여
                  child: Padding(
                    padding: EdgeInsets.only(bottom: bottomInset),
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: 0,
                        top: 20,
                        left: 10,
                        right: 10,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(label: '시작 시간'),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: CustomTextField(label: '종료 시간'),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: CustomTextField(
                              label: '내용',
                              isTxt: true,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          _ColorPicker(),
                          SizedBox(
                            height: 15,
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            child: Text('저장'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: PRIMARY_COLOR,
                              padding: EdgeInsets.all(15),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
      child: Icon(Icons.add),
      backgroundColor: Colors.black,
    );
  }
}

class _ColorPicker extends StatelessWidget {
  const _ColorPicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // 한줄에 넘치는 아이템을 배치
      child: Wrap(
        spacing: 8, // 가로 gap
        runSpacing: 8, // 세로 gap
        children: [
          renderColor(color: Colors.red),
          renderColor(color: Colors.orange),
          renderColor(color: Colors.yellow),
          renderColor(color: Colors.green),
          renderColor(color: Colors.blue),
          renderColor(color: Colors.indigo),
          renderColor(color: Colors.purple),
          renderColor(color: Colors.black),
        ],
      ),
    );
  }

  Widget renderColor({required Color color}) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _ScheduleList extends StatelessWidget {
  const _ScheduleList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView.separated(
          itemCount: 100,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Container(); // zero height: not visible
            }
            return ScheduleCard(
              color: Colors.red,
              startTime: 9,
              endTime: 12,
              txt: '플루터 공부 ${index}',
            );
          },
          separatorBuilder: (context, index) => SizedBox(
            height: 10,
          ),
        ),
      ),
    );
  }
}
