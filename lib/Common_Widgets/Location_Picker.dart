import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortune/Model/SuccessModel.dart';
import 'package:fortune/utilits/ApiService.dart';
import 'package:fortune/utilits/Common_Colors.dart';
import 'package:fortune/utilits/ConstantsApi.dart';
import 'package:fortune/utilits/Generic.dart';
import 'package:fortune/utilits/Loading_Overlay.dart';
import 'package:fortune/utilits/Text_Style.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import 'Image_Path.dart';

class Booking_Map extends ConsumerStatefulWidget {
  const Booking_Map({super.key});

  @override
  ConsumerState<Booking_Map> createState() => _Booking_MapState();
}

class _Booking_MapState extends ConsumerState<Booking_Map> {
  Position? currentPosition;
  String currentAddress = "";
  var isLoading = false;
  var isCheckIN = "false";

  String? CurrentLocation;
  Future<Position> getPosition() async {
    LocationPermission? Permision;
    Permision = await Geolocator.checkPermission();
    if (Permision == LocationPermission.denied) {
      Permision = await Geolocator.requestPermission();
      if (Permision == LocationPermission.denied) {
        return Future.error("Location Permission are Denied");
      }
    }
    return await Geolocator.getCurrentPosition();
  }

//MAP
  Future<void> getAddress(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0]; // Access the first element
        String locality = place.locality ?? "";
        String street = place.street ?? "";
        String district = place.subAdministrativeArea ?? "";
        String area = place.thoroughfare ?? "";
        String subLocality = place.subLocality ?? "";
        String pinCode = place.postalCode ?? "";

        setState(() {
          SingleTon singleton = SingleTon();
          currentAddress = "${street}, ${area}, ${locality}, ${pinCode}";
          singleton.setLocation = currentAddress;
          singleton.lattidue = latitude.toString();
          singleton.longitude = longitude.toString();
        });
      } else {
        setState(() {
          currentPosition = null;
          currentAddress = "Location Not Found";
        });
      }
    } catch (e) {
      print("ERROR LOCATION ${e}");
      setState(() {
        currentPosition = null;
        currentAddress = "Error Fetching Location";
      });
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      isLoading = true;
      currentPosition = await getPosition();
      getAddress(currentPosition!.latitude, currentPosition!.longitude);

      isLoading = false;
      print("FALSE LOADING");
    } catch (e) {
      print(e);
    }
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print("Error${error.toString()}");
    });
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    super.initState();
    // Fetch current location when the page loads
    getCurrentLocation();
    getCheck();
  }

  void getCheck() async {
    var isCheckValue = await getUsercheckIN() ?? "false";

    setState(() {
      isCheckIN = isCheckValue;
    });
    print(isCheckIN);
  }

  Future<void> postCheckIN() async {
    SingleTon singleton = SingleTon();

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy hh:mm a').format(now);
//"The check in date time field must match the format d/m/Y h:i A."

    final apiService = ApiService(ref.read(dioProvider));

    var formData;

    if (isCheckIN == "true") {
      formData = FormData.fromMap({
        "date_time_for": "check-out",
        "check_out_date_time": formattedDate,
        "curr_location": singleton.setLocation,
        "curr_lat": singleton.lattidue,
        "curr_long": singleton.longitude
      });
    } else {
      formData = FormData.fromMap({
        "date_time_for": "check-in",
        "check_in_date_time": formattedDate,
        "curr_location": singleton.setLocation,
        "curr_lat": singleton.lattidue,
        "curr_long": singleton.longitude
      });
    }

    LoadingOverlay.show(context);

    final postResponse =
        await apiService.post<SuccessModel>(ConstantApi.usersLogdUrl, formData);
    LoadingOverlay.forcedStop();

    if (postResponse.success == true) {
      if (isCheckIN == "true") {
        UsercheckIN("false");
      } else {
        UsercheckIN("true");
      }
      ShowToastMessage(postResponse.message ?? "");
    } else {
      if (isCheckIN == "true") {
        await UsercheckIN("false");
      } else {
        await UsercheckIN("true");
      }
      ShowToastMessage(postResponse.message ?? "");
    }
    getCheck();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white1,
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        color: white1,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ImgPathSvg("Pin.svg"),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width / 1.8,
                            child: Text(currentAddress == ""
                                ? "Location not found"
                                : currentAddress)),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            postCheckIN();
                          },
                          child: Row(
                            children: [
                              Text(
                                '${isCheckIN == "true" ? "Check Out" : "Check In"}',
                                style: ButtonT1,
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: blue3,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
