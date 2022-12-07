import 'package:calendar_schedule/component/custom_text_field.dart';
import 'package:calendar_schedule/const/colors.dart';
import 'package:flutter/material.dart';

class BottomSheetComponent extends StatefulWidget {
  const BottomSheetComponent({Key? key}) : super(key: key);

  @override
  State<BottomSheetComponent> createState() => _BottomSheetComponentState();
}

class _BottomSheetComponentState extends State<BottomSheetComponent> {
  // Form 에 넣을 키
  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
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
              child: Form(
                key: formKey,
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
                      onPressed: () {
                        // formKey는 있지만 Form 위젯에 넣어주지 않은 상태
                        if (formKey.currentState == null) {
                          return;
                        }

                        // formKey.currentState.validate()
                        // - TextFormField 의 validator 함수를 모두 실행한다.
                        if (formKey.currentState!.validate()) {
                          print('에러가 없습니다.');
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
      ),
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
