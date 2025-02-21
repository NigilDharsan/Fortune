import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortune/Common_Widgets/Common_Button.dart';
import 'package:fortune/Common_Widgets/Common_List.dart';
import 'package:fortune/Common_Widgets/Custom_App_Bar.dart';
import 'package:fortune/Model/ClientsModel.dart';
import 'package:fortune/Model/ServiceListModel.dart';
import 'package:fortune/Src/ClientScreen/AddClientScreen.dart';
import 'package:fortune/Src/FilterScreen/FilterClientScreeen.dart';
import 'package:fortune/utilits/ApiProvider.dart';
import 'package:fortune/utilits/Common_Colors.dart';
import 'package:fortune/utilits/Generic.dart';

class ClientListScreen extends ConsumerStatefulWidget {
  ClientListScreen({super.key});

  @override
  ConsumerState<ClientListScreen> createState() => _ClientListScreenState();
}

class _ClientListScreenState extends ConsumerState<ClientListScreen> {
  // var user_Role = "";
  Filter? filter;
  var formData;
  SingleTon singleton = SingleTon();
  ScrollController _scrollController = ScrollController();

  List<ClientsDataObject> clientData = [];

  var pageCount = 1;
  var i = 0;
  var isRefresh = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    formData =
        FormData.fromMap({"cus_first_name": "", "gst_no": "", "page": 1});
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
          {"cus_first_name": "", "gst_no": "", "page": pageCount});
      singleton.formData = formData;
      i = 0;
      ref.refresh(
          clientsListProvider); // Fetch more data with updated page count
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _ClientListData = ref.watch(clientsListProvider);
    SingleTon singleton = SingleTon();

    return singleton.permissionList.contains("customer-create") == true
        ? Scaffold(
            floatingActionButton: Floating_Button(context, onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddClientScreen(
                            isEdit: false,
                            clientId: "",
                          ))).then((value) {
                if (value == true) {
                  setState(() {
                    formData = FormData.fromMap(
                        {"cus_first_name": "", "gst_no": "", "page": 1});
                    singleton.formData = formData;

                    i = 0;
                    isRefresh = true;
                    clientData = [];

                    ref.refresh(clientsListProvider);
                  });
                }
              });
            }, floatT: "Add Service"),
            backgroundColor: white5,
            appBar: Custom_AppBar(
                title: 'Clients',
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
                                  builder: (context) => FilterClientScreen(
                                        filter: filter,
                                      ))).then((value) {
                            if (value == true) {
                              setState(() {
                                formData = FormData.fromMap({
                                  "cus_first_name": singleton.filterClientname,
                                  "gst_no": singleton.filterClientnameID,
                                  "page": 1
                                });

                                singleton.formData = formData;
                                i = 0;
                                isRefresh = true;
                                clientData = [];

                                ref.refresh(clientsListProvider);
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
            body: _ClientListData.when(
              data: (data) {
                if (i != 0) {
                  clientData.addAll(data?.data?.clients?.data ?? []);
                } else {
                  if (clientData.length == 0 && !isRefresh) {
                    clientData.addAll(data?.data?.clients?.data ?? []);
                  }
                }
                isRefresh = false;
                i = 1;
                filter = data?.data?.filter;

                return SingleChildScrollView(
                  controller: _scrollController,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 30),
                          child: Container(
                            width: MediaQuery.sizeOf(context).width,
                            child: _Clients_List(context, clientData, ref),
                          ),
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
          )
        : Scaffold(
            backgroundColor: white5,
            appBar: Custom_AppBar(
                title: 'Clients',
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
                                  builder: (context) => FilterClientScreen(
                                        filter: filter,
                                      ))).then((value) {
                            if (value == true) {
                              setState(() {
                                formData = FormData.fromMap({
                                  "cus_first_name": singleton.filterClientname,
                                  "gst_no": singleton.filterClientnameID
                                });
                                singleton.formData = formData;
                                i = 0;
                                isRefresh = true;
                                clientData = [];

                                ref.refresh(stocksListProvider);
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
            body: _ClientListData.when(
              data: (data) {
                if (i != 0) {
                  clientData.addAll(data?.data?.clients?.data ?? []);
                } else {
                  if (clientData.length == 0 && !isRefresh) {
                    clientData.addAll(data?.data?.clients?.data ?? []);
                  }
                }
                isRefresh = false;
                i = 1;

                filter = data?.data?.filter ?? Filter();

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 30),
                          child: Container(
                            width: MediaQuery.sizeOf(context).width,
                            child: _Clients_List(context, clientData, ref),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              error: (Object error, StackTrace stackTrace) {
                return Center(
                    child: Text("Connection closed, Please try again!"));
              },
              loading: () => Center(child: CircularProgressIndicator()),
            ),
          );
  }
}

Widget _Clients_List(context, List<ClientsDataObject>? data, WidgetRef ref) {
  if ((data?.length ?? 0) != 0) {
    return ListView.builder(
      itemCount: data?.length ?? 0,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: ClientsList(context,
              data: data![index], isHistory: true, ref: ref),
        );
      },
    );
  } else {
    return Center(child: Text("No Data Found!"));
  }
}
