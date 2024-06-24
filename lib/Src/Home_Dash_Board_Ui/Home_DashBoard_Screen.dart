import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortune/Common_Widgets/Common_List.dart';
import 'package:fortune/Common_Widgets/Custom_App_Bar.dart';
import 'package:fortune/Common_Widgets/Location_Picker.dart';
import 'package:fortune/Model/MarketingHistoryModel.dart';
import 'package:fortune/Model/ServiceHistoryModel.dart';
import 'package:fortune/Src/ClientScreen/Client_List_Screen.dart';
import 'package:fortune/Src/ItemsScreen/Items_List_Screen.dart';
import 'package:fortune/Src/Login_Ui/Login_Screen.dart';
import 'package:fortune/Src/Marketing_Form_Ui/Marketing_List_Screen.dart';
import 'package:fortune/Src/Marketing_History_List/Marketing_History_List.dart';
import 'package:fortune/Src/Service_Form_Ui/Service_List_Screen.dart';
import 'package:fortune/Src/Service_History_List_Ui/Service_Status_List_Screen.dart';
import 'package:fortune/Src/StockActivity/DailyStockActivityList.dart';
import 'package:fortune/Src/StockActivity/PhysicalStocksList.dart';
import 'package:fortune/utilits/ApiProvider.dart';
import 'package:fortune/utilits/Common_Colors.dart';
import 'package:fortune/utilits/Generic.dart';
import 'package:fortune/utilits/Text_Style.dart';

class Home_DashBoard_Screen extends ConsumerStatefulWidget {
  const Home_DashBoard_Screen({super.key});

  @override
  ConsumerState<Home_DashBoard_Screen> createState() =>
      _Home_DashBoard_ScreenState();
}

class _Home_DashBoard_ScreenState extends ConsumerState<Home_DashBoard_Screen> {
  var username = "";
  SingleTon singleton = SingleTon();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUsername();
  }

  getUsername() async {
    var getname = await getuserId();
    setState(() {
      username = getname;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _dashbaordData = ref.watch(dashboardProvider);

    singleton.filterSalesrep = null;
    singleton.filterSalesrepID = null;

    singleton.filterDaterange = null;

    singleton.filterStatus = null;
    singleton.filterStatusID = null;

    singleton.filterClientname = null;
    singleton.filterClientnameID = null;

    singleton.filterCompanyname = null;
    singleton.filterCompanynameID = null;

    singleton.filterBranchname = null;
    singleton.filterBranchnameID = null;

    singleton.filterDaterangeType = null;
    singleton.filterDaterangeTypeID = null;

    singleton.filterNextFollowUp = null;
    singleton.filterNextFollowUpID = null;

    singleton.filterEnable = false;
    singleton.formData = FormData();

    return Scaffold(
        appBar: Custom_AppBar(
            title: "Home Dashboard",
            actions: [
              PopupMenuButton(
                  surfaceTintColor: white1,
                  icon: Icon(
                    Icons.person_2_rounded,
                    color: white1,
                  ),
                  itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                            child: InkWell(
                                onTap: () async {
                                  String Boolvalue = "false";
                                  Routes(Boolvalue);
                                  accessToken("");
                                  UserId("");
                                  // UserRole("");
                                  SingleTon singleton = SingleTon();
                                  singleton.permissionList = [];
                                  print('ROUTES : ${Routes(Boolvalue)}');
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login_Screen()),
                                    ModalRoute.withName('/'),
                                  );
                                },
                                child: Text(
                                  'Log Out',
                                  style: refferalCountT,
                                ))),
                        // PopupMenuItem(child: Text('Download',style: refferalCountT,)),
                      ]),
            ],
            isGreen: true,
            isNav: false),
        backgroundColor: white5,
        body: _dashbaordData.when(
          data: (data) {
            singleton.permissionList =
                data?.data?.userRolePermission?.permissions ?? [];
            return Padding(
              padding: const EdgeInsets.only(left: 0, right: 0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: 50,
                        child: Booking_Map(
                          checkIncheckOut: data?.data?.checkIncheckOut,
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 20, bottom: 10),
                      child: Row(
                        children: [
                          Text(
                            "Hello ",
                            style: TBlack1,
                          ),
                          Text(
                            "${username}",
                            style: appTitle,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: (singleton.permissionList
                                      .contains("dashboard-item-count") ==
                                  true &&
                              singleton.permissionList
                                      .contains("dashboard-client-count") ==
                                  true)
                          ? MainAxisAlignment.spaceEvenly
                          : MainAxisAlignment.center,
                      children: [
                        singleton.permissionList
                                    .contains("dashboard-item-count") ==
                                true
                            ? InkWell(
                                onTap: () {
                                  if (singleton.permissionList
                                          .contains("item-list") ==
                                      true) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ItemsListScreen())).then(
                                        (value) =>
                                            ref.refresh(dashboardProvider));
                                  } else {}
                                },
                                child: _CountCard(
                                    countT: "${data?.data?.itemCount ?? 0}",
                                    cardName: "Items",
                                    isWhite: true,
                                    color: Colors.purple),
                              )
                            : Container(),
                        singleton.permissionList
                                    .contains("dashboard-client-count") ==
                                true
                            ? InkWell(
                                onTap: () {
                                  if (singleton.permissionList
                                          .contains("customer-list") ==
                                      true) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ClientListScreen())).then(
                                        (value) =>
                                            ref.refresh(dashboardProvider));
                                  } else {}
                                },
                                child: _CountCard(
                                    countT: "${data?.data?.clientCount ?? 0}",
                                    cardName: "Client",
                                    isWhite: true,
                                    color: Colors.pink),
                              )
                            : Container(),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: (singleton.permissionList
                                      .contains("dashboard-marketing-count") ==
                                  true &&
                              singleton.permissionList
                                      .contains("dashboard-service-count") ==
                                  true)
                          ? MainAxisAlignment.spaceEvenly
                          : MainAxisAlignment.center,
                      children: [
                        singleton.permissionList
                                    .contains("dashboard-marketing-count") ==
                                true
                            ? InkWell(
                                onTap: () {
                                  if (singleton.permissionList
                                          .contains("lead-list") ==
                                      true) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Marketing_List_Screen())).then(
                                        (value) =>
                                            ref.refresh(dashboardProvider));
                                  } else {}
                                },
                                child: _CountCard(
                                    countT:
                                        "${data?.data?.marketingCount ?? 0}",
                                    cardName: "Marketing",
                                    isWhite: true,
                                    color: red1),
                              )
                            : Container(),
                        singleton.permissionList
                                    .contains("dashboard-service-count") ==
                                true
                            ? InkWell(
                                onTap: () {
                                  if (singleton.permissionList
                                          .contains("service-list") ==
                                      true) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Service_List_Screen())).then(
                                        (value) =>
                                            ref.refresh(dashboardProvider));
                                  }
                                },
                                child: _CountCard(
                                    countT: "${data?.data?.servicesCount ?? 0}",
                                    cardName: "Service",
                                    isWhite: true,
                                    color: blue5),
                              )
                            : Container(),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: (singleton.permissionList
                                      .contains("activity-list") ==
                                  true &&
                              singleton.permissionList.contains("stock-list") ==
                                  true)
                          ? MainAxisAlignment.spaceEvenly
                          : MainAxisAlignment.center,
                      children: [
                        singleton.permissionList.contains("activity-list") ==
                                true
                            ? InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DailyStockActivityList())).then(
                                      (value) =>
                                          ref.refresh(dashboardProvider));
                                },
                                child: _ActivityCard(
                                    iconFile: Icons.edit_document,
                                    cardName: " Daily activity ",
                                    isWhite: true,
                                    color: green1),
                              )
                            : Container(),
                        singleton.permissionList.contains("stock-list") == true
                            ? InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PhysicalStocksList())).then(
                                      (value) =>
                                          ref.refresh(dashboardProvider));
                                },
                                child: _ActivityCard(
                                    iconFile:
                                        Icons.dashboard_customize_outlined,
                                    cardName: "Physical Stock",
                                    isWhite: true,
                                    color: orange1),
                              )
                            : Container(),
                      ],
                    ),
                    //TODAY LIST
                    singleton.permissionList
                                .contains("dashboard-today-marketing") ==
                            true
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            top: 20, bottom: 10, left: 10),
                                        child: Text(
                                          "Today's list of marketing to be visited",
                                          style: TBlack,
                                          maxLines: 2,
                                          overflow: TextOverflow
                                              .ellipsis, // Handle overflow with ellipsis
                                          textAlign: TextAlign.start,
                                        )),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                    // Use InkWell for a clickable effect
                                    onTap: () {
                                      Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Marketing_List_Screen()))
                                          .then((value) =>
                                              ref.refresh(dashboardProvider));
                                    },
                                    child: const Row(
                                      children: [
                                        Text(
                                          'View All',
                                          style: TextStyle(
                                            color: Colors
                                                .black, // Change color to match your design
                                          ),
                                        ),
                                        Icon(
                                          Icons
                                              .arrow_forward_ios, // Use any arrow icon you prefer
                                          size: 16, // Adjust size as needed
                                          color: Colors
                                              .black, // Change color to match your design
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 10)
                                ],
                              ),
                              Container(
                                  height:
                                      120, //MediaQuery.sizeOf(context).height / 9,
                                  child: Marketing_List(
                                      data?.data?.todayMarketings ?? [])),
                            ],
                          )
                        : Container(),

                    //SERVICE LIST
                    singleton.permissionList
                                .contains("dashboard-services-pending") ==
                            true
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Container(
                              //     width: MediaQuery.sizeOf(context).width / 1.2,
                              //     margin: EdgeInsets.only(
                              //         top: 20, bottom: 10, left: 10),
                              //     child: Text(
                              //       "Service didn’t closed for more than 5 days",
                              //       style: TBlack,
                              //       maxLines: 2,
                              //       textAlign: TextAlign.start,
                              //     )),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            top: 20, bottom: 10, left: 10),
                                        child: Text(
                                          "Service not closed for more than 5 days",
                                          style: TBlack,
                                          maxLines: 2,
                                          overflow: TextOverflow
                                              .ellipsis, // Handle overflow with ellipsis
                                          textAlign: TextAlign.start,
                                        )),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                    // Use InkWell for a clickable effect
                                    onTap: () {
                                      // Handle button click
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Service_List_Screen())).then(
                                          (value) =>
                                              ref.refresh(dashboardProvider));
                                    },
                                    child: const Row(
                                      children: [
                                        Text(
                                          'View All',
                                          style: TextStyle(
                                            color: Colors
                                                .black, // Change color to match your design
                                          ),
                                        ),
                                        Icon(
                                          Icons
                                              .arrow_forward_ios, // Use any arrow icon you prefer
                                          size: 16, // Adjust size as needed
                                          color: Colors
                                              .black, // Change color to match your design
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 10)
                                ],
                              ),
                              Container(
                                  height:
                                      120, //MediaQuery.sizeOf(context).height / 9,
                                  child:
                                      Service_List(data?.data?.services ?? [])),
                            ],
                          )
                        : Container(),

                    //HISTORY LIST
                    singleton.permissionList
                                .contains("dashboard-marketings-pending") ==
                            true
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Container(
                              //     width: MediaQuery.sizeOf(context).width / 1.2,
                              //     margin: EdgeInsets.only(
                              //         top: 20, bottom: 10, left: 10),
                              //     child: Text(
                              //       "Marketings didn’t updated for more than 5 days",
                              //       style: TBlack,
                              //       maxLines: 2,
                              //       textAlign: TextAlign.start,
                              //     )),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            top: 20, bottom: 10, left: 10),
                                        child: Text(
                                          "Marketing not updated for morethan 5 days",
                                          style: TBlack,
                                          maxLines: 2,
                                          overflow: TextOverflow
                                              .ellipsis, // Handle overflow with ellipsis
                                          textAlign: TextAlign.start,
                                        )),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                    // Use InkWell for a clickable effect
                                    onTap: () {
                                      Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Marketing_List_Screen()))
                                          .then((value) =>
                                              ref.refresh(dashboardProvider));
                                    },
                                    child: const Row(
                                      children: [
                                        Text(
                                          'View All',
                                          style: TextStyle(
                                            color: Colors
                                                .black, // Change color to match your design
                                          ),
                                        ),
                                        Icon(
                                          Icons
                                              .arrow_forward_ios, // Use any arrow icon you prefer
                                          size: 16, // Adjust size as needed
                                          color: Colors
                                              .black, // Change color to match your design
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 10)
                                ],
                              ),
                              Container(
                                  height:
                                      120, //MediaQuery.sizeOf(context).height / 9,
                                  child: Marketing_List(
                                      data?.data?.marketings ?? [])),
                            ],
                          )
                        : Container(),

                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
            );
          },
          error: (Object error, StackTrace stackTrace) {
            return Center(
                child: Text("Connection closed, Please login again!"));
          },
          loading: () => Center(child: CircularProgressIndicator()),
        ));
  }

  Widget _CountCard(
      {required String countT,
      required String cardName,
      required bool isWhite,
      required Color? color}) {
    return Container(
      width: MediaQuery.sizeOf(context).width / 2.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: color,
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Text(
              countT,
              style: isWhite == true ? WBlack1 : TBlack1,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              cardName,
              style: isWhite == true ? WcompanyDetailT : companyDetailT,
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
                color: Colors.transparent,
                child: Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "More info",
                        style: isWhite == true ? WcompanyDetailT : jobHeadingT,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.arrow_circle_right,
                        color: isWhite == true ? Colors.white : Colors.black,
                        size: 18,
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _ActivityCard(
      {required IconData iconFile,
      required String cardName,
      required bool isWhite,
      required Color? color}) {
    return Container(
      width: MediaQuery.sizeOf(context).width / 2.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: color,
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Icon(
              iconFile,
              color: white1,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              cardName,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
                color: Colors.transparent,
                child: Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "More info",
                        style: isWhite == true ? WcompanyDetailT : jobHeadingT,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.arrow_circle_right,
                        color: isWhite == true ? Colors.white : Colors.black,
                        size: 18,
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

Widget Service_List(List<ServicesData1> data) {
  if ((data.length) == 0) {
    return Center(
      child: Container(
          width: 150, //MediaQuery.sizeOf(context).width / 4,
          alignment: Alignment.topLeft,
          child: const Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            child: Center(
              child: Text(
                "No Record Found",
              ),
            ),
          )),
    );
  } else {
    return ListView.builder(
      itemCount: data.length,
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.only(left: 20),
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Service_History_List_Screen(
                            service_id: "${data[index].serviceId ?? 0}",
                          )));
            },
            child: Service_List_DashBoard(context,
                data: data[index].clientName ?? "",
                isTag: data[index].status ?? ""),
          ),
        );
      },
    );
  }
}

Widget Marketing_List(List<HistoryData> data) {
  if ((data.length) == 0) {
    return Center(
      child: Container(
          width: 150, //MediaQuery.sizeOf(context).width / 4,
          alignment: Alignment.topLeft,
          child: const Center(
            child: Text(
              "No Records Found",
            ),
          )),
    );
  } else {
    return ListView.builder(
      itemCount: data.length,
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.only(left: 20),
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Marketing_History_List(
                            marketing_id: "${data[index].leadId}",
                          )));
            },
            child: Service_List_DashBoard(context,
                data: data[index].clientName ?? "",
                isTag: data[index].status ?? ""),
          ),
        );
      },
    );
  }
}
