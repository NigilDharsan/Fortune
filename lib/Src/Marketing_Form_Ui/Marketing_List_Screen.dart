import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortune/Common_Widgets/Common_Button.dart';
import 'package:fortune/Common_Widgets/Common_List.dart';
import 'package:fortune/Common_Widgets/Custom_App_Bar.dart';
import 'package:fortune/Model/MarketingListModel.dart';
import 'package:fortune/Src/Marketing_Form_Ui/Marketing_Form_Screen.dart';
import 'package:fortune/Src/Marketing_History_List/Marketing_History_List.dart';
import 'package:fortune/utilits/ApiProvider.dart';
import 'package:fortune/utilits/Common_Colors.dart';

class Marketing_List_Screen extends ConsumerStatefulWidget {
  const Marketing_List_Screen({super.key});

  @override
  ConsumerState<Marketing_List_Screen> createState() =>
      _Marketing_List_ScreenState();
}

class _Marketing_List_ScreenState extends ConsumerState<Marketing_List_Screen> {
  @override
  Widget build(BuildContext context) {
    final _MarketingListData = ref.watch(marketingListProvider);

    return Scaffold(
      floatingActionButton: Floating_Button(context, onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Marketing_Form_Screen())).then((value) {
          if (value == true) {
            ref.refresh(marketingListProvider);
          }
        });
      }, floatT: "Add Marketing"),
      backgroundColor: white5,
      appBar: Custom_AppBar(
          title: "Marketing List", actions: null, isGreen: false, isNav: true),
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
                    child: _Marketing_List(data?.data?.marketings?.data ?? []),
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

Widget _Marketing_List(List<MarketingListData>? data) {
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
                    builder: (context) => Marketing_History_List()));
          },
          child: Marketing_List(context,
              isTag: data![index].status ?? "",
              data: data![index],
              isHistory: false),
        ),
      );
    },
  );
}
