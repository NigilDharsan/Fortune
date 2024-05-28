import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortune/Common_Widgets/Common_List.dart';
import 'package:fortune/Common_Widgets/Custom_App_Bar.dart';
import 'package:fortune/Model/MarketingHistoryModel.dart';
import 'package:fortune/utilits/ApiProvider.dart';
import 'package:fortune/utilits/Common_Colors.dart';

class Marketing_History_List extends ConsumerStatefulWidget {
  String marketing_id = "";

  Marketing_History_List({super.key, required this.marketing_id});

  @override
  ConsumerState<Marketing_History_List> createState() =>
      _Marketing_History_ListState();
}

class _Marketing_History_ListState
    extends ConsumerState<Marketing_History_List> {
  @override
  Widget build(BuildContext context) {
    final _MarketingListData =
        ref.watch(marketingHistoryProvider(widget.marketing_id));

    return Scaffold(
      backgroundColor: white5,
      appBar: Custom_AppBar(
          title: "Marketing History",
          actions: null,
          isGreen: false,
          isNav: true),
      body: _MarketingListData.when(
        data: (data) {
          return SingleChildScrollView(
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
                    child: (data?.data?.marketing?.data ?? []) != []
                        ? _Marketing_List(data?.data?.marketing?.data ?? [])
                        : Center(child: Text("No History!")),
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

Widget _Marketing_List(List<HistoryData>? data) {
  return ListView.builder(
    itemCount: data?.length ?? 0,
    shrinkWrap: true,
    scrollDirection: Axis.vertical,
    physics: const NeverScrollableScrollPhysics(),
    itemBuilder: (BuildContext context, int index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: Marketing_History(context,
            isTag: data![index].status ?? "",
            data: data[index],
            isHistory: true),
      );
    },
  );
}
