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

class Service_List_Screen extends ConsumerStatefulWidget {
  const Service_List_Screen({super.key});

  @override
  ConsumerState<Service_List_Screen> createState() =>
      _Service_List_ScreenState();
}

class _Service_List_ScreenState extends ConsumerState<Service_List_Screen> {
  var user_Role = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getRole();
  }

  void getRole() async {
    final qww = await getUserRole();
    setState(() {
      user_Role = qww;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _ServiceListData = ref.watch(serviceListProvider);

    return user_Role == "Admin"
        ? Scaffold(
            floatingActionButton: Floating_Button(context, onTap: () {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Service_Form_Screen()))
                  .then((value) {
                if (value == true) {
                  setState(() {
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
                          height: 20,
                        ),
                        Container(
                          width: MediaQuery.sizeOf(context).width,
                          child: _Service_List(ref, context,
                              data?.data?.services?.data ?? [], user_Role),
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
                          child: _Service_List(ref, context,
                              data?.data?.services?.data ?? [], user_Role),
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
          );
  }
}

Widget _Service_List(
    WidgetRef ref, context, List<ServicesData>? data, String user_Role) {
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
              ref: ref,
              user_role: user_Role),
        ),
      );
    },
  );
}
