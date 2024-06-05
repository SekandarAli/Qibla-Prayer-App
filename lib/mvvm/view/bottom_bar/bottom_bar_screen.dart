// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:namaz_timing_app/mvvm/view_model/controller/bottom_bar/bottom_bar_controller.dart';
import '../../view_model/utils/color/color.dart';
import '../../view_model/utils/styles/themeText.dart';
import '../home/screen/home_screen.dart';
import '../mosque/qibla_direction_screen.dart';

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
    QiblaDirectionScreen(),
    Container(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _pageController = PageController(initialPage: bottomBarController.selectedIndex.value);
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
      duration: Duration(milliseconds: 300),
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
        backgroundColor: ColorsTheme().backgroundColor,
        body: SafeArea(
          top: true,
          child: Column(
            children: [
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
                  backgroundColor: ColorsTheme().white,
                  key: ValueKey<int>(bottomBarController.selectedIndex.value),
                  currentIndex: bottomBarController.selectedIndex.value,
                  onTap: changePage,
                  selectedItemColor: ColorsTheme().primaryColor,
                  unselectedItemColor: ColorsTheme().grey,
                  type: BottomNavigationBarType.fixed,
                  unselectedFontSize: 12,
                  iconSize: 25,
                  unselectedIconTheme: IconThemeData(size: 20),
                  selectedLabelStyle: ThemeTexts.textStyleTitle9.copyWith(fontFamily: "OpenSansRegular", fontSize: 13),
                  items: [
                    BottomNavigationBarItem(
                      tooltip: "Home".tr,
                      activeIcon: Icon(Icons.home_rounded),
                      icon: Icon(
                        Icons.home_rounded,
                        color: ColorsTheme().grayishColor,
                      ),
                      label: 'Home'.tr,
                    ),
                    BottomNavigationBarItem(
                      tooltip: "Mosque".tr,
                      activeIcon: Icon(Icons.mosque),
                      icon: Icon(
                        Icons.mosque,
                        color: ColorsTheme().grayishColor,
                      ),
                      label: 'Mosque'.tr,
                    ),
                    BottomNavigationBarItem(
                      tooltip: "Setting".tr,
                      activeIcon: Icon(Icons.settings),
                      icon: Icon(
                        Icons.settings,
                        color: ColorsTheme().grayishColor,
                      ),
                      label: 'Setting'.tr,
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
