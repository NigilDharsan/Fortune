import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortune/Common_Widgets/Custom_App_Bar.dart';
import 'package:fortune/utilits/ApiProvider.dart';
import 'package:fortune/utilits/Common_Colors.dart';

class AttendanceLogsScreen extends ConsumerStatefulWidget {
  const AttendanceLogsScreen({super.key});

  @override
  ConsumerState<AttendanceLogsScreen> createState() =>
      _AttendanceLogsScreen_ScreenState();
}

class _AttendanceLogsScreen_ScreenState
    extends ConsumerState<AttendanceLogsScreen> {
  var formData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    formData =
        FormData.fromMap({"executive_id": "", "month": "07", "year": "2024"});
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
                            left: 15, right: 15, top: 20, bottom: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //INSIDE LIST
                            Text(
                                'User Name : ${data?.data?.logHours?[index].userName ?? ""}',
                                style: Liststyle),
                            const SizedBox(height: 5),
                            Text(
                                'Check In : ${data?.data?.logHours?[index].checkInTime ?? ""}',
                                style: Liststyle),
                            const SizedBox(height: 5),
                            Text(
                                'Check Out : ${data?.data?.logHours?[index].checkOutTime ?? ""}',
                                style: Liststyle),
                            const SizedBox(height: 5),
                            Text(
                                'Total Logged Hrs  : ${data?.data?.logHours?[index].totalLoggedHrs ?? ""}',
                                style: Liststyle),
                            const SizedBox(height: 5),
                            ElevatedButton(
                                onPressed: () {}, child: Text("Action"))
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
