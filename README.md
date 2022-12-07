# calendar_schedule

## TODO

- [x] font: notosansKR 추가 themeData 에 font 추가하기

## 패키지

- table_calendar: ^3.0.8 (https://pub.dev/packages/table_calendar)
- intl: ^0.17.0 (https://pub.dev/packages/intl)
- drift: ^2.2.0 (https://pub.dev/packages/drift)

### [flutter] 패키지 다른 버전 사용 오류

- 'pubspec.yaml' 파일 'dependency_overrides' 항목을 추가
- 사용해야하는 버전을 명시한다. (기존에 선언되어있던 곳에서는 뺀다.)

```yaml
dependency_overrides:
  path: ^1.8.2
```

### [flutter] intl 다국어 패키지 사용법

```dart
// intl 패키지 import
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  // 플루터 init 기다리기
  WidgetsFlutterBinding.ensureInitialized();
  // 데이트 포멧 init
  await initializeDateFormatting();
  runApp(const MyApp());
}
```

### [flutter] Column, Row 에서 아이템의 높이 / 넓이 만큼 안의 요소를 확장하는 법, IntrinsicHeight

- `strech` 사용시 높이나 넓이를 구하지 못하는 경우가 있다.
- `IntrinsicHeight` 를 사용

```dart
child: IntrinsicHeight(
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '10:00',
            style: timeTextStyle,
          ),
          Text(
            '12:00',
            style: timeTextStyle.copyWith(
                fontSize: 12, fontWeight: FontWeight.w400),
          ),
        ],
      ),
      SizedBox(
        width: 10,
      ),
      Expanded(
        child: Container(
          // color: Colors.grey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
            child: Text('플루터 공부하기'),
          ),
        ),
      ),
      SizedBox(
        width: 10,
      ),
      Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black,
        ),
      ),
    ],
  ),
),
```

### [flutter] ListView 실전 사용 (위, 아래 여백을 주는 방법)

- 위, 아래 여백을 주는 방법

```dart
class ListViewWithAllSeparators<T> extends StatelessWidget {
  const ListViewWithAllSeparators({Key key, this.items, this.itemBuilder}) : super(key: key);
  final List<T> items;
  final Widget Function(BuildContext context, T item) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: items.length + 2,
      separatorBuilder: (_, __) => Divider(height: 0.5),
      itemBuilder: (context, index) {
        if (index == 0 || index == items.length + 1) {
          return Container(); // zero height: not visible
        }
        return itemBuilder(context, items[index - 1]);
      },
    );
  }
}
```

### [flutter] 플로팅 버튼, 떠있는 버튼 위젯 / FloatingActionButton

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
      // Scaffold 위젯 아래에 삽입
      floatingActionButton: renderFloatingActionButton(),

// 플로팅 버튼 위젯 생성
FloatingActionButton renderFloatingActionButton() {
  return FloatingActionButton(
    onPressed: () {
      print('float');
    },
    child: Icon(Icons.add),
    backgroundColor: Colors.black,
  );
}
```

### [flutter] 시스템 기본 UI가 차지하는 높이 구하기

- `MediaQuery.of(context).viewInsets` 를 사용

```dart
// 기본 UI 가 차지하는 높이
final bottomInset = MediaQuery.of(context).viewInsets.bottom;
```

### [flutter] bottom 다이얼로그 아래 / showModalBottomSheet 기본 사용법

```dart
 onPressed: () {
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // 기본: false, 기본일 경우 최대 높이가 전체 높이의 50%, true 일 경우 전체 높이 100%
      builder: (context) {
        // 기본 UI 가 차지하는 높이
        final bottomInset = MediaQuery.of(context).viewInsets.bottom;
        return Container(
          // 디바이스 높이 / 2 + 기본 시스템 UI 높이
          height: MediaQuery.of(context).size.height / 2 + bottomInset,
          // 기본 시스템 UI 높이만큼 패딩 bottom 부여
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomInset),
            child: TextField(),
          ),
        );
      },
    );
  },
```

### [flutter] TextField 기본 사용법

- 부모 위젯에 onTap 으로 blur 이벤트를 넣어준다.

```dart
GestureDetector(
  onTap: () {
    // 포커스되어있는 텍스트필드 해제하기
    FocusScope.of(context).requestFocus(FocusNode());
  },
```

- 텍스트필드 위젯

```dart
TextField(
    cursorColor: Colors.black, // 커서 색상
    maxLines: null, // 줄수, null 부여시 텍스트가 줄바꿈이 될때마다 무한이 내려감.
    keyboardType: TextInputType.number, // 키보드 타입을 선택 (기본: multiline)
    expands: true, // 세로로 최대한 늘려줌.
    inputFormatters: [
      FilteringTextInputFormatter.digitsOnly, // 숫자만 입력되도록 설정
    ],
    decoration: InputDecoration(
        border: InputBorder.none, // 아래 줄을 없앰
        filled: true, // input 영역에 배경색
        fillColor: Color(0xffeeeeee),
    ),
),
```

### [flutter] 한줄에 넘치는 아이템 배치 wrap

```dart
Wrap(
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
```

### [flutter] import, part 차이 / private 값 import

- `import`: private 값은 불러올 수 없다.
- `part`: private 값도 모두 불러온다.

```dart
// private 값은 불러올 수 없다.
import 'package:drift/drift.dart';

// private 값도 모두 불러온다.
part 'drift_database.g.dart';
```

### [flutter] flutter 코드 제너레이션 code generation 명령어

```shell
flutter pub run build_runner build
```

### [flutter] TextField, TextFormField

## TextField

- 가장기본적인 텍스트 위젯
- 폼과 같이 사용하는게 편하므로 거의 사용하지 않을듯.

```dart
TextField(
  // onChaged 함수 값을 가져오는데 사용
  onChanged: (value) {
    print(value);
  },
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
```

## TextFormField

- TextField 에서 추가적인 기능을 가지고 있는 위젯
- Form 과 같이 사용하기위해서는 TextFormField 를 사용한다.
- validator 라는 이벤트를 사용 할 수 있다.

### Form

- StateFull 로 위젯을 변경하고 Form 키를 생성한다.

```dart
class _BottomSheetComponentState extends State<BottomSheetComponent> {
  // Form 에 넣을 키
  final GlobalKey<FormState> formKey = GlobalKey();
```

- `TextFormField` 를 `Form` 으로 감싸준다.

```dart
  child: Form(
    key: formKey,
    child: Column(
```

### [flutter] 형변환 (타입 확인)

- 타입 확인

```dart
print(time.runtimeType);
```

- String -> int

```dart
// 스트링을 int 로 변경
int time = int.parse(value);
```