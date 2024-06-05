import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:namaz_timing_app/mvvm/view_model/controller/home/home_controller.dart';
import 'package:namaz_timing_app/mvvm/view_model/reusables/reusabale_widgets.dart';
import 'package:namaz_timing_app/mvvm/view_model/utils/color/color.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final HomeController homeController = Get.put(HomeController());
  late GoogleMapController mapController;
  LatLng? currentPosition;
  String currentAddress = '';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      currentPosition = LatLng(position.latitude, position.longitude);
    });
    _getAddressFromLatLng(currentPosition!);
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placeMarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);

      Placemark place = placeMarks[0];
      setState(() {
        currentAddress =
        "${place.locality}, ${place.administrativeArea}, ${place.street}, ${place.thoroughfare}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (currentPosition != null) {
      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(currentPosition!, 14.0),
      );
    }
  }

  void _onTap(LatLng position) async {
    setState(() {
      currentPosition = position;
    });
    _getAddressFromLatLng(position);
  }

  Future<void> _getCurrentLocationAndUpdateMap() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      LatLng newPosition = LatLng(position.latitude, position.longitude);

      setState(() {
        currentPosition = newPosition;
      });

      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(newPosition, 17.0),
      );

      _getAddressFromLatLng(newPosition);
    } catch (e) {
      print(e);
    }
  }

  void _getBack(){
    homeController.changeHomeController(currentPosition!.latitude, currentPosition!.longitude, currentAddress);
    Get.back(result: {
      'latitude': currentPosition!.latitude,
      'longitude': currentPosition!.longitude,
      'address': currentAddress,
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ReusableWidgets.defaultAppButton(
              onPress: _getCurrentLocationAndUpdateMap,
              text: "Get Current Location",
              bgColor: ColorsTheme().primaryColor,
              textColor: ColorsTheme().white,
            ),
            const SizedBox(width: 15),
            ReusableWidgets.defaultAppButton(
              onPress: () {
                _getBack();
              },
              text: "Confirm Location",
              bgColor: ColorsTheme().primaryColor,
              textColor: ColorsTheme().white,
            ),
          ],
        ),
        body: currentPosition == null
            ? const Center(child: CircularProgressIndicator())
            : Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: currentPosition!,
                zoom: 14.0,
              ),
              onMapCreated: _onMapCreated,
              myLocationButtonEnabled: false,
              myLocationEnabled: false,
              zoomControlsEnabled: false,
              onTap: _onTap,
              markers: {
                if (currentPosition != null)
                  Marker(
                    markerId: const MarkerId('selected-location'),
                    position: currentPosition!,
                  ),
              },
            ),
            Positioned(
              top: 50,
              left: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(10),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Selected Location:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Latitude: ${currentPosition!.latitude}',
                    ),
                    Text(
                      'Longitude: ${currentPosition!.longitude}',
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Address: $currentAddress',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
