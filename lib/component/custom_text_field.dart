import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  bool? isTxt;
  final FormFieldSetter onSaved;
  final String initialValue;

  CustomTextField({
    required this.label,
    required this.onSaved,
    this.isTxt,
    required this.initialValue,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isTxt == null) {
      isTxt = false;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        isTxt!
            ? Expanded(
                child: renderTextField(
                onSaved: onSaved,
                initialValue: initialValue,
              ))
            : renderTextField(
                onSaved: onSaved,
                initialValue: initialValue,
              ),
      ],
    );
  }

  Widget renderTextField({required onSaved, required String initialValue}) {
    return TextFormField(
      // 값을 저장할때 사용하는 이벤트
      onSaved: onSaved,
      // 에러가 있으면 String 값을 리턴해준다.
      // 에러가 없을 경우 null
      // 리턴된 값은 텍스트 필드 바로 밑에 자동으로 출력된다.
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '값을 입력해주세요.';
        }

        // 텍스트 일경우
        if (!isTxt!) {
          // 스트링을 int 로 변경
          int time = int.parse(value);
          if (time < 0) {
            return '0 이상 입력해주세요.';
          }
          if (time > 24) {
            return '24 이하 입력해주세요.';
          }
        }

        return null;
      },
      // autovalidateMode:
      //     AutovalidateMode.always, // 모든 이벤트에 항상 validator 실행, 처음 init 시에도 자동실행
      // onChaged 함수 값을 가져오는데 사용
      onChanged: (value) {
        // print(value);
      },
      initialValue: initialValue,
      cursorColor: Colors.black, // 커서 색상
      maxLines: isTxt! ? null : 1, // 줄수, null 부여시 텍스트가 줄바꿈이 될때마다 무한이 내려감.
      maxLength: 500, // 글자수 제한, 글자수 카운트 UI 도 같이 생성된다.
      expands: isTxt! ? true : false, // 세로로 최대한 늘려줌.
      keyboardType: isTxt!
          ? TextInputType.multiline
          : TextInputType.number, // 키보드 타입을 선택 (기본: multiline)
      inputFormatters: isTxt!
          ? []
          : [
              FilteringTextInputFormatter.digitsOnly, // 숫자만 입력되도록 설정
            ],
      decoration: InputDecoration(
        border: InputBorder.none, // 아래 줄을 없앰
        filled: true, // input 영역에 배경색
        fillColor: Color(0xffeeeeee),
        suffix: isTxt! ? null : Text('시'),
      ),
    );
  }
}
