import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortune/Common_Widgets/Common_Button.dart';
import 'package:fortune/Common_Widgets/Common_List.dart';
import 'package:fortune/Common_Widgets/Custom_App_Bar.dart';
import 'package:fortune/Model/ServiceListModel.dart';
import 'package:fortune/Src/FilterScreen.dart/FilterServiceScreen.dart';
import 'package:fortune/Src/Service_Form_Ui/Service_Form_Screen.dart';
import 'package:fortune/Src/Service_History_List_Ui/Service_Status_List_Screen.dart';
import 'package:fortune/utilits/ApiProvider.dart';
import 'package:fortune/utilits/Common_Colors.dart';
import 'package:fortune/utilits/Generic.dart';

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
  Filter? filter;

  late ScrollController _scrollController;
  late ValueNotifier<bool> _isLoadingMore;

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

    _scrollController = ScrollController();
    _isLoadingMore = ValueNotifier(false);

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _isLoadingMore.dispose();
    super.dispose();
  }

  void _onScroll() {
    print("object");
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoadingMore.value) {
      _isLoadingMore.value = true;
      // Fetch more data
      // Call a function to load more data and update the provider
      // For example, you might call a function like fetchMoreData()
      print("object1");

      fetchMoreData();
    }
  }

  Future<void> fetchMoreData() async {
    // Fetch more data and update the provider
    // Example:
    // final moreData = await fetchData(page: currentPage + 1);
    // currentPage++;
    // ref.read(serviceListProvider).data?.data?.services?.data?.addAll(moreData.data?.data?.services?.data);

    _isLoadingMore.value = false;
  }

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
                                  builder: (context) => FilterServiceScreen(
                                        filter: filter,
                                      ))).then((value) {
                            if (value == true) {
                              setState(() {
                                formData = FormData.fromMap({
                                  "executive_id": singleton.filterSalesrepID,
                                  "client_id": singleton.filterClientnameID,
                                  "status_id": singleton.filterStatusID,
                                  "daterange": singleton.filterDaterange,
                                  "company_id": singleton.filterCompanynameID
                                });
                                singleton.formData = formData;

                                ref.refresh(serviceListProvider);
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
            body: _ServiceListData.when(
              data: (data) {
                filter = data?.data?.filter ?? Filter();
                return Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 30),
                  child: Container(
                      width: MediaQuery.sizeOf(context).width,
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: data?.data?.services?.data?.length ?? 0,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        // physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Service_History_List_Screen(
                                              service_id:
                                                  "${data?.data?.services?.data?[index].serviceId ?? 0}",
                                            )));
                              },
                              child: Service_List(context,
                                  data: data?.data?.services?.data?[index] ??
                                      ServicesData(),
                                  isTag: data?.data?.services?.data?[index]
                                          .status ??
                                      "",
                                  isHistory: false,
                                  ref: ref),
                            ),
                          );
                        },
                      )),
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
                                  builder: (context) => FilterServiceScreen(
                                        filter: filter,
                                      ))).then((value) {
                            if (value == true) {
                              setState(() {
                                formData = FormData.fromMap({
                                  "executive_id": singleton.filterSalesrepID,
                                  "client_id": singleton.filterClientnameID,
                                  "status_id": singleton.filterStatusID,
                                  "daterange": singleton.filterDaterange,
                                  "company_id": singleton.filterCompanynameID
                                });
                                singleton.formData = formData;

                                ref.refresh(serviceListProvider);
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
                            child: ListView.builder(
                              controller: _scrollController,
                              itemCount:
                                  data?.data?.services?.data?.length ?? 0,
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
                                              builder: (context) =>
                                                  Service_History_List_Screen(
                                                    service_id:
                                                        "${data?.data?.services?.data?[index].serviceId ?? 0}",
                                                  )));
                                    },
                                    child: Service_List(context,
                                        data: data?.data?.services
                                                ?.data?[index] ??
                                            ServicesData(),
                                        isTag: data?.data?.services
                                                ?.data?[index].status ??
                                            "",
                                        isHistory: false,
                                        ref: ref),
                                  ),
                                );
                              },
                            )
                            // _Service_List(
                            //     ref, context, data?.data?.services?.data ?? []),
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

// Widget _Service_List(WidgetRef ref, context, List<ServicesData>? data) {
//   return ListView.builder(
//     itemCount: data?.length ?? 0,
//     shrinkWrap: true,
//     scrollDirection: Axis.vertical,
//     physics: const NeverScrollableScrollPhysics(),
//     itemBuilder: (BuildContext context, int index) {
//       return Padding(
//         padding: const EdgeInsets.only(bottom: 0),
//         child: InkWell(
//           onTap: () {
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => Service_History_List_Screen(
//                           service_id: "${data[index].serviceId ?? 0}",
//                         )));
//           },
//           child: Service_List(context,
//               data: data![index],
//               isTag: data[index].status ?? "",
//               isHistory: false,
//               ref: ref),
//         ),
//       );
//     },
//   );
// }
