import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortune/Common_Widgets/Custom_App_Bar.dart';
import 'package:fortune/Model/AttendanceLogsModel.dart';
import 'package:fortune/Model/SuccessModel.dart';
import 'package:fortune/utilits/ApiProvider.dart';
import 'package:fortune/utilits/ApiService.dart';
import 'package:fortune/utilits/Common_Colors.dart';
import 'package:fortune/utilits/ConstantsApi.dart';
import 'package:fortune/utilits/Generic.dart';
import 'package:fortune/utilits/Loading_Overlay.dart';
import 'package:fortune/utilits/Text_Style.dart';

class AttendanceLogsScreen extends ConsumerStatefulWidget {
  const AttendanceLogsScreen({super.key});

  @override
  ConsumerState<AttendanceLogsScreen> createState() =>
      _AttendanceLogsScreen_ScreenState();
}

class _AttendanceLogsScreen_ScreenState
    extends ConsumerState<AttendanceLogsScreen> {
  var formData;
  TextEditingController _remarksController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    formData =
        FormData.fromMap({"executive_id": "", "month": "07", "year": "2024"});
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

                  var formData;

                  formData = FormData.fromMap({
                    "user_id": logHoursDetails.id,
                    "reason": _remarksController.text,
                    "request_date": logHoursDetails.logDate,
                  });

                  LoadingOverlay.show(context);

                  final postResponse = await apiService.post3<SuccessModel>(
                      ConstantApi.logRequestSaveURL, formData);
                  LoadingOverlay.forcedStop();

                  if (postResponse.success == true) {
                    ShowToastMessage(postResponse.message ?? "");
                    Navigator.of(context).pop();
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

  @override
  Widget build(BuildContext context) {
    final _userLogsListData = ref.watch(userLogsProvider(formData));

    return Scaffold(
      backgroundColor: white5,
      appBar: Custom_AppBar(
          title: "Attendance Logs", actions: null, isGreen: false, isNav: true),
      body: _userLogsListData.when(
        data: (data) {
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
                                  onPressed: () {
                                    _showRemarksDialog(
                                        data?.data?.logHours?[index] ??
                                            LogHours());
                                  },
                                  child: Text("Query")),
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
