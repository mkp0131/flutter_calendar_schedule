import 'package:calendar_schedule/component/custom_text_field.dart';
import 'package:calendar_schedule/const/colors.dart';
import 'package:calendar_schedule/database/drift_database.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

typedef ColorIdSetter = void Function(int id);

class BottomSheetComponent extends StatefulWidget {
  final DateTime selectedDay;
  final int? scheduleId;

  const BottomSheetComponent({
    required this.selectedDay,
    this.scheduleId,
    Key? key,
  }) : super(key: key);

  @override
  State<BottomSheetComponent> createState() => _BottomSheetComponentState();
}

class _BottomSheetComponentState extends State<BottomSheetComponent> {
  // Form 에 넣을 키
  final GlobalKey<FormState> formKey = GlobalKey();
  int? startTime;
  int? endTime;
  String? content;
  int? selectedColorId;

  @override
  Widget build(BuildContext context) {
    // 기본 UI 가 차지하는 높이
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return GestureDetector(
      onTap: () {
        // 포커스되어있는 텍스트필드 해제하기
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: FutureBuilder<Schedule>(
          future: widget.scheduleId == null
              ? null
              : GetIt.I<LocalDatabase>().getSchedule(widget.scheduleId!),
          builder: (context, snapshot) {
            // 에러가있을시
            if (snapshot.hasError) {
              return Center(
                child: Text('스케줄을 불러올 수 없습니다.'),
              );
            }

            // ConnectionState none 이 아닌지확인(future가 null 이라면 none으로 들어온다.)
            // hasData 가 없다면 -> 즉, 처음 로딩인지 확인
            if (snapshot.connectionState != ConnectionState.none &&
                !snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            // 데이터가 있고 ✅ 이미 startTime 이라는 값을 가지고 있을경우(2중 실행 방지)
            if (snapshot.hasData && startTime == null) {
              // 위젯이 그려지기전에 state 에 값을 부여했기에 setState 가 필요하지 않다.
              startTime = snapshot.data!.startTime;
              endTime = snapshot.data!.endTime;
              content = snapshot.data!.content;
              selectedColorId = snapshot.data!.colorId;
            }

            return SafeArea(
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
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  label: '시작 시간',
                                  onSaved: (val) {
                                    startTime = int.parse(val);
                                  },
                                  initialValue: startTime?.toString() ??
                                      '', // 위젯 실행시 한번만 세팅이된다.
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: CustomTextField(
                                  label: '종료 시간',
                                  onSaved: (val) {
                                    endTime = int.parse(val);
                                  },
                                  initialValue: endTime?.toString() ?? '',
                                ),
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
                              onSaved: (val) {
                                content = val;
                              },
                              initialValue: content ?? '',
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          FutureBuilder(
                            // GetIt을 사용하여 인스턴스 사용
                            future:
                                GetIt.I<LocalDatabase>().getCategoryColors(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else {
                                if (selectedColorId == null) {
                                  selectedColorId = snapshot.data![0].id;
                                }

                                return _ColorPicker(
                                  colors: snapshot.data!,
                                  selectedColorId: selectedColorId,
                                  onSelectedColor: (id) {
                                    setState(() {
                                      selectedColorId = id;
                                    });
                                  },
                                );
                              }
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              // formKey는 있지만 Form 위젯에 넣어주지 않은 상태
                              if (formKey.currentState == null) {
                                return;
                              }

                              // formKey.currentState.validate()
                              // - TextFormField 의 validator 함수를 모두 실행한다.
                              if (formKey.currentState!.validate()) {
                                // ✅ 에러가 없을 경우에는 formKey 를 save 한다.
                                formKey.currentState!.save();

                                if (widget.scheduleId == null) {
                                  final queryKey =
                                      await GetIt.I<LocalDatabase>()
                                          .createSchedule(
                                    SchedulesCompanion(
                                      startTime: Value(startTime!),
                                      endTime: Value(endTime!),
                                      content: Value(content!),
                                      date: Value(widget.selectedDay),
                                      colorId: Value(selectedColorId!),
                                    ),
                                  );
                                } else {
                                  await GetIt.I<LocalDatabase>().updateSchedule(
                                    widget.scheduleId!,
                                    SchedulesCompanion(
                                      startTime: Value(startTime!),
                                      endTime: Value(endTime!),
                                      content: Value(content!),
                                      date: Value(widget.selectedDay),
                                      colorId: Value(selectedColorId!),
                                    ),
                                  );
                                }

                                Navigator.of(context).pop();
                              } else {
                                print('에러가 있습니다.');
                              }
                            },
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
          }),
    );
  }
}

class _ColorPicker extends StatelessWidget {
  final List colors;
  final int? selectedColorId;
  final ColorIdSetter onSelectedColor;
  const _ColorPicker({
    required this.colors,
    required this.selectedColorId,
    required this.onSelectedColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // 한줄에 넘치는 아이템을 배치
      child: Wrap(
        spacing: 8, // 가로 gap
        runSpacing: 8, // 세로 gap
        children: colors
            .map(
              (color) => GestureDetector(
                onTap: () {
                  onSelectedColor(color.id);
                },
                child: renderColor(
                  color: Color(
                    int.parse(
                      'FF${color.hexCode}',
                      radix: 16,
                    ),
                  ),
                  isSelected: selectedColorId == color.id,
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget renderColor({required Color color, required bool isSelected}) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: isSelected ? Border.all(width: 3, color: Colors.black) : null,
      ),
    );
  }
}
