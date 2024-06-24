import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortune/Model/DashboardModel.dart';
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
  CheckIncheckOut? checkIncheckOut;
  Booking_Map({super.key, required this.checkIncheckOut});

  @override
  ConsumerState<Booking_Map> createState() => _Booking_MapState();
}

class _Booking_MapState extends ConsumerState<Booking_Map> {
  Position? currentPosition;
  String currentAddress = "";
  var isLoading = false;
  var isDismiss = false;

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

          if (area != "") {
            currentAddress = "${street}, ${area}, ${locality}, ${pinCode}";
          } else {
            currentAddress = "${street}, ${locality}, ${pinCode}";
          }

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
    // var isCheckValue = await getUsercheckIN() ?? "false";

    // setState(() {
    //   isCheckIN = isCheckValue;
    // });
    // print(isCheckIN);

    if (isDismiss == true) {
      Navigator.of(context).pop();
    } else {
      if (widget.checkIncheckOut?.isUserNotCheckOut == 1) {
        Future.delayed(Duration.zero, () {
          _showDatePickerDialog();
        });
      } else {}
    }
  }

  Future<void> postCheckIN() async {
    SingleTon singleton = SingleTon();

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy hh:mm a').format(now);
//"The check in date time field must match the format d/m/Y h:i A."

    final apiService = ApiService(ref.read(dioProvider));

    var formData;

    if (widget.checkIncheckOut?.isUserCheckInToday == 1) {
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
      ShowToastMessage(postResponse.message ?? "");
      getCheck();
    } else {
      // if (isCheckIN == "true") {
      //   await UsercheckIN("false");
      // } else {
      //   await UsercheckIN("true");
      // }
      ShowToastMessage(postResponse.message ?? "");
    }
  }

  Future<void> postCheckOUT() async {
    SingleTon singleton = SingleTon();

    final apiService = ApiService(ref.read(dioProvider));

    var formData;

    formData = FormData.fromMap({
      "remarks": _remarksController.text,
      "check_out_date_time": _selectedDate,
      "curr_location": singleton.setLocation,
      // "curr_lat": singleton.lattidue,
      // "curr_long": singleton.longitude
    });

    LoadingOverlay.show(context);

    final postResponse = await apiService.post<SuccessModel>(
        ConstantApi.usersCheckOutUrl, formData);
    LoadingOverlay.forcedStop();

    if (postResponse.success == true) {
      setState(() {
        isDismiss = true;
      });

      postCheckIN();
      // if (isCheckIN == "true") {
      //   UsercheckIN("false");
      // } else {
      //   UsercheckIN("true");
      // }
      // ShowToastMessage(postResponse.message ?? "");
    } else {
      // if (isCheckIN == "true") {
      //   await UsercheckIN("false");
      // } else {
      //   await UsercheckIN("true");
      // }
      ShowToastMessage(postResponse.message ?? "");
    }
    // getCheck();
  }

  String _selectedDate = "Select Date and Time";
  TextEditingController _remarksController = TextEditingController();

  void _showDatePickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Check-Out"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text(_selectedDate),
                    trailing: Icon(Icons.calendar_today),
                    onTap: () async {
                      String initialDateStr =
                          (widget.checkIncheckOut?.notCheckOutDate ?? "") == ""
                              ? "2024-06-11"
                              : widget.checkIncheckOut?.notCheckOutDate ??
                                  ""; // Your string date
                      DateTime pickedDate = DateTime.parse(
                          initialDateStr); // Parsing the string date

                      final TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        final DateTime selectedDateTime = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );

                        String formatdate = DateFormat("dd/MM/yyyy hh:mm a")
                            .format(selectedDateTime);
                        if (mounted) {
                          setState(() {
                            _selectedDate = formatdate;
                            print(pickedDate);
                          });
                        }
                      }

                      // if (pickedDate != null) {
                      //   setState(() {
                      //     _selectedDate = DateFormat('dd/MM/yyyy hh:mm a')
                      //         .format(_selectedDate);
                      //   });
                      // }
                    },
                  ),
                  TextField(
                    controller: _remarksController,
                    decoration: InputDecoration(
                      labelText: "Remarks",
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            // TextButton(
            //   child: Text("Cancel"),
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //   },
            // ),
            TextButton(
              child: Text("Submit"),
              onPressed: () {
                // Handle the submission of date and remarks
                FocusScope.of(context).unfocus();

                if (_remarksController.text == "" ||
                    _remarksController.text == null) {
                  ShowToastMessage("Enter remarks");
                } else if (_selectedDate == "Select Date and Time") {
                  ShowToastMessage("Choose date and time");
                } else {
                  print("Selected Date: $_selectedDate");
                  print("Remarks: ${_remarksController.text}");
                  isDismiss = false;
                  postCheckOUT();
                }
              },
            ),
          ],
        );
      },
    );
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
                            if (widget.checkIncheckOut?.isUserNotCheckOut ==
                                1) {
                              _showDatePickerDialog();
                            } else {
                              postCheckIN();
                            }
                          },
                          child: Row(
                            children: [
                              Text(
                                '${widget.checkIncheckOut?.isUserCheckInToday == 1 ? "Check Out" : isDismiss == true ? "Check Out" : "Check In"}',
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
