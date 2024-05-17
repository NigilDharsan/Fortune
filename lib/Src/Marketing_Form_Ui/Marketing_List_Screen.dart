import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortune/Common_Widgets/Common_Button.dart';
import 'package:fortune/Common_Widgets/Common_List.dart';
import 'package:fortune/Common_Widgets/Custom_App_Bar.dart';
import 'package:fortune/Model/MarketingListModel.dart';
import 'package:fortune/Src/Marketing_Form_Ui/Marketing_Form_Screen.dart';
import 'package:fortune/Src/Marketing_History_List/Marketing_History_List.dart';
import 'package:fortune/utilits/ApiProvider.dart';
import 'package:fortune/utilits/Common_Colors.dart';
import 'package:fortune/utilits/Generic.dart';
import 'package:intl/intl.dart';

class Marketing_List_Screen extends ConsumerStatefulWidget {
  const Marketing_List_Screen({super.key});

  @override
  ConsumerState<Marketing_List_Screen> createState() =>
      _Marketing_List_ScreenState();
}

class _Marketing_List_ScreenState extends ConsumerState<Marketing_List_Screen> {
  // var user_Role = "";
  var dateRange = "";
  var formData;
  var pageCount = 1;
  var i = 0;
  var isRefresh = false;

  SingleTon singleton = SingleTon();
  ScrollController _scrollController = ScrollController();
  List<MarketingListData> marketingData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    formData = FormData.fromMap({
      "executive_id": "",
      "client_id": "",
      "status_id": "",
      "daterange": "",
      "page": pageCount
    });
    singleton.formData = formData;

    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      // Reach the bottom of the list
      // Fetch more data
      pageCount++;
      formData = FormData.fromMap({
        "executive_id": "",
        "client_id": "",
        "status_id": "",
        "daterange": "",
        "page": pageCount
      });
      singleton.formData = formData;
      i = 0;
      ref.refresh(
          marketingListProvider); // Fetch more data with updated page count
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _MarketingListData = ref.watch(marketingListProvider);

    return singleton.permissionList.contains("lead-create") == true
        ? Scaffold(
            floatingActionButton: Floating_Button(context, onTap: () {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Marketing_Form_Screen()))
                  .then((value) {
                if (value == true) {
                  formData = FormData.fromMap({
                    "executive_id": "",
                    "client_id": "",
                    "status_id": "",
                    "daterange": "",
                    "page": 1
                  });
                  singleton.formData = formData;
                  i = 0;
                  isRefresh = true;
                  marketingData = [];
                  ref.refresh(marketingListProvider);
                }
              });
            }, floatT: "Add Marketing"),
            backgroundColor: white5,
            appBar: Custom_AppBar(
                title: "Marketing List",
                actions: null,
                isGreen: false,
                isNav: true),
            body: _MarketingListData.when(
              data: (data) {
                if (i != 0) {
                  marketingData.addAll(data?.data?.marketings?.data ?? []);
                } else {
                  if (marketingData.length == 0 && !isRefresh) {
                    marketingData.addAll(data?.data?.marketings?.data ?? []);
                  }
                }
                isRefresh = false;
                i = 1;
                return SingleChildScrollView(
                  controller:
                      _scrollController, // Attach the scroll controller here

                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                              "daterange": dateRange,
                                              "page": pageCount
                                            });
                                            singleton.formData = formData;
                                            ref.refresh(marketingListProvider);
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
                          height: 20,
                        ),
                        Container(
                          width: MediaQuery.sizeOf(context).width,
                          child: _Marketing_List(ref, marketingData),
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
                title: "Marketing List",
                actions: null,
                isGreen: false,
                isNav: true),
            body: _MarketingListData.when(
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
                          child: _Marketing_List(
                              ref, data?.data?.marketings?.data ?? []),
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

Widget _Marketing_List(WidgetRef ref, List<MarketingListData>? data) {
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
                    builder: (context) => Marketing_History_List(
                          marketing_id: "${data[index].leadId}",
                        )));
          },
          child: Marketing_List(context,
              isTag: data![index].status ?? "",
              data: data![index],
              isHistory: true,
              ref: ref),
        ),
      );
    },
  );
}
