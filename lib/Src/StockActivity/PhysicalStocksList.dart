import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortune/Common_Widgets/Common_Button.dart';
import 'package:fortune/Common_Widgets/Common_List.dart';
import 'package:fortune/Common_Widgets/Custom_App_Bar.dart';
import 'package:fortune/Model/StocksModel.dart';
import 'package:fortune/Src/StockActivity/AddPhysicalStocks.dart';
import 'package:fortune/utilits/ApiProvider.dart';
import 'package:fortune/utilits/Common_Colors.dart';
import 'package:fortune/utilits/Generic.dart';

class PhysicalStocksList extends ConsumerStatefulWidget {
  PhysicalStocksList({super.key});

  @override
  ConsumerState<PhysicalStocksList> createState() => _PhysicalStocksListState();
}

class _PhysicalStocksListState extends ConsumerState<PhysicalStocksList> {
  // var user_Role = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // getRole();
  }

  // void getRole() async {
  //   final qww = await getUserRole();
  //   setState(() {
  //     user_Role = qww;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final _StocksListData = ref.watch(stocksListProvider);
    SingleTon singleton = SingleTon();

    return singleton.permissionList.contains("stock-create") == true
        ? Scaffold(
            floatingActionButton: Floating_Button(context, onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AddPhysicalStockScreen(data: null))).then((value) {
                if (value == true) {
                  setState(() {
                    ref.refresh(stocksListProvider);
                  });
                }
              });
            }, floatT: "Add Service"),
            backgroundColor: white5,
            appBar: Custom_AppBar(
                title: 'Manage Physical Stocks',
                actions: [],
                isGreen: false,
                isNav: true),
            body: _StocksListData.when(
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
                            child: _Stocks_List(
                                context, data?.data?.stocks?.data ?? [], ref),
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
                title: 'Daily Stock Activities',
                actions: [],
                isGreen: false,
                isNav: true),
            body: _StocksListData.when(
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
                            child: _Stocks_List(
                                context, data?.data?.stocks?.data ?? [], ref),
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
            ),
          );
  }
}

Widget _Stocks_List(context, List<StocksData>? data, WidgetRef ref) {
  return ListView.builder(
    itemCount: data?.length ?? 0,
    shrinkWrap: true,
    scrollDirection: Axis.vertical,
    physics: const NeverScrollableScrollPhysics(),
    itemBuilder: (BuildContext context, int index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child:
            StocksList(context, data: data![index], isHistory: true, ref: ref),
      );
    },
  );
}
