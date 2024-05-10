import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortune/Common_Widgets/Common_List.dart';
import 'package:fortune/Common_Widgets/Custom_App_Bar.dart';
import 'package:fortune/Common_Widgets/Location_Picker.dart';
import 'package:fortune/Model/MarketingHistoryModel.dart';
import 'package:fortune/Model/ServiceHistoryModel.dart';
import 'package:fortune/Src/Login_Ui/Login_Screen.dart';
import 'package:fortune/Src/Marketing_Form_Ui/Marketing_List_Screen.dart';
import 'package:fortune/Src/Service_Form_Ui/Service_List_Screen.dart';
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

    return Scaffold(
        appBar: Custom_AppBar(
            title: "Home Dash Board",
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
                                onTap: () {
                                  String Boolvalue = "false";
                                  Routes(Boolvalue);
                                  accessToken("");
                                  UserId("");
                                  UserRole("");

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
            return Padding(
              padding: const EdgeInsets.only(left: 0, right: 0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 50, child: Booking_Map()),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 20, bottom: 10),
                      child: Row(
                        children: [
                          Text(
                            "Hello, ",
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Marketing_List_Screen())).then(
                                (value) => ref.refresh(dashboardProvider));
                          },
                          child: _CountCard(
                              countT: "${data?.data?.marketingCount ?? 0}",
                              cardName: "Marketing",
                              isWhite: true,
                              color: red1),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Service_List_Screen())).then(
                                (value) => ref.refresh(dashboardProvider));
                          },
                          child: _CountCard(
                              countT: "${data?.data?.servicesCount ?? 0}",
                              cardName: "Service",
                              isWhite: true,
                              color: blue5),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DailyStockActivityList())).then(
                                (value) => ref.refresh(dashboardProvider));
                          },
                          child: _ActivityCard(
                              iconFile: Icons.edit_document,
                              cardName: " Daily Stock Activity ",
                              isWhite: true,
                              color: green1),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PhysicalStocksList())).then(
                                (value) => ref.refresh(dashboardProvider));
                          },
                          child: _ActivityCard(
                              iconFile: Icons.dashboard_customize_outlined,
                              cardName: "Physical Stock",
                              isWhite: true,
                              color: orange1),
                        ),
                      ],
                    ),
                    //TODAY LIST
                    Container(
                        width: MediaQuery.sizeOf(context).width / 1.2,
                        margin: EdgeInsets.only(top: 20, bottom: 10, left: 10),
                        child: Text(
                          "Today's list of MARKETING to be visited",
                          style: TBlack,
                          maxLines: 2,
                          textAlign: TextAlign.start,
                        )),
                    Container(
                        height: 120, //MediaQuery.sizeOf(context).height / 9,
                        child:
                            Marketing_List(data?.data?.todayMarketings ?? [])),

                    //SERVICE LIST
                    Container(
                        width: MediaQuery.sizeOf(context).width / 1.2,
                        margin: EdgeInsets.only(top: 20, bottom: 10, left: 10),
                        child: Text(
                          "SERVICES didn’t closed for more than 5 days",
                          style: TBlack,
                          maxLines: 2,
                          textAlign: TextAlign.start,
                        )),

                    Container(
                        height: 120, //MediaQuery.sizeOf(context).height / 9,
                        child: Service_List(data?.data?.services ?? [])),
                    //HISTORY LIST
                    Container(
                        width: MediaQuery.sizeOf(context).width / 1.2,
                        margin: EdgeInsets.only(top: 20, bottom: 10, left: 10),
                        child: Text(
                          "MARKETINGS didn’t updated for more than 5 days",
                          style: TBlack,
                          maxLines: 2,
                          textAlign: TextAlign.start,
                        )),
                    Container(
                        height: 120, //MediaQuery.sizeOf(context).height / 9,
                        child: Marketing_List(data?.data?.marketings ?? [])),

                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
            );
          },
          error: (Object error, StackTrace stackTrace) {
            return Text(error.toString());
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
                        style: isWhite == true ? WjobHeadingT : jobHeadingT,
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
                        style: isWhite == true ? WjobHeadingT : jobHeadingT,
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
          child: Service_List_DashBoard(context,
              data: data[index].clientName ?? "",
              isTag: data[index].status ?? ""),
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
          child: Service_List_DashBoard(context,
              data: "Arun dsdsad SDAFSDFSF SDSAD", isTag: 'cancelled'),
        );
      },
    );
  }
}
