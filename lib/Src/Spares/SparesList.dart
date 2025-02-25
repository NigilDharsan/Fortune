import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortune/Common_Widgets/Common_Button.dart';
import 'package:fortune/Common_Widgets/Common_List.dart';
import 'package:fortune/Common_Widgets/Custom_App_Bar.dart';
import 'package:fortune/Model/ServiceListModel.dart';
import 'package:fortune/Model/SparesListModel.dart';
import 'package:fortune/Src/FilterScreen/FilterSpares.dart';
import 'package:fortune/Src/Spares/AddSpares.dart';
import 'package:fortune/utilits/ApiProvider.dart';
import 'package:fortune/utilits/Common_Colors.dart';
import 'package:fortune/utilits/Generic.dart';

class Spareslist extends ConsumerStatefulWidget {
  Spareslist({super.key});

  @override
  ConsumerState<Spareslist> createState() => _SpareslistState();
}

class _SpareslistState extends ConsumerState<Spareslist> {
  // var user_Role = "";
  Filter? filter;
  var formData;
  SingleTon singleton = SingleTon();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    formData = FormData.fromMap({"servicereps_involved": "", "page_count": 1});
    singleton.formData = formData;
  }

  // void getRole() async {
  //   final qww = await getUserRole();
  //   setState(() {
  //     user_Role = qww;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final _SparesListData = ref.watch(spareListProvider);
    SingleTon singleton = SingleTon();

    return Scaffold(
      floatingActionButton: Floating_Button(context, onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddSpareScreen(
                      isEdit: false,
                      stockId: "",
                    ))).then((value) {
          if (value == true) {
            setState(() {
              formData = FormData.fromMap(
                  {"servicereps_involved": "", "page_count": 1});
              singleton.formData = formData;

              ref.refresh(spareListProvider);
            });
          }
        });
      }, floatT: "Add Service"),
      backgroundColor: white5,
      appBar: Custom_AppBar(
          title: 'Spares',
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
                            builder: (context) => FilterSparesScreen(
                                  filter: filter,
                                ))).then((value) {
                      if (value == true) {
                        setState(() {
                          formData = FormData.fromMap({
                            "servicereps_involved": singleton.filterSalesrepID,
                            "page_count": 1
                          });

                          singleton.formData = formData;

                          ref.refresh(spareListProvider);
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
      body: _SparesListData.when(
        data: (data) {
          // filter = data?.data?.filter ?? Filter();

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
                      child: _Stocks_List(context, data?.data ?? [], ref),
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
    );
  }
}

Widget _Stocks_List(context, List<SparesData>? data, WidgetRef ref) {
  if ((data?.length ?? 0) != 0) {
    return ListView.builder(
      itemCount: data?.length ?? 0,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: SparesList(context,
              data: data![index], isHistory: true, ref: ref),
        );
      },
    );
  } else {
    return Center(child: Text("No Data Found!"));
  }
}
