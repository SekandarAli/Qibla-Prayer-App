import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:namaz_timing_app/mvvm/model/home_model.dart';
import 'package:namaz_timing_app/mvvm/view/home/widget/home_widget.dart';
import 'package:namaz_timing_app/mvvm/view_model/controller/home/home_controller.dart';
import 'package:namaz_timing_app/mvvm/view_model/utils/color/color.dart';
import 'package:namaz_timing_app/mvvm/view_model/utils/styles/themeText.dart';
import '../../../view_model/service/home_service.dart';
import 'map_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.now();
  Future<HomeModel>? futureList;
  HomeModel? cachedData;

  final HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    _updateFutureList();
    homeController.retrieveHomeController();
  }

  Future<void> _updateFutureList() async {
    setState(() {
      futureList = HomeService().getAllNamazData(
        date: DateFormat('dd-MM-yyyy').format(selectedDate),
        lat: homeController.selectedLatitude.value.toString(),
        lng: homeController.selectedLongitude.value.toString(),
      );
    });
  }

  void _incrementDate() {
    setState(() {
      selectedDate = selectedDate.add(const Duration(days: 1));
      _updateFutureList();
    });
  }

  void _decrementDate() {
    setState(() {
      selectedDate = selectedDate.subtract(const Duration(days: 1));
      _updateFutureList();
    });
  }

  void _onMapScreenTap() async {
    final result = await Get.to(() => const MapScreen());
    if (result != null) {
      setState(() {
        homeController.selectedLatitude.value = result['latitude'];
        homeController.selectedLongitude.value = result['longitude'];
        homeController.selectedAddress.value = result['address'];
      });
    }
    _updateFutureList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prayer Times', style: TextStyle(color: ColorsTheme().white)),
        backgroundColor: ColorsTheme().primaryColor,
      ),
      body: RefreshIndicator(
        onRefresh: _updateFutureList,
        color: ColorsTheme().primaryColor,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            color: ColorsTheme().backgroundColor,
            padding: const EdgeInsets.all(16.0),
            child: FutureBuilder<HomeModel>(
              future: futureList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.green));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
                } else if (snapshot.hasData && snapshot.data != null) {
                  cachedData = snapshot.data;

                  String fajr = cachedData!.data.timings.fajr;
                  String dhuhr = cachedData!.data.timings.dhuhr;
                  String asr = cachedData!.data.timings.asr;
                  String maghrib = cachedData!.data.timings.maghrib;
                  String isha = cachedData!.data.timings.isha;
                  String islamicDate = cachedData!.data.date.hijri.date;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          InkWell(
                            onTap: _onMapScreenTap,
                            child: Card(
                              elevation: 1,
                              color: ColorsTheme().lightPrimaryColor,
                              margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                width: 1.sw,
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    if (homeController.selectedAddress.value.isNotEmpty) ...[
                                      Text('Your Location: \n${homeController.selectedAddress.value}', style: ThemeTexts.textStyleTitle8),
                                      // const SizedBox(height: 15),
                                      // Text('Latitude: $selectedLatitude', style: ThemeTexts.textStyleTitle8),
                                      // const SizedBox(height: 15),
                                      // Text('Longitude: $selectedLongitude', style: ThemeTexts.textStyleTitle8),
                                    ] else ...[
                                      Text('No location selected', style: ThemeTexts.textStyleTitle8),
                                    ],
                                    const SizedBox(height: 15),
                                    Text('Next Prayer is: $asr', style: ThemeTexts.textStyleTitle8),
                                    const SizedBox(height: 15),
                                    Text("Today's Date: ${DateFormat('dd-MM-yyyy').format(selectedDate)}", style: ThemeTexts.textStyleTitle8),
                                    const SizedBox(height: 15),
                                    Text('Time Left:', style: ThemeTexts.textStyleTitle8),
                                    const SizedBox(height: 15),
                                    Text('Islamic Date: $islamicDate', style: ThemeTexts.textStyleTitle8),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 20.sp,
                            right: 10.sp,
                            child: Icon(Icons.edit_location_alt_sharp,size: 25.sp,color: ColorsTheme().primaryColor,),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.chevron_left, color: ColorsTheme().primaryColor, size: 40.sp),
                            onPressed: _decrementDate,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            DateFormat('dd MMM yyyy').format(selectedDate),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            icon: Icon(Icons.chevron_right, color: ColorsTheme().primaryColor, size: 40.sp),
                            onPressed: _incrementDate,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      HomeWidget(prayerName: 'Fajr', prayerTime: fajr),
                      HomeWidget(prayerName: 'Dhuhr', prayerTime: dhuhr),
                      HomeWidget(prayerName: 'Asr', prayerTime: asr),
                      HomeWidget(prayerName: 'Maghrib', prayerTime: maghrib),
                      HomeWidget(prayerName: 'Isha', prayerTime: isha),
                    ],
                  );
                } else {
                  return const Center(child: Text('No data available', style: TextStyle(color: Colors.grey)));
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
