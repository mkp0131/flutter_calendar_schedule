import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  bool? isTxt;

  CustomTextField({
    required this.label,
    this.isTxt,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(isTxt);
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
        isTxt! ? Expanded(child: renderTextField()) : renderTextField(),
      ],
    );
  }

  Widget renderTextField() {
    return TextField(
      cursorColor: Colors.black, // 커서 색상
      maxLines: isTxt! ? null : 1, // 줄수, null 부여시 텍스트가 줄바꿈이 될때마다 무한이 내려감.
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
      ),
    );
  }
}
