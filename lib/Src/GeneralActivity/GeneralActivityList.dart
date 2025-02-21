import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortune/Common_Widgets/Common_Button.dart';
import 'package:fortune/Common_Widgets/Common_List.dart';
import 'package:fortune/Common_Widgets/Custom_App_Bar.dart';
import 'package:fortune/Model/GeneralListModel.dart';
import 'package:fortune/Model/ServiceListModel.dart';
import 'package:fortune/Src/FilterScreen/FilterGeneralActivity.dart';
import 'package:fortune/Src/GeneralActivity/AddGeneralActivity.dart';
import 'package:fortune/Src/GeneralActivity/EditGeneralActivity.dart';
import 'package:fortune/utilits/ApiProvider.dart';
import 'package:fortune/utilits/Common_Colors.dart';
import 'package:fortune/utilits/Generic.dart';

class GeneralActivityListScreen extends ConsumerStatefulWidget {
  const GeneralActivityListScreen({super.key});

  @override
  ConsumerState<GeneralActivityListScreen> createState() =>
      _GeneralActivityListScreenState();
}

class _GeneralActivityListScreenState
    extends ConsumerState<GeneralActivityListScreen> {
  // var user_Role = "";
  var dateRange = "";
  var formData;
  var pageCount = 1;
  var i = 0;
  var isRefresh = false;

  SingleTon singleton = SingleTon();
  ScrollController _scrollController = ScrollController();
  List<GeneralListData> generalData = [];

  Filter? filter;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    formData = FormData.fromMap(
        {"client_id": singleton.filterClientnameID, "page_count": pageCount});
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
      formData = FormData.fromMap(
          {"client_id": singleton.filterClientnameID, "page_count": pageCount});
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
    final _GeneralListData = ref.watch(generalListProvider);

    return Scaffold(
      floatingActionButton: Floating_Button(context, onTap: () {
        Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddgeneralactivityScreen()))
            .then((value) {
          if (value == true) {
            formData = FormData.fromMap(
                {"client_id": singleton.filterClientnameID, "page_count": 1});
            singleton.formData = formData;
            i = 0;
            isRefresh = true;
            generalData = [];
            ref.refresh(generalListProvider);
          }
        });
      }, floatT: "Add Marketing"),
      backgroundColor: white5,
      appBar: Custom_AppBar(
          title: "General Activity List",
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
                            builder: (context) => FilterGeneralScreen(
                                  filter: filter,
                                ))).then((value) {
                      if (value == true) {
                        formData = FormData.fromMap({
                          "client_id": singleton.filterClientnameID,
                          "page_count": pageCount
                        });
                        singleton.formData = formData;

                        i = 0;
                        isRefresh = true;
                        generalData = [];

                        ref.refresh(generalListProvider);
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
      body: _GeneralListData.when(
        data: (data) {
          if (i != 0) {
            generalData.addAll(data?.data ?? []);
          } else {
            if (generalData.length == 0 && !isRefresh) {
              generalData.addAll(data?.data ?? []);
            }
          }
          isRefresh = false;
          i = 1;
          // filter = data?.data?.filter ?? Filter();

          return SingleChildScrollView(
            controller: _scrollController, // Attach the scroll controller here

            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.sizeOf(context).width,
                    child: _General_List(ref, generalData, (index) {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditGeneralScreen(
                                      marketing_id:
                                          "${generalData[index].followupId ?? 0}")))
                          .then((value) {
                        if (value == true) {
                          var formData = FormData.fromMap(
                              {"client_id": "", "page_count": 1});
                          singleton.formData = formData;

                          i = 0;
                          isRefresh = true;
                          generalData = [];

                          ref.refresh(generalListProvider);
                        }
                      });
                    }),
                  ),
                ],
              ),
            ),
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

Widget _General_List(WidgetRef ref, List<GeneralListData>? data,
    Function(int) incrementCounter) {
  return ((data?.length ?? 0) != 0)
      ? ListView.builder(
          itemCount: data?.length ?? 0,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: GeneralActivity_List(context,
                  isTag: data![index].status ?? "",
                  data: data![index],
                  isHistory: true, incrementCounter: () {
                incrementCounter(index);
              }),
            );
          },
        )
      : Center(child: Text("No Data Founds"));
}
