import 'package:namaz_timing_app/mvvm/view_model/utils/color/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReusableWidgets {

  static Widget dummyWidget({
    required Function() onPress,
    required String text,
  }) {
    return InkWell(
      splashColor: ColorsTheme().pink,
      borderRadius: BorderRadius.circular(10),
      onTap: (){
        onPress();
      },
      child: SizedBox(child: Text(text),),
    );
  }

  static Widget defaultAppButton({
    required Function() onPress,
    required String text,
    required Color bgColor,
    required Color textColor,
  }){
    return Theme(
      data: ThemeData.light(useMaterial3: false),
      child: SizedBox(
        width: 0.22.sh,
        height: 40.sp,
        child: ElevatedButton(
          onPressed: (){
            HapticFeedback.lightImpact();
            onPress();
          },
          style: ElevatedButton.styleFrom(
            elevation: 2,
            backgroundColor: bgColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(
            text,textAlign: TextAlign.center,
            maxLines: 1,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
              color: textColor,
              fontFamily: "OpenSansBold",),
          ),
        ),
      ),
    );
  }

  static Widget transparentTextButton({
    required Function() onPress,
    required String text,
    required Color bgColor,
    required Color textColor,
  }){
    return Theme(
      data: ThemeData.light(useMaterial3: false),
      child: Material(
        borderRadius: BorderRadius.circular(30),
        color: ColorsTheme().transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          splashColor: bgColor,
          onTap: () {
            HapticFeedback.lightImpact();
            onPress();
          },
          child: Container(
            width: 0.3.sh,
            height: 0.06.sh,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.normal,
                  color: textColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBarGetX({
    required String title,
    required BuildContext context,
  }) {
    final AnimationController controller = AnimationController(
      vsync: ScaffoldMessenger.of(context),
      duration: const Duration(milliseconds: 500),
    );
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          height: 20,
          alignment: Alignment.center,
          child: Text(title, textAlign: TextAlign.center,style: const TextStyle(fontFamily: "OpenSansBold",fontSize: 10)),
        ),
        behavior: SnackBarBehavior.fixed,
        duration: const Duration(milliseconds: 1200),
        backgroundColor: ColorsTheme().primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 3),
        elevation: 1,
        dismissDirection: DismissDirection.horizontal,
        animation: CurvedAnimation(parent: controller, curve: Curves.bounceInOut),
      ),
    );
  }

/*  static toastMessage({
    required String title,
  }) {
    return Fluttertoast.showToast(
        msg: title,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }*/

}