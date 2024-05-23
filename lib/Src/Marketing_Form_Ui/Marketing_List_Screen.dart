import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortune/Common_Widgets/Common_Button.dart';
import 'package:fortune/Common_Widgets/Common_List.dart';
import 'package:fortune/Common_Widgets/Custom_App_Bar.dart';
import 'package:fortune/Model/MarketingListModel.dart';
import 'package:fortune/Model/ServiceListModel.dart';
import 'package:fortune/Src/FilterScreen.dart/FilterScreen.dart';
import 'package:fortune/Src/Marketing_Form_Ui/Marketing_Form_Screen.dart';
import 'package:fortune/Src/Marketing_History_List/Marketing_History_List.dart';
import 'package:fortune/utilits/ApiProvider.dart';
import 'package:fortune/utilits/Common_Colors.dart';
import 'package:fortune/utilits/Generic.dart';

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

  Filter? filter;

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
        "client_id": singleton.filterClientnameID,
        "executive_id": singleton.filterSalesrepID,
        "status_id": singleton.filterStatusID,
        "daterange": singleton.filterDaterange,
        "company_id": singleton.filterCompanynameID,
        "daterange_type": singleton.filterDaterangeTypeID,
        "next_followup": singleton.filterNextFollowUpID,
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
                actions: <Widget>[
                  Stack(children: [
                    Padding(
                      padding: EdgeInsets.only(
                          right: 16.0), // Adjust the padding as needed
                      child: IconButton(
                        icon: Icon(Icons.filter_list),
                        onPressed: () {
                          // Add your search functionality here
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FilterScreen(
                                        filter: filter,
                                      ))).then((value) {
                            if (value == true) {
                              formData = FormData.fromMap({
                                "executive_id": singleton.filterSalesrepID,
                                "status_id": singleton.filterStatusID,
                                "daterange": singleton.filterDaterange,
                                "company_id": singleton.filterCompanynameID,
                                "daterange_type":
                                    singleton.filterDaterangeTypeID,
                                "next_followup": singleton.filterNextFollowUpID,
                                "page": 1
                              });
                              singleton.formData = formData;
                              i = 0;
                              isRefresh = true;
                              marketingData = [];
                              ref.refresh(marketingListProvider);
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
                filter = data?.data?.filter ?? Filter();

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
                actions: <Widget>[
                  Stack(children: [
                    Padding(
                      padding: EdgeInsets.only(
                          right: 16.0), // Adjust the padding as needed
                      child: IconButton(
                        icon: Icon(Icons.filter_list),
                        onPressed: () {
                          // Add your search functionality here
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FilterScreen(
                                        filter: filter,
                                      ))).then((value) {
                            if (value == true) {
                              formData = FormData.fromMap({
                                "executive_id": singleton.filterSalesrepID,
                                "status_id": singleton.filterStatusID,
                                "daterange": singleton.filterDaterange,
                                "company_id": singleton.filterCompanynameID,
                                "daterange_type":
                                    singleton.filterDaterangeTypeID,
                                "next_followup": singleton.filterNextFollowUpID,
                                "page": 1
                              });
                              singleton.formData = formData;
                              i = 0;
                              isRefresh = true;
                              marketingData = [];
                              ref.refresh(marketingListProvider);
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
  return ((data?.length ?? 0) != 0)
      ? ListView.builder(
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
        )
      : Center(child: Text("No Data Founds"));
}
