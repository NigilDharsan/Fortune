import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortune/Common_Widgets/Common_Button.dart';
import 'package:fortune/Common_Widgets/Common_List.dart';
import 'package:fortune/Common_Widgets/Custom_App_Bar.dart';
import 'package:fortune/Model/ServiceListModel.dart';
import 'package:fortune/Src/Service_Form_Ui/Service_Form_Screen.dart';
import 'package:fortune/Src/Service_History_List_Ui/Service_Status_List_Screen.dart';
import 'package:fortune/utilits/ApiProvider.dart';
import 'package:fortune/utilits/Common_Colors.dart';
import 'package:fortune/utilits/Generic.dart';
import 'package:intl/intl.dart';

class Service_List_Screen extends ConsumerStatefulWidget {
  const Service_List_Screen({super.key});

  @override
  ConsumerState<Service_List_Screen> createState() =>
      _Service_List_ScreenState();
}

class _Service_List_ScreenState extends ConsumerState<Service_List_Screen> {
  var dateRange = "";

  var formData;
  SingleTon singleton = SingleTon();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    formData = FormData.fromMap({
      "executive_id": "",
      "client_id": "",
      "status_id": "",
      "daterange": ""
    });
    singleton.formData = formData;

    // getRole();
  }

  // void getRole() async {
  //   final qww = await getUserRole();
  //   setState(() {
  //     user_Role = qww;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final _ServiceListData = ref.watch(serviceListProvider);

    SingleTon singleton = SingleTon();

    return singleton.permissionList.contains("service-create") == true
        ? Scaffold(
            floatingActionButton: Floating_Button(context, onTap: () {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Service_Form_Screen()))
                  .then((value) {
                if (value == true) {
                  setState(() {
                    formData = FormData.fromMap({
                      "executive_id": "",
                      "client_id": "",
                      "status_id": "",
                      "daterange": ""
                    });
                    singleton.formData = formData;

                    ref.refresh(serviceListProvider);
                  });
                }
              });
            }, floatT: "Add Service"),
            backgroundColor: white5,
            appBar: Custom_AppBar(
                title: "Service List",
                actions: null,
                isGreen: false,
                isNav: true),
            body: _ServiceListData.when(
              data: (data) {
                return SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          color: Colors.white,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Row(
                              children: [
                                Text(dateRange),
                                Spacer(),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red),
                                    onPressed: () async {
                                      final DateTimeRange? picked =
                                          await showDateRangePicker(
                                        context: context,
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2200),
                                        initialDateRange: DateTimeRange(
                                          start: DateTime.now(),
                                          end: DateTime.now(),
                                        ),
                                      );

                                      if (picked != null) {
                                        setState(() {
                                          // fromDate = picked.start;
                                          // toDate = picked.end;
                                          String formatdate =
                                              DateFormat("dd/MM/yyyy")
                                                  .format(picked.start);

                                          String todate =
                                              DateFormat("dd/MM/yyyy")
                                                  .format(picked.end);

                                          setState(() {
                                            dateRange =
                                                "${formatdate}-${todate}";
                                            formData = FormData.fromMap({
                                              "executive_id": "",
                                              "client_id": "",
                                              "status_id": "",
                                              "daterange": dateRange
                                            });
                                            singleton.formData = formData;
                                          });
                                        });
                                      }
                                    },
                                    child: Text(
                                      "Date range",
                                      style: TextStyle(color: Colors.white),
                                    ))
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: MediaQuery.sizeOf(context).width,
                          child: _Service_List(
                              ref, context, data?.data?.services?.data ?? []),
                        ),
                      ],
                    ),
                  ),
                );
              },
              error: (Object error, StackTrace stackTrace) {
                return Text(error.toString());
              },
              loading: () => Center(child: CircularProgressIndicator()),
            ),
          )
        : Scaffold(
            backgroundColor: white5,
            appBar: Custom_AppBar(
                title: "Service List",
                actions: null,
                isGreen: false,
                isNav: true),
            body: _ServiceListData.when(
              data: (data) {
                return SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: MediaQuery.sizeOf(context).width,
                          child: _Service_List(
                              ref, context, data?.data?.services?.data ?? []),
                        ),
                      ],
                    ),
                  ),
                );
              },
              error: (Object error, StackTrace stackTrace) {
                return Center(child: Text("No data found!"));
              },
              loading: () => Center(child: CircularProgressIndicator()),
            ),
          );
  }
}

Widget _Service_List(WidgetRef ref, context, List<ServicesData>? data) {
  return ListView.builder(
    itemCount: data?.length ?? 0,
    shrinkWrap: true,
    scrollDirection: Axis.vertical,
    physics: const NeverScrollableScrollPhysics(),
    itemBuilder: (BuildContext context, int index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Service_History_List_Screen(
                          service_id: "${data[index].serviceId ?? 0}",
                        )));
          },
          child: Service_List(context,
              data: data![index],
              isTag: data[index].status ?? "",
              isHistory: false,
              ref: ref),
        ),
      );
    },
  );
}
