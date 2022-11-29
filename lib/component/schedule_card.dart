import 'package:flutter/material.dart';

class ScheduleCard extends StatelessWidget {
  final int startTime;
  final int endTime;
  final String txt;
  final Color color;

  const ScheduleCard({
    required this.startTime,
    required this.endTime,
    required this.txt,
    required this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeTextStyle = TextStyle(
      fontWeight: FontWeight.w900,
      fontSize: 16,
    );

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: Colors.black,
            width: 1,
          )),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${startTime.toString().padLeft(2, '0')}:00',
                    style: timeTextStyle,
                  ),
                  Text(
                    '${endTime.toString().padLeft(2, '0')}:00',
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
                    child: Text(txt),
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
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
