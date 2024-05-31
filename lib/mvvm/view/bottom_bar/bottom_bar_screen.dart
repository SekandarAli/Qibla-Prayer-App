// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:namaz_timing_app/mvvm/view_model/controller/bottom_bar/bottom_bar_controller.dart';
import '../../view_model/utils/color/color.dart';
import '../../view_model/utils/styles/themeText.dart';
import '../home/screen/home_screen.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({super.key});

  @override
  _BottomBarScreenState createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  BottomBarController bottomBarController = Get.put(BottomBarController());
  late PageController _pageController;
  DateTime? currentBackPressTime;

  final List<Widget> pages = [
    HomeScreen(),
    Container(),
    Container(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _pageController =
        PageController(initialPage: bottomBarController.selectedIndex.value);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pageController.dispose();
    super.dispose();
  }

  void changePage(int index) {
    HapticFeedback.lightImpact();
    bottomBarController.selectedIndex.value = index;
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 5),
      curve: Curves.easeInOut,
    );
  }

  void _onPopScope(bool value) async {
    if (bottomBarController.selectedIndex.value != 0) {
      changePage(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked : _onPopScope,
      child: Scaffold(
        backgroundColor: ColorsTheme.backgroundColor,
        body: SafeArea(
          top: true,
          child: Column(
            children: [
              Obx(() {
                return Padding(
                  padding: EdgeInsets.only(left: 15.sp, right: 15.sp, bottom: 15.sp, top: 0.sh),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                bottomBarController.selectedIndex.value == 0 ?
                                "Home".tr : bottomBarController.selectedIndex.value == 1 ?
                                "Mosque".tr : "Setting".tr,
                                style: ThemeTexts.textStyleTitle7.copyWith(
                                  fontFamily: "OpenSansBold",
                                  fontSize: 23.sp,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5.sp,
                          )
                        ],
                      ),
                    ],
                  ),
                );
              }),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: NeverScrollableScrollPhysics(),
                  children: pages,
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              child: Obx(() {
                return BottomNavigationBar(
                  elevation: 20,
                  backgroundColor: ColorsTheme.white,
                  key: ValueKey<int>(bottomBarController.selectedIndex.value),
                  currentIndex: bottomBarController.selectedIndex.value,
                  onTap: changePage,
                  selectedItemColor: ColorsTheme.primaryColor,
                  unselectedItemColor: ColorsTheme.grey,
                  type: BottomNavigationBarType.fixed,
                  unselectedFontSize: 10,
                  selectedLabelStyle: ThemeTexts.textStyleTitle9
                      .copyWith(fontFamily: "OpenSansRegular", fontSize: 11),
                  items: [
                    BottomNavigationBarItem(
                      tooltip: "home".tr,
                      activeIcon: Icon(Icons.home_filled),
                      icon: Icon(
                        Icons.home_filled,
                        color: ColorsTheme.grayishColor,
                      ),
                      label: 'home'.tr,
                    ),
                    BottomNavigationBarItem(
                      tooltip: "mosque".tr,
                      activeIcon: Icon(Icons.mosque),
                      icon: Icon(
                        Icons.mosque,
                        color: ColorsTheme.grayishColor,
                      ),
                      label: 'mosque'.tr,
                    ),
                    BottomNavigationBarItem(
                      tooltip: "setting".tr,
                      activeIcon: Icon(Icons.settings),
                      icon: Icon(
                        Icons.settings,
                        color: ColorsTheme.grayishColor,
                      ),
                      label: 'setting'.tr,
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
