import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortune/Common_Widgets/Common_Button.dart';
import 'package:fortune/Common_Widgets/Text_Form_Field.dart';
import 'package:fortune/Model/SuccessModel.dart';
import 'package:fortune/utilits/ApiProvider.dart';
import 'package:fortune/utilits/ApiService.dart';
import 'package:fortune/utilits/ConstantsApi.dart';
import 'package:fortune/utilits/Generic.dart';
import 'package:fortune/utilits/Loading_Overlay.dart';

class AddPhysicalStockScreen extends ConsumerStatefulWidget {
  bool isEdit;
  String stockId;

  AddPhysicalStockScreen(
      {super.key, required this.isEdit, required this.stockId});

  @override
  _AddPhysicalStockScreenState createState() => _AddPhysicalStockScreenState();
}

class _AddPhysicalStockScreenState
    extends ConsumerState<AddPhysicalStockScreen> {
  TextEditingController _ItemName = TextEditingController();
  TextEditingController _AvailableStock = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Map<String, String>> itemsData = [];
  bool isvalueUpdated = false;
  List<FocusNode> focus = [];

  @override
  void initState() {
    super.initState();
    // Add one item row by default

    if (widget.isEdit == false) {
      itemsData = [
        {
          'productID': "",
          'productName': "",
          'quantity': "",
        }
      ];
      final focusCount = FocusNode();
      focus = [focusCount];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isEdit == true) {
      final _StocksItem = ref.watch(stocksEditProvider(widget.stockId));
      return Scaffold(
        appBar: AppBar(title: Text('Edit Physical Stocks')),
        body: _StocksItem.when(
          data: (data) {
            if (isvalueUpdated == false) {
              isvalueUpdated = true;

              final dict = data?.data?.data?.itemName ?? "";
              final dict1 = data?.data?.data?.availableStock ?? "";
              // final dict2 = data?.data?.data?.items?[i]. ?? "";

              int index =
                  data!.data!.items!.indexWhere((st) => "${st.id}" == dict);

              final getValue = {
                'productID': "${data.data!.items![index].id}",
                'productName': "${data.data!.items![index].itemName}",
                'quantity': dict1,
              };
              itemsData.add(getValue);
              final focusCount = FocusNode();
              focus = [focusCount];
            }

            return Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: ListView(
                  children: [
                    SizedBox(height: 20.0),
                    // Add space between items
                    for (int i = 0; i < itemsData.length; i++)
                      Column(
                        children: [
                          SizedBox(height: 16.0),

                          dropDownSearchField(
                            context,
                            listValue: data?.data?.items ?? [],
                            onChanged: ((x) {
                              focus[i].unfocus();

                              setState(() {
                                int index = data!.data!.items!.indexWhere(
                                    (st) => st.itemName == x.searchKey);

                                final getValue = {
                                  'productID': "${data.data!.items?[index].id}",
                                  'productName': "${x.searchKey}",
                                  'quantity': "${itemsData[i]["quantity"]}",
                                };
                                itemsData.removeAt(i);
                                itemsData.insert(i, getValue);
                              });
                            }),
                            focus: focus[i],
                            validator: (x) {
                              int index = data!.data!.items!
                                  .indexWhere((st) => st.itemName == x);

                              if (index == -1) {
                                return 'Please Choose Items';
                              }
                              return null;
                            },
                            hintText: 'Search Items',
                            initValue: itemsData[i]["productName"] == ""
                                ? ""
                                : itemsData[i]["productName"] ?? "",
                          ),
                          // dropDownField7(
                          //   hintT: 'Select Items',
                          //   context,
                          //   value: itemsData[i]["productName"] == ""
                          //       ? null
                          //       : itemsData[i]["productName"],
                          //   listValue: data?.data?.items ?? [],
                          //   onChanged: (String? newValue) {
                          //     setState(() {
                          //       int index = data!.data!.items!.indexWhere(
                          //           (st) => st.itemName == newValue);

                          //       final getValue = {
                          //         'productID': "${data.data!.items![index].id}",
                          //         'productName': "${newValue}",
                          //         'quantity': "${itemsData[i]["quantity"]}",
                          //       };
                          //       itemsData.removeAt(i);
                          //       itemsData.insert(i, getValue);
                          //     });
                          //   },
                          // ),

                          SizedBox(height: 16.0),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: TextFormField(
                                    controller: TextEditingController()
                                      ..text = itemsData[i]["quantity"] ?? "",

                                    // initialValue: itemsData[i]["quantity"],
                                    onChanged: (typed) {
                                      // setState(() {
                                      final getValue = {
                                        'productID':
                                            "${itemsData[i]["productID"]}",
                                        'productName':
                                            "${itemsData[i]["productName"]}",
                                        'quantity': typed,
                                      };
                                      itemsData.removeAt(i);
                                      itemsData.insert(i, getValue);
                                      // });
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 20.0, horizontal: 20.0),
                                      labelText: 'Quantity',
                                      border: OutlineInputBorder(),
                                      hintText: 'Enter quantity',
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Enter Quantity";
                                      }

                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              // Container(
                              //   padding: EdgeInsets.only(right: 35),
                              //   child: i == 0
                              //       ? IconButton(
                              //           alignment: Alignment.topRight,
                              //           icon: Icon(Icons.add_box),
                              //           onPressed: () {
                              //             setState(() {
                              //               final tempArr = {
                              //                 'productID': "",
                              //                 'productName': "",
                              //                 'quantity': "",
                              //               };

                              //               itemsData.add(tempArr);
                              //             });
                              //           },
                              //         )
                              //       : IconButton(
                              //           alignment: Alignment.topRight,
                              //           icon: Icon(Icons.remove_circle),
                              //           onPressed: () {
                              //             setState(() {
                              //               itemsData.removeAt(i);
                              //             });
                              //           },
                              //         ),
                              // ),
                            ],
                          ),

                          SizedBox(height: 30.0), // Add space between items
                        ],
                      ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: CommonElevatedButton(
                        context,
                        "Update",
                        () {
                          if (_formKey.currentState!.validate()) {
                            List<String> idList = itemsData
                                .map((item) => "${item["productID"] ?? ""}")
                                .toList();

                            List<String> idList1 = itemsData
                                .map((item) => "${item["quantity"] ?? ""}")
                                .toList();

                            var formData = FormData.fromMap({
                              for (var i = 0; i < idList.length; i++)
                                'item_name': idList[i],
                              for (var j = 0; j < idList1.length; j++)
                                'available_stock': idList1[j],
                              "_method": "PUT",
                            });
                            addStockItems(formData);
                          }
                        },
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
    } else {
      final _StocksItem = ref.watch(stocksItemProvider);
      return Scaffold(
        appBar: AppBar(
          title: Text('Add Physical Stocks'),
        ),
        body: _StocksItem.when(
          data: (data) {
            return Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: ListView(
                  children: [
                    SizedBox(height: 20.0),
                    // Add space between items
                    for (int i = 0; i < itemsData.length; i++)
                      Column(
                        children: [
                          SizedBox(height: 16.0),
                          // dropDownField7(
                          //   hintT: 'Select Items',
                          //   context,
                          //   value: itemsData[i]["productName"] == ""
                          //       ? null
                          //       : itemsData[i]["productName"],
                          //   listValue: data?.data ?? [],
                          //   onChanged: (String? newValue) {
                          //     setState(() {
                          //       int index = data!.data!.indexWhere(
                          //           (st) => st.itemName == newValue);

                          //       final getValue = {
                          //         'productID': "${data.data![index].id}",
                          //         'productName': "${newValue}",
                          //         'quantity': "${itemsData[i]["quantity"]}",
                          //       };
                          //       itemsData.removeAt(i);
                          //       itemsData.insert(i, getValue);
                          //     });
                          //   },
                          // ),

                          dropDownSearchField(
                            context,
                            listValue: data?.data ?? [],
                            onChanged: ((x) {
                              focus[i].unfocus();

                              setState(() {
                                int index = data!.data!.indexWhere(
                                    (st) => st.itemName == x.searchKey);

                                final getValue = {
                                  'productID': "${data.data![index].id}",
                                  'productName': "${x.searchKey}",
                                  'quantity': "${itemsData[i]["quantity"]}",
                                };
                                itemsData.removeAt(i);
                                itemsData.insert(i, getValue);
                              });
                            }),
                            focus: focus[i],
                            validator: (x) {
                              int index = data!.data!
                                  .indexWhere((st) => st.itemName == x);

                              if (index == -1) {
                                return 'Please Choose Items';
                              }
                              return null;
                            },
                            hintText: 'Search Items',
                            initValue: '',
                          ),
                          SizedBox(height: 16.0),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: TextFormField(
                                    controller: TextEditingController()
                                      ..text = itemsData[i]["quantity"] ?? "",

                                    // initialValue: itemsData[i]["quantity"],
                                    onChanged: (typed) {
                                      // setState(() {
                                      final getValue = {
                                        'productID':
                                            "${itemsData[i]["productID"]}",
                                        'productName':
                                            "${itemsData[i]["productName"]}",
                                        'quantity': typed,
                                      };
                                      itemsData.removeAt(i);
                                      itemsData.insert(i, getValue);
                                      // });
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 20.0, horizontal: 20.0),
                                      labelText: 'Quantity',
                                      border: OutlineInputBorder(),
                                      hintText: 'Enter quantity',
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Enter Quantity";
                                      }

                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 35),
                                child: i == 0
                                    ? IconButton(
                                        alignment: Alignment.topRight,
                                        icon: Icon(Icons.add_box),
                                        onPressed: () {
                                          setState(() {
                                            final tempArr = {
                                              'productID': "",
                                              'productName': "",
                                              'quantity': "",
                                            };

                                            itemsData.add(tempArr);
                                            final focusCount = FocusNode();
                                            focus.add(focusCount);
                                          });
                                        },
                                      )
                                    : IconButton(
                                        alignment: Alignment.topRight,
                                        icon: Icon(Icons.remove_circle),
                                        onPressed: () {
                                          setState(() {
                                            itemsData.removeAt(i);
                                            focus.removeAt(i);
                                          });
                                        },
                                      ),
                              ),
                            ],
                          ),

                          SizedBox(height: 30.0), // Add space between items
                        ],
                      ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: CommonElevatedButton(
                        context,
                        "Submit",
                        () {
                          if (_formKey.currentState!.validate()) {
                            List<String> idList = itemsData
                                .map((item) => "${item["productID"] ?? ""}")
                                .toList();

                            List<String> idList1 = itemsData
                                .map((item) => "${item["quantity"] ?? ""}")
                                .toList();

                            var formData = FormData.fromMap({
                              for (var i = 0; i < idList.length; i++)
                                'item[$i][item_name]': idList[i],
                              for (var j = 0; j < idList1.length; j++)
                                'item[$j][available_stock]': idList1[j],
                            });
                            addStockItems(formData);
                          }
                        },
                      ),
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

  void addStockItems(FormData data) async {
    LoadingOverlay.show(context);

    final apiService = ApiService(ref.read(dioProvider));

    var url = "";
    if (widget.isEdit == true) {
      url = ConstantApi.stocksCreate + "/${widget.stockId ?? 0}";
    } else {
      url = ConstantApi.stocksCreate;
    }

    final postResponse = await apiService.post<SuccessModel>(url, data);
    LoadingOverlay.forcedStop();

    if (postResponse.success == true) {
      ShowToastMessage(postResponse.message ?? "");
      Navigator.pop(context, true);
    } else {
      ShowToastMessage(postResponse.message ?? "");
    }
  }
}
