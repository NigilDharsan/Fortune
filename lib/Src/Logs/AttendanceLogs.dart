import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortune/Common_Widgets/Custom_App_Bar.dart';
import 'package:fortune/Model/AttendanceLogsModel.dart';
import 'package:fortune/Model/SuccessModel.dart';
import 'package:fortune/Src/FilterScreen/FilterLogScreen.dart';
import 'package:fortune/utilits/ApiProvider.dart';
import 'package:fortune/utilits/ApiService.dart';
import 'package:fortune/utilits/Common_Colors.dart';
import 'package:fortune/utilits/ConstantsApi.dart';
import 'package:fortune/utilits/Generic.dart';
import 'package:fortune/utilits/Loading_Overlay.dart';
import 'package:fortune/utilits/Text_Style.dart';
import 'package:intl/intl.dart';

class AttendanceLogsScreen extends ConsumerStatefulWidget {
  const AttendanceLogsScreen({super.key});

  @override
  ConsumerState<AttendanceLogsScreen> createState() =>
      _AttendanceLogsScreen_ScreenState();
}

class _AttendanceLogsScreen_ScreenState
    extends ConsumerState<AttendanceLogsScreen> {
  var formData;
  SingleTon singleton = SingleTon();
  FilterLog? filter;

  TextEditingController _remarksController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    singleton.filterUserID = null;
    singleton.filterMonth = null;
    singleton.filterYear = null;
    singleton.filterEnable = false;

    DateTime now = DateTime.now();
    String month = now.month.toString().padLeft(2, '0');
    String year = now.year.toString();

    formData = FormData.fromMap({"userid": "", "month": month, "year": year});
  }

  void _showRemarksDialog(LogHours logHoursDetails) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Raise Query for date: ${logHoursDetails.logDate}'),
          content: Container(
            width: double.maxFinite,
            child: TextField(
              controller: _remarksController,
              decoration: InputDecoration(
                hintText: "Enter your reason here",
                border: OutlineInputBorder(),
              ),
              maxLines:
                  5, // Set the maximum number of lines to more than 1 for multi-line input
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Submit'),
              onPressed: () async {
                // Handle the submit action

                if (_remarksController.text.isNotEmpty) {
                  final apiService = ApiService(ref.read(dioProvider));

                  String? dateString = logHoursDetails.logDate;
                  DateFormat dateFormat = DateFormat("dd/MM/yyyy");

                  DateTime parseDate =
                      new DateFormat("dd/MM/yyyy").parse(dateString!);
                  var inputDate = DateTime.parse(parseDate.toString());
                  var outputFormat = DateFormat('yyyy-MM-dd');
                  var outputDate = outputFormat.format(inputDate);
                  print(outputDate);

                  var formData1;

                  formData1 = FormData.fromMap({
                    "user_id": logHoursDetails.userId,
                    "reason": _remarksController.text,
                    "request_date": outputDate,
                  });

                  LoadingOverlay.show(context);

                  final postResponse = await apiService.post3<SuccessModel>(
                      ConstantApi.logRequestSaveURL, formData1);
                  LoadingOverlay.forcedStop();

                  if (postResponse.success == true) {
                    ShowToastMessage(postResponse.message ?? "");
                    Navigator.of(context).pop();

                    setState(() {
                      DateTime now = DateTime.now();
                      String month = now.month.toString().padLeft(2, '0');
                      String year = now.year.toString();

                      formData = FormData.fromMap(
                          {"executive_id": "", "month": month, "year": year});
                    });
                  } else {
                    ShowToastMessage(postResponse.message ?? "");
                  }
                } else {}

                print("Remarks: ${_remarksController.text}");
              },
            ),
          ],
        );
      },
    );
  }

  void showCustomDialog(BuildContext context, LogHours? loghour, String type) {
    TimeOfDay? checkInTime; // Default 10:00 AM
    TimeOfDay? checkOutTime; // Default 7:00 PM

    if (type == "Add") {
      checkInTime = TimeOfDay(hour: 10, minute: 0);
      checkOutTime = TimeOfDay(hour: 19, minute: 0);
    } else {
      try {
        DateFormat dateFormat = DateFormat("d/MM/yyyy hh:mm");

        DateTime parsedDateTime = dateFormat.parse(loghour?.checkInTime ?? "");

        checkInTime =
            TimeOfDay(hour: parsedDateTime.hour, minute: parsedDateTime.minute);

        DateTime parsedDateTime1 =
            dateFormat.parse(loghour?.checkOutTime ?? "");

        checkOutTime = TimeOfDay(
            hour: parsedDateTime1.hour,
            minute: parsedDateTime1.minute); // Default 7:00 PM
      } catch (e) {
        print('Error parsing date: $e');
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Update Missing Hours'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  (loghour?.requestReason ?? "") != ""
                      ? Text(
                          'Reason for Update Check-in/Check-out Time \n${loghour?.requestReason ?? ""}')
                      : Container(),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text('Username: '),
                      Text('${loghour?.userName ?? ""}',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text('Date: '),
                      Text('${loghour?.logDate ?? ""}',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text('Check In: '),
                      TextButton(
                        onPressed: () async {
                          TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (picked != null) {
                            setState(() {
                              checkInTime = picked;
                            });
                          }
                        },
                        child: Text(checkInTime != null
                            ? checkInTime!.format(context)
                            : 'Select Time'),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Check Out: '),
                      TextButton(
                        onPressed: () async {
                          TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (picked != null) {
                            setState(() {
                              checkOutTime = picked;
                            });
                          }
                        },
                        child: Text(checkOutTime != null
                            ? checkOutTime!.format(context)
                            : 'Select Time'),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    final apiService = ApiService(ref.read(dioProvider));

                    DateFormat dateFormat = DateFormat("dd/MM/yyyy");

                    DateTime parsedDateTime =
                        dateFormat.parse(loghour?.logDate ?? "");

                    DateFormat dateFormat1 = DateFormat("yyyy-MM-dd");
                    String timeString = dateFormat1.format(parsedDateTime);

                    if (type == "Add") {
                      var formData1;

                      formData1 = FormData.fromMap({
                        "user_id": loghour?.userId ?? "",
                        "date": timeString,
                        "check_in_time": getformattedTime(checkInTime!),
                        "check_out_time": getformattedTime(checkOutTime!)
                      });

                      LoadingOverlay.show(context);

                      final postResponse = await apiService.post3<SuccessModel>(
                          ConstantApi.usersLogHoursSaveUrl, formData1);
                      LoadingOverlay.forcedStop();

                      if (postResponse.success == true) {
                        ShowToastMessage(postResponse.message ?? "");
                        Navigator.of(context).pop();

                        setState(() {
                          DateTime now = DateTime.now();
                          String month = now.month.toString().padLeft(2, '0');
                          String year = now.year.toString();

                          formData = FormData.fromMap({
                            "executive_id": "",
                            "month": month,
                            "year": year
                          });
                        });
                      } else {
                        ShowToastMessage(postResponse.message ?? "");
                      }
                    } else {
                      var formData1;

                      formData1 = FormData.fromMap({
                        "user_id": loghour?.userId ?? "",
                        "date": timeString,
                        "check_in_time": getformattedTime(checkInTime!),
                        "check_out_time": getformattedTime(checkOutTime!),
                        "_method": "PATCH"
                      });

                      LoadingOverlay.show(context);

                      final postResponse = await apiService.post3<SuccessModel>(
                          "${ConstantApi.usersLogHoursUpdatedUrl}/${loghour?.id}",
                          formData1);
                      LoadingOverlay.forcedStop();

                      if (postResponse.success == true) {
                        ShowToastMessage(postResponse.message ?? "");
                        Navigator.of(context).pop();

                        setState(() {
                          DateTime now = DateTime.now();
                          String month = now.month.toString().padLeft(2, '0');
                          String year = now.year.toString();

                          formData = FormData.fromMap({
                            "executive_id": "",
                            "month": month,
                            "year": year
                          });
                        });
                      } else {
                        ShowToastMessage(postResponse.message ?? "");
                      }
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // getformattedTime(TimeOfDay time) {
  //   return '${time.hour}:${time.minute} ${time.period.toString().split('.')[1]}';
  // }

  String getformattedTime(TimeOfDay time) {
    final hour =
        time.hourOfPeriod.toString().padLeft(2, '0'); // Ensure 2 digits
    final minute = time.minute.toString().padLeft(2, '0'); // Ensure 2 digits
    final period = time.period == DayPeriod.am ? "AM" : "PM";

    return "$hour:$minute $period";
  }

  @override
  Widget build(BuildContext context) {
    final _userLogsListData = ref.watch(userLogsProvider(formData));

    return Scaffold(
      backgroundColor: white5,
      appBar: Custom_AppBar(
          title: "Attendance Logs",
          actions: <Widget>[
            Stack(children: [
              Padding(
                padding: EdgeInsets.only(
                    right: 16.0), // Adjust the padding as needed
                child: IconButton(
                  icon: Icon(Icons.filter_list),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FilterLogScreen(
                                  filter: filter,
                                ))).then((value) {
                      if (value == true) {
                        setState(() {
                          formData = FormData.fromMap({
                            "userid": singleton.filterUserID,
                            "month": singleton.filterMonth,
                            "year": singleton.filterYear
                          });
                        });
                      }
                    });
                  },
                ),
              ),
              singleton.filterEnable == true
                  ? Positioned(
                      top: 10.0, // Adjust position as needed
                      right: 20.0, // Adjust position as needed
                      child: Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                      ),
                    )
                  : Container(),
            ])
          ],
          isGreen: false,
          isNav: true),
      body: _userLogsListData.when(
        data: (data) {
          filter = data?.data?.filter;
          return Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                //physics: const NeverScrollableScrollPhysics(),
                itemCount: data?.data?.logHours?.length ?? 0,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, top: 20, bottom: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'User Name : ',
                                  style: appTitle,
                                ),
                                Flexible(
                                  child: Text(
                                    "${data?.data?.logHours?[index].userName ?? ""}",
                                    style: roleT,
                                  ), //'${data.marketingExecutives?.map((item) => item.name).join(', ')}'
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Date : ',
                                  style: appTitle,
                                ),
                                Flexible(
                                  child: Text(
                                    "${data?.data?.logHours?[index].logDate ?? ""}",
                                    style: roleT,
                                  ), //'${data.marketingExecutives?.map((item) => item.name).join(', ')}'
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Check In : ',
                                  style: appTitle,
                                ),
                                Flexible(
                                  child: Text(
                                    "${data?.data?.logHours?[index].checkInTime ?? ""}",
                                    style: roleT,
                                  ), //'${data.marketingExecutives?.map((item) => item.name).join(', ')}'
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Check Out : ',
                                  style: appTitle,
                                ),
                                Flexible(
                                  child: Text(
                                    "${data?.data?.logHours?[index].checkOutTime ?? ""}",
                                    style: roleT,
                                  ), //'${data.marketingExecutives?.map((item) => item.name).join(', ')}'
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Logged Hrs : ',
                                  style: appTitle,
                                ),
                                Flexible(
                                  child: Text(
                                    "${data?.data?.logHours?[index].totalLoggedHrs ?? ""}",
                                    style: roleT,
                                  ), //'${data.marketingExecutives?.map((item) => item.name).join(', ')}'
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Center(
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white, // foreground

                                    backgroundColor: data
                                                ?.data
                                                ?.logHours?[index]
                                                .actionLinkText ==
                                            "Query"
                                        ? blue5
                                        : data?.data?.logHours?[index]
                                                    .actionLinkText ==
                                                "Requested"
                                            ? Colors.orange
                                            : data?.data?.logHours?[index]
                                                        .actionLinkText ==
                                                    "Requested"
                                                ? Colors.green
                                                : blue5,
                                  ),
                                  onPressed: () {
                                    if (data?.data?.logHours?[index]
                                            .actionLinkText ==
                                        "Query") {
                                      _showRemarksDialog(
                                          data?.data?.logHours?[index] ??
                                              LogHours());
                                    } else if (data?.data?.logHours?[index]
                                            .actionLinkText ==
                                        "Add") {
                                      showCustomDialog(context,
                                          data?.data?.logHours?[index], "Add");
                                    } else if (data?.data?.logHours?[index]
                                            .actionLinkText ==
                                        "Edit") {
                                      showCustomDialog(context,
                                          data?.data?.logHours?[index], "Edit");
                                    }
                                  },
                                  child: Text(
                                      "${data?.data?.logHours?[index].actionLinkText}")),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          );
        },
        error: (Object error, StackTrace stackTrace) {
          return Center(child: Text("Connection closed, Please try again!"));
        },
        loading: () => Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

TextStyle Liststyle = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 18,
    color: Colors.black,
    fontWeight: FontWeight.w500);
