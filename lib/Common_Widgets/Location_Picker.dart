import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fortune/utilits/Common_Colors.dart';
import 'package:fortune/utilits/Generic.dart';
import 'package:fortune/utilits/Text_Style.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'Image_Path.dart';

class Booking_Map extends StatefulWidget {
  const Booking_Map({super.key});

  @override
  State<Booking_Map> createState() => _Booking_MapState();
}

class _Booking_MapState extends State<Booking_Map> {
  Position? currentPosition;
  String currentAddress = "";
  var isLoading = false;
  String? CurrentLocation;
  final Completer<GoogleMapController> _controller = Completer();
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
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
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
  }
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5,bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ImgPathSvg("Pin.svg"),
                          const SizedBox(width: 5,),
                          Container(
                              width: MediaQuery.of(context).size.width /1.8,
                              child: Text(currentAddress == ""
                                  ? "Location not found"
                                  : currentAddress)),
                          const Spacer(),
                          InkWell(
                            onTap: (){

                            },
                            child: Row(
                              children: [
                                Text('Check In',style: ButtonT1,),
                                Icon(Icons.arrow_forward,color: blue3,)
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