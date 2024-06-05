import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:namaz_timing_app/mvvm/view_model/utils/color/color.dart';
import 'package:namaz_timing_app/mvvm/view_model/utils/styles/themeText.dart';

class HomeWidget extends StatelessWidget {
  final String prayerName;
  final String prayerTime;

  const HomeWidget({
    required this.prayerName,
    required this.prayerTime,
    super.key,
  });

  String _convertTo12HourFormat(String time) {
    final parts = time.split(':');
    int hour = int.parse(parts[0]);
    final minute = parts[1];
    final period = hour >= 12 ? 'PM' : 'AM';

    hour = hour % 12;
    if (hour == 0) hour = 12;

    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: ColorsTheme().white,
      margin: const EdgeInsets.symmetric(vertical: 3,horizontal: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        isThreeLine: false,
        horizontalTitleGap: 20,
        minVerticalPadding: 20,
        leading: Icon(Icons.access_time, color: ColorsTheme().primaryColor,size: 20.sp,),
        title: Text(prayerName, style: ThemeTexts.textStyleTitle8),
        trailing: Text(_convertTo12HourFormat(prayerTime), style: ThemeTexts.textStyleTitle8),
      ),
    );
  }
}