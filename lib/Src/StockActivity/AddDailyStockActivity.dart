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

class InvoiceFormScreen extends ConsumerStatefulWidget {
  bool isEdit;
  String activityId;
  InvoiceFormScreen(
      {super.key, required this.isEdit, required this.activityId});

  @override
  _InvoiceFormScreenState createState() => _InvoiceFormScreenState();
}

class _InvoiceFormScreenState extends ConsumerState<InvoiceFormScreen> {
  List<Map<String, String>> itemsData = [];

  TextEditingController _InvoiceNumber = TextEditingController();
  TextEditingController _CustomerName = TextEditingController();
  TextEditingController _VehicleNumber = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isvalueUpdated = false;
  List<FocusNode> focus = [];

  @override
  void initState() {
    super.initState();
    // Add one item row by default

    if (widget.isEdit == true) {
    } else {
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
      final activityEditFuture =
          ref.watch(activityEditProvider(widget.activityId));

      return Scaffold(
        appBar: AppBar(title: Text('Edit Activity')),
        body: activityEditFuture.when(
          data: (data) {
            if (isvalueUpdated == false) {
              isvalueUpdated = true;
              _InvoiceNumber.text = data?.data?.data?.invoiceNo ?? "";
              _CustomerName.text = data?.data?.data?.customer ?? "";
              _VehicleNumber.text = data?.data?.data?.dispatchVehicleNo ?? "";

              for (int i = 0; i < (data?.data?.data?.items?.length ?? 0); i++) {
                final dict = data?.data?.data?.items?[i].productName ?? "";
                final dict1 = data?.data?.data?.items?[i].quantity ?? "";
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
                focus.add(focusCount);
              }
            }
            return Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _InvoiceNumber,
                      decoration: InputDecoration(
                        labelText: 'Invoice Number',
                        border: OutlineInputBorder(),
                        hintText: 'Enter invoice number',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter a invoice number";
                        }
                        // else if (!RegExp(r"^[0-9]{10}$")
                        //     .hasMatch(value)) {
                        //   return "Please enter a valid 10-digit Contact Number";
                        // }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _CustomerName,
                      decoration: InputDecoration(
                        labelText: 'Customer Name',
                        border: OutlineInputBorder(),
                        hintText: 'Enter customer name',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter a customer name";
                        }
                        // else if (!RegExp(r"^[0-9]{10}$")
                        //     .hasMatch(value)) {
                        //   return "Please enter a valid 10-digit Contact Number";
                        // }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _VehicleNumber,
                      decoration: InputDecoration(
                        labelText: 'Dispatch Vehicle Number',
                        border: OutlineInputBorder(),
                        hintText: 'Enter dispatch vehicle number',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter a dispatch number";
                        }

                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Items',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
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
                                      'productID':
                                          "${data.data!.items?[index].id}",
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
                              //         'productID':
                              //             "${data.data!.items?[index].id}",
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
                                          ..text =
                                              itemsData[i]["quantity"] ?? "",

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
                                              });
                                            },
                                          ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 30.0), // Add space between items
                            ],
                          ),
                      ],
                    ),

                    SizedBox(height: 20.0), // Add space between items

                    CommonElevatedButton(
                      context,
                      "Update",
                      () {
                        print(itemsData);

                        if (_formKey.currentState!.validate()) {
                          List<String> idList = itemsData
                              .map((item) => "${item["productID"] ?? ""}")
                              .toList();

                          List<String> idList1 = itemsData
                              .map((item) => "${item["quantity"] ?? ""}")
                              .toList();

                          var formData = FormData.fromMap({
                            "invoice_no": _InvoiceNumber.text,
                            "customer": _CustomerName.text,
                            "dispatch_vehicle_no": _VehicleNumber.text,
                            "_method": "PUT",
                            for (var i = 0; i < idList.length; i++)
                              'items[$i][product_name]': idList[i],
                            for (var j = 0; j < idList1.length; j++)
                              'items[$j][quantity]': idList1[j],
                          });
                          addStockActivity(formData);
                        }
                      },
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
    } else {
      final activityItems = ref.watch(activityItemProvider);

      return Scaffold(
        appBar: AppBar(
          title: Text('Add Activity'),
        ),
        body: activityItems.when(
          data: (data) {
            return Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _InvoiceNumber,
                      decoration: InputDecoration(
                        labelText: 'Invoice Number',
                        border: OutlineInputBorder(),
                        hintText: 'Enter invoice number',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter a invoice number";
                        }
                        // else if (!RegExp(r"^[0-9]{10}$")
                        //     .hasMatch(value)) {
                        //   return "Please enter a valid 10-digit Contact Number";
                        // }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _CustomerName,
                      decoration: InputDecoration(
                        labelText: 'Customer Name',
                        border: OutlineInputBorder(),
                        hintText: 'Enter customer name',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter a customer name";
                        }
                        // else if (!RegExp(r"^[0-9]{10}$")
                        //     .hasMatch(value)) {
                        //   return "Please enter a valid 10-digit Contact Number";
                        // }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _VehicleNumber,
                      decoration: InputDecoration(
                        labelText: 'Dispatch Vehicle Number',
                        border: OutlineInputBorder(),
                        hintText: 'Enter dispatch vehicle number',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter a dispatch number";
                        }

                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Items',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (int i = 0; i < itemsData.length; i++)
                          Column(
                            children: [
                              SizedBox(height: 16.0),

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
                              //         'productID': "${data.data?[index].id}",
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
                                          ..text =
                                              itemsData[i]["quantity"] ?? "",

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
                      ],
                    ),

                    SizedBox(height: 20.0), // Add space between items

                    CommonElevatedButton(
                      context,
                      "Submit",
                      () {
                        print(itemsData);

                        if (_formKey.currentState!.validate()) {
                          List<String> idList = itemsData
                              .map((item) => "${item["productID"] ?? ""}")
                              .toList();

                          List<String> idList1 = itemsData
                              .map((item) => "${item["quantity"] ?? ""}")
                              .toList();

                          var formData = FormData.fromMap({
                            "invoice_no": _InvoiceNumber.text,
                            "customer": _CustomerName.text,
                            "dispatch_vehicle_no": _VehicleNumber.text,
                            for (var i = 0; i < idList.length; i++)
                              'items[$i][product_name]': idList[i],
                            for (var j = 0; j < idList1.length; j++)
                              'items[$j][quantity]': idList1[j],
                          });
                          addStockActivity(formData);
                        }
                      },
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

  void addStockActivity(FormData data) async {
    LoadingOverlay.show(context);

    final apiService = ApiService(ref.read(dioProvider));

    var url = "";
    if (widget.isEdit == true) {
      url = ConstantApi.activitiesCreate + "/${widget.activityId}";
    } else {
      url = ConstantApi.activitiesCreate;
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
