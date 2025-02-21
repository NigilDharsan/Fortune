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
import 'package:fortune/utilits/Text_Style.dart';

class AddSpareScreen extends ConsumerStatefulWidget {
  bool isEdit;
  String stockId;

  AddSpareScreen({super.key, required this.isEdit, required this.stockId});

  @override
  _AddSpareScreennState createState() => _AddSpareScreennState();
}

class _AddSpareScreennState extends ConsumerState<AddSpareScreen> {
  TextEditingController _ItemName = TextEditingController();
  TextEditingController _AvailableStock = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Map<String, String>> itemsData = [];
  bool isvalueUpdated = false;
  List<FocusNode> focus = [];
  var focus1 = FocusNode();
  String executive_id = "";

  @override
  void initState() {
    super.initState();
    // Add one item row by default

    if (widget.isEdit == false) {
      itemsData = [
        {
          'item_id': "",
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
      final _SparesItem = ref.watch(sparesEditProvider(widget.stockId));
      final _MarketingData = ref.watch(marketingDataProvider);

      return Scaffold(
        appBar: AppBar(title: Text('Edit Spares')),
        body: _SparesItem.when(
          data: (sparedata) {
            if (isvalueUpdated == false) {
              isvalueUpdated = true;

              final getValue = sparedata!.data!
                  .map((spares) => {
                        'spare_id': "${spares.spareId}",
                        'item_id': "${spares.itemId}",
                        'productName': "${spares.itemName}",
                        'quantity': "${spares.quantity}",
                      })
                  .toList();

              executive_id = "${sparedata.data?[0].servicerepsInvolved}";

              itemsData.addAll(getValue);
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

                    _MarketingData.when(
                      data: (data) {
                        int index = data!.data!.executives!.indexWhere((st) =>
                            st.id == sparedata?.data?[0].servicerepsInvolved);
                        return Container(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Title_Style(
                                    Title: "Assign Executive", isStatus: true),
                              ),
                              dropDownExecutivesSearchField(
                                context,
                                listValue: data?.data?.executives ?? [],
                                onChanged: ((x) {
                                  focus1.unfocus();

                                  setState(() {
                                    print(x.searchKey);
                                    int index = data!.data!.executives!
                                        .indexWhere(
                                            (st) => st.name == x.searchKey);
                                    executive_id =
                                        "${data.data!.executives?[index].id ?? 0}";
                                  });
                                }),
                                focus: focus1,
                                validator: (x) {
                                  int index = data!.data!.executives!
                                      .indexWhere((st) => st.name == x);

                                  if (index == -1) {
                                    return 'Please Choose Executive';
                                  }
                                  return null;
                                },
                                hintText: 'Search Executive name',
                                initValue:
                                    data.data?.executives?[index].name ?? "",
                              ),
                            ],
                          ),
                        );
                      },
                      error: (Object error, StackTrace stackTrace) {
                        return Center(
                            child:
                                Text("Connection closed, Please try again!"));
                      },
                      loading: () => Center(child: CircularProgressIndicator()),
                    ),
                    // Add space between items
                    for (int i = 0; i < itemsData.length; i++)
                      Column(
                        children: [
                          SizedBox(height: 16.0),

                          Container(
                            margin: const EdgeInsets.only(left: 20, right: 20),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.all(Radius.circular(
                                      5.0) //                 <--- border radius here
                                  ),
                            ),
                            child: dropDownField(
                              context,
                              hintT: "Select Client",
                              value: itemsData[i]["productName"],
                              listValue: ["${itemsData[i]["productName"]}"],
                              onChanged: (String? newValue) {},
                            ),
                          ),
                          // dropDownSearchField(
                          //   context,
                          //   listValue: [
                          //     StockItemData(
                          //         id: int.parse(itemsData[i]["item_id"] ?? "0"),
                          //         itemName: itemsData[i]["productName"])
                          //   ],
                          //   onChanged: null,
                          //   focus: null,
                          //   validator: (x) {
                          //     return null;
                          //   },
                          //   hintText: 'Search Items',
                          //   initValue: itemsData[i]["productName"] == ""
                          //       ? ""
                          //       : itemsData[i]["productName"] ?? "",
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
                                        "spare_id":
                                            "${itemsData[i]["spare_id"]}",
                                        'item_id': "${itemsData[i]["item_id"]}",
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
                            List<Map<String, String>> idList = itemsData
                                .map((item) => {
                                      "spare_id": "${item["spare_id"] ?? ""}",
                                      "item_id": "${item["item_id"] ?? ""}",
                                      "quantity": "${item["quantity"] ?? ""}"
                                    })
                                .toList();

                            var formData = FormData.fromMap({
                              "servicereps_involved": executive_id,
                              "spare_lists": idList
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
      final _SparesItem = ref.watch(sparesItemProvider);
      final _MarketingData = ref.watch(marketingDataProvider);

      return Scaffold(
        appBar: AppBar(
          title: Text('Add Spares'),
        ),
        body: _SparesItem.when(
          data: (data) {
            return Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  children: [
                    _MarketingData.when(
                      data: (data) {
                        return Container(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Title_Style(
                                    Title: "Assign Executive", isStatus: true),
                              ),
                              dropDownExecutivesSearchField(
                                context,
                                listValue: data?.data?.executives ?? [],
                                onChanged: ((x) {
                                  focus1.unfocus();

                                  setState(() {
                                    print(x.searchKey);
                                    int index = data!.data!.executives!
                                        .indexWhere(
                                            (st) => st.name == x.searchKey);
                                    executive_id =
                                        "${data.data!.executives?[index].id ?? 0}";
                                  });
                                }),
                                focus: focus1,
                                validator: (x) {
                                  int index = data!.data!.executives!
                                      .indexWhere((st) => st.name == x);

                                  if (index == -1) {
                                    return 'Please Choose Executive';
                                  }
                                  return null;
                                },
                                hintText: 'Search Executive name',
                                initValue: '',
                              ),
                            ],
                          ),
                        );
                      },
                      error: (Object error, StackTrace stackTrace) {
                        return Center(
                            child:
                                Text("Connection closed, Please try again!"));
                      },
                      loading: () => Center(child: CircularProgressIndicator()),
                    ),
                    Expanded(
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
                                        'item_id': "${data.data![index].id}",
                                        'productName': "${x.searchKey}",
                                        'quantity':
                                            "${itemsData[i]["quantity"]}",
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
                                  initValue: itemsData[i]["productName"] == ""
                                      ? ""
                                      : itemsData[i]["productName"] ?? "",
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
                                            ..text =
                                                itemsData[i]["quantity"] ?? "",

                                          // initialValue: itemsData[i]["quantity"],
                                          onChanged: (typed) {
                                            // setState(() {
                                            final getValue = {
                                              'item_id':
                                                  "${itemsData[i]["item_id"]}",
                                              'productName':
                                                  "${itemsData[i]["productName"]}",
                                              'quantity': typed,
                                            };
                                            itemsData.removeAt(i);
                                            itemsData.insert(i, getValue);
                                            // });
                                          },
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 20.0,
                                                    horizontal: 20.0),
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
                                                    'item_id': "",
                                                    'productName': "",
                                                    'quantity': "",
                                                  };

                                                  itemsData.add(tempArr);
                                                  final focusCount =
                                                      FocusNode();
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

                                SizedBox(
                                    height: 30.0), // Add space between items
                              ],
                            ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: CommonElevatedButton(
                              context,
                              "Submit",
                              () {
                                if (_formKey.currentState!.validate()) {
                                  List<Map<String, String>> idList = itemsData
                                      .map((item) => {
                                            "item_id":
                                                "${item["item_id"] ?? ""}",
                                            "quantity":
                                                "${item["quantity"] ?? ""}"
                                          })
                                      .toList();

                                  var formData = FormData.fromMap({
                                    "servicereps_involved": executive_id,
                                    "spare_lists": idList
                                  });
                                  addStockItems(formData);
                                }
                              },
                            ),
                          ),
                        ],
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
      url = ConstantApi.updateSparesItemUrl;
    } else {
      url = ConstantApi.addSparesItemUrl;
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
