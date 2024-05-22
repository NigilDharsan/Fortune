import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortune/Common_Widgets/Common_Button.dart';
import 'package:fortune/Common_Widgets/Text_Form_Field.dart';
import 'package:fortune/Model/StocksModel.dart';
import 'package:fortune/Model/SuccessModel.dart';
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
        'productName': "",
        'quantity': "",
      }
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.data != null
            ? Text('Edit Physical Stocks')
            : Text('Add Physical Stocks'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              // TextFormField(
              //   controller: _ItemName,
              //   decoration: InputDecoration(
              //     labelText: 'Item Name',
              //     border: OutlineInputBorder(),
              //     hintText: 'Enter Item Name',
              //   ),
              //   validator: (value) {
              //     if (value!.isEmpty) {
              //       return "Please enter a Item Name";
              //     }
              //     // else if (!RegExp(r"^[0-9]{10}$")
              //     //     .hasMatch(value)) {
              //     //   return "Please enter a valid 10-digit Contact Number";
              //     // }
              //     return null;
              //   },
              // ),
              // SizedBox(height: 16.0),
              // TextFormField(
              //   controller: _AvailableStock,
              //   decoration: InputDecoration(
              //     labelText: 'Available Stock',
              //     border: OutlineInputBorder(),
              //     hintText: 'Enter Available Stock',
              //   ),
              //   keyboardType: TextInputType.number,
              //   textInputAction: TextInputAction.done,
              //   validator: (value) {
              //     if (value!.isEmpty) {
              //       return "Please enter a Available Stock";
              //     }
              //     // else if (!RegExp(r"^[0-9]{10}$")
              //     //     .hasMatch(value)) {
              //     //   return "Please enter a valid 10-digit Contact Number";
              //     // }
              //     return null;
              //   },
              // ),

              SizedBox(height: 20.0), // Add space between items
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (int i = 0; i < itemsData.length; i++)
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: dropDownField2(
                                hintT: 'Select',
                                context,
                                value: "companyName",
                                listValue: [],
                                onChanged: (String? newValue) {
                                  setState(() {
                                    // companyName = newValue;
                                    // Companies? item = data?.data?.companies!
                                    //     .firstWhere((item) =>
                                    //         item.companyBranch == newValue);
                                    // company_id = "${item?.companyId ?? 0}";
                                  });
                                },
                              ),
                              // TextFormField(
                              //   controller: TextEditingController()
                              //     ..text = itemsData[i]["productName"] ?? "",
                              //   // initialValue: itemsData[i]["productName"],
                              //   onChanged: (typed) {
                              //     // setState(() {
                              //     final getValue = {
                              //       'productName': typed,
                              //       'quantity': "${itemsData[i]["quantity"]}",
                              //     };
                              //     itemsData.removeAt(i);
                              //     itemsData.insert(i, getValue);
                              //     // });
                              //   },
                              //   decoration: InputDecoration(
                              //     labelText: 'Product Name',
                              //     border: OutlineInputBorder(),
                              //     hintText: 'Enter product name',
                              //   ),
                              //   validator: (value) {
                              //     if (value!.isEmpty) {
                              //       return "Enter product name";
                              //     }

                              //     return null;
                              //   },
                              // ),
                            ),
                            SizedBox(width: 16.0),

                            SizedBox(width: 16.0),
                            i == 0
                                ? IconButton(
                                    icon: Icon(Icons.add_box),
                                    onPressed: () {
                                      setState(() {
                                        final tempArr = {
                                          'productName': "",
                                          'quantity': "",
                                        };

                                        itemsData.add(tempArr);
                                      });
                                    },
                                  )
                                : IconButton(
                                    icon: Icon(Icons.remove_circle),
                                    onPressed: () {
                                      setState(() {
                                        itemsData.removeAt(i);
                                      });
                                    },
                                  )
                          ],
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          controller: TextEditingController()
                            ..text = itemsData[i]["quantity"] ?? "",

                          // initialValue: itemsData[i]["quantity"],
                          onChanged: (typed) {
                            // setState(() {
                            final getValue = {
                              'productName':
                              "${itemsData[i]["productName"]}",
                              'quantity': typed,
                            };
                            itemsData.removeAt(i);
                            itemsData.insert(i, getValue);
                            // });
                          },
                          decoration: InputDecoration(
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

                        SizedBox(height: 16.0), // Add space between items
                      ],
                    ),
                ],
              ),
              CommonElevatedButton(
                context,
                widget.data != null ? "Update" : "Submit",
                () {
                  if (_formKey.currentState!.validate()) {
                    if (widget.data != null) {
                      Map<String, dynamic> data = {
                        "item_name": _ItemName.text,
                        "available_stock": _AvailableStock.text,
                        "_method": "PUT",
                      };
                      addMarketingList(data);
                    } else {
                      Map<String, dynamic> data = {
                        "item_name": _ItemName.text,
                        "available_stock": _AvailableStock.text,
                      };
                      addMarketingList(data);
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addMarketingList(Map<String, dynamic> data) async {
    LoadingOverlay.show(context);

    final apiService = ApiService(ref.read(dioProvider));

    var url = "";
    if (widget.data != null) {
      url = ConstantApi.stocksCreate + "/${widget.data?.id ?? 0}";
    } else {
      url = ConstantApi.stocksCreate;
    }

    final postResponse = await apiService.post1<SuccessModel>(url, data);
    LoadingOverlay.forcedStop();

    if (postResponse.success == true) {
      ShowToastMessage(postResponse.message ?? "");
      Navigator.pop(context, true);
    } else {
      ShowToastMessage(postResponse.message ?? "");
    }
  }
}
