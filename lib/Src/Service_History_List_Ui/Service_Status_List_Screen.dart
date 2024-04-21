import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortune/Common_Widgets/Common_List.dart';
import 'package:fortune/Common_Widgets/Custom_App_Bar.dart';
import 'package:fortune/Model/ServiceListModel.dart';
import 'package:fortune/utilits/ApiProvider.dart';
import 'package:fortune/utilits/Common_Colors.dart';

class Service_History_List_Screen extends ConsumerStatefulWidget {
  const Service_History_List_Screen({super.key});

  @override
  ConsumerState<Service_History_List_Screen> createState() =>
      _Service_History_List_ScreenState();
}

class _Service_History_List_ScreenState
    extends ConsumerState<Service_History_List_Screen> {
  @override
  Widget build(BuildContext context) {
    final _ServiceListData = ref.watch(serviceListProvider);

    return Scaffold(
        backgroundColor: white5,
        appBar: Custom_AppBar(
            title: 'Service History', actions: [], isGreen: false, isNav: true),
        body: _ServiceListData.when(
          data: (data) {
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
                        child: _Service_List(
                            context, data?.data?.services?.data ?? []),
                      ),
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
        ));
  }
}

Widget _Service_List(context, List<ServicesData>? data) {
  return ListView.builder(
    itemCount: data?.length ?? 0,
    shrinkWrap: true,
    scrollDirection: Axis.vertical,
    physics: const NeverScrollableScrollPhysics(),
    itemBuilder: (BuildContext context, int index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: Service_List(context,
            data: data![index],
            isTag: data[index].status ?? "",
            isHistory: true),
      );
    },
  );
}
