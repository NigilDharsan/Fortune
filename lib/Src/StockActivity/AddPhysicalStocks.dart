import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortune/Common_Widgets/Common_Button.dart';
import 'package:fortune/Common_Widgets/Text_Form_Field.dart';
import 'package:fortune/Model/StocksModel.dart';
import 'package:fortune/Model/SuccessModel.dart';
import 'package:fortune/utilits/ApiProvider.dart';
import 'package:fortune/utilits/ApiService.dart';
import 'package:fortune/utilits/ConstantsApi.dart';
import 'package:fortune/utilits/Generic.dart';
import 'package:fortune/utilits/Loading_Overlay.dart';

class AddPhysicalStockScreen extends ConsumerStatefulWidget {
  StocksData? data;

  AddPhysicalStockScreen({super.key, required this.data});

  @override
  _AddPhysicalStockScreenState createState() => _AddPhysicalStockScreenState();
}

class _AddPhysicalStockScreenState
    extends ConsumerState<AddPhysicalStockScreen> {
  TextEditingController _ItemName = TextEditingController();
  TextEditingController _AvailableStock = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Map<String, String>> itemsData = [];

  @override
  void initState() {
    super.initState();
    // Add one item row by default

    if (widget.data != null) {
      _ItemName.text = widget.data?.itemName ?? "";
      _AvailableStock.text = widget.data?.availableStock ?? "";
    }

    itemsData = [
      {
        'productID': "",
        'productName': "",
        'quantity': "",
      }
    ];

    // final _StocksItem = ref.read(stocksItemProvider);
    // _StocksItem.whenData((value){

    //   print(value?.data?[0].itemName ?? "");

    // });
  }

  @override
  Widget build(BuildContext context) {
    final _StocksItem = ref.watch(stocksItemProvider);
    return Scaffold(
      appBar: AppBar(
        title: widget.data != null
            ? Text('Edit Physical Stocks')
            : Text('Add Physical Stocks'),
      ),
      body: _StocksItem.when(
        data: (data) {
          return Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(left: 10,right: 10),
              child: ListView(
                children: [
                  SizedBox(height: 20.0),
                  // Add space between items
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < itemsData.length; i++)
                        Column(
                          children: [
                            Container(
                              alignment: Alignment.topRight,
                              child:  i == 0
                                  ? IconButton(
                                alignment:Alignment.topRight,
                                icon: Icon(Icons.add_box),
                                onPressed: () {
                                  setState(() {
                                    final tempArr = {
                                      'productID': "",
                                      'productName': "",
                                      'quantity': "",
                                    };

                                    itemsData.add(tempArr);
                                  });
                                },
                              )
                                  : IconButton(
                                alignment:Alignment.topRight,
                                icon: Icon(Icons.remove_circle),
                                onPressed: () {
                                  setState(() {
                                    itemsData.removeAt(i);
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: 16.0),

                            dropDownField7(
                              hintT: 'Select Items',
                              context,
                              value: itemsData[i]["productName"] == ""
                                  ? null
                                  : itemsData[i]["productName"],
                              listValue: data?.data ?? [],
                              onChanged: (String? newValue) {
                                setState(() {
                                  int index = data!.data!.indexWhere(
                                      (st) => st.itemName == newValue);

                                  final getValue = {
                                    'productID':
                                        "${data.data![index].id}",
                                    'productName': "${newValue}",
                                    'quantity':
                                        "${itemsData[i]["quantity"]}",
                                  };
                                  itemsData.removeAt(i);
                                  itemsData.insert(i, getValue);
                                });
                              },
                            ),

                            SizedBox(height: 16.0),
                            Padding(
                              padding: const EdgeInsets.only(left: 20,right: 20),
                              child: TextFormField(
                                controller: TextEditingController()
                                  ..text = itemsData[i]["quantity"] ?? "",

                                // initialValue: itemsData[i]["quantity"],
                                onChanged: (typed) {
                                  // setState(() {
                                  final getValue = {
                                    'productID': "${itemsData[i]["productID"]}",
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
                                      vertical: 10.0, horizontal: 10.0),
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

                            SizedBox(height: 30.0), // Add space between items
                          ],
                        ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20),
                    child: CommonElevatedButton(
                      context,
                      widget.data != null ? "Update" : "Submit",
                      () {
                        if (_formKey.currentState!.validate()) {
                          if (widget.data != null) {
                            var formData = FormData.fromMap({
                              "item_name": _ItemName.text,
                              "available_stock": _AvailableStock.text,
                              "_method": "PUT",
                            });
                            addStockItems(formData);
                          } else {
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
  }

  void addStockItems(FormData data) async {
    LoadingOverlay.show(context);

    final apiService = ApiService(ref.read(dioProvider));

    var url = "";
    if (widget.data != null) {
      url = ConstantApi.stocksCreate + "/${widget.data?.id ?? 0}";
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
