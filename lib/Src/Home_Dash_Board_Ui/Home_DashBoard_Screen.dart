import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortune/Common_Widgets/Custom_App_Bar.dart';
import 'package:fortune/Common_Widgets/Location_Picker.dart';
import 'package:fortune/Src/Login_Ui/Login_Screen.dart';
import 'package:fortune/Src/Marketing_Form_Ui/Marketing_List_Screen.dart';
import 'package:fortune/Src/Service_Form_Ui/Service_List_Screen.dart';
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 50, child: Booking_Map()),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 20, bottom: 10),
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
                                          Marketing_List_Screen()))
                              .then((value) => ref.refresh(dashboardProvider));
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
                                          Service_List_Screen()))
                              .then((value) => ref.refresh(dashboardProvider));
                        },
                        child: _CountCard(
                            countT: "${data?.data?.servicesCount ?? 0}",
                            cardName: "Service",
                            isWhite: true,
                            color: blue1),
                      ),
                    ],
                  ),
                ],
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
}
