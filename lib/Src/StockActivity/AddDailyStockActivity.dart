import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortune/Common_Widgets/Common_Button.dart';
import 'package:fortune/Model/DailyActivitiesModel.dart';
import 'package:fortune/Model/SuccessModel.dart';
import 'package:fortune/utilits/ApiService.dart';
import 'package:fortune/utilits/ConstantsApi.dart';
import 'package:fortune/utilits/Generic.dart';
import 'package:fortune/utilits/Loading_Overlay.dart';

class InvoiceFormScreen extends ConsumerStatefulWidget {
  ActivitiesData? data;

  InvoiceFormScreen({super.key, required this.data});

  @override
  _InvoiceFormScreenState createState() => _InvoiceFormScreenState();
}

class _InvoiceFormScreenState extends ConsumerState<InvoiceFormScreen> {
  List<Map<String, String>> itemsData = [];

  TextEditingController _InvoiceNumber = TextEditingController();
  TextEditingController _CustomerName = TextEditingController();
  TextEditingController _VehicleNumber = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Add one item row by default

    if (widget.data != null) {
      _InvoiceNumber.text = widget.data?.invoiceNo ?? "";
      _CustomerName.text = widget.data?.customer ?? "";
      _VehicleNumber.text = widget.data?.dispatchVehicleNo ?? "";

      for (int i = 0; i < (widget.data?.items?.length ?? 0); i++) {
        final dict = widget.data!.items?[i].productName ?? "";
        final dict1 = widget.data!.items?[i].quantity ?? "";

        final getValue = {
          'productName': dict,
          'quantity': dict1,
        };
        itemsData.add(getValue);
      }
    } else {
      itemsData = [
        {
          'productName': "",
          'quantity': "",
        }
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            widget.data != null ? Text('Edit Activity') : Text('Add Activity'),
      ),
      body: Form(
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
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
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
                              child: TextFormField(
                                controller: TextEditingController()
                                  ..text = itemsData[i]["productName"] ?? "",
                                // initialValue: itemsData[i]["productName"],
                                onChanged: (typed) {
                                  // setState(() {
                                  final getValue = {
                                    'productName': typed,
                                    'quantity': "${itemsData[i]["quantity"]}",
                                  };
                                  itemsData.removeAt(i);
                                  itemsData.insert(i, getValue);
                                  // });
                                },
                                decoration: InputDecoration(
                                  labelText: 'Product Name',
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter product name',
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Enter product name";
                                  }

                                  return null;
                                },
                              ),
                            ),
                            SizedBox(width: 16.0),
                            Expanded(
                              flex: 2,
                              child: TextFormField(
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
                            ),
                            SizedBox(width: 16.0),
                            i == (itemsData.length - 1)
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

                        SizedBox(height: 16.0), // Add space between items
                      ],
                    ),
                ],
              ),

              SizedBox(height: 20.0), // Add space between items

              CommonElevatedButton(
                context,
                widget.data != null ? "Update" : "Submit",
                () {
                  print(itemsData);

                  if (_formKey.currentState!.validate()) {
                    List<String> idList = itemsData
                        .map((item) => "${item["productName"] ?? ""}")
                        .toList();

                    List<String> idList1 = itemsData
                        .map((item) => "${item["quantity"] ?? ""}")
                        .toList();

                    if (widget.data != null) {
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
                      addMarketingList(formData);
                    } else {
                      var formData = FormData.fromMap({
                        "invoice_no": _InvoiceNumber.text,
                        "customer": _CustomerName.text,
                        "dispatch_vehicle_no": _VehicleNumber.text,
                        for (var i = 0; i < idList.length; i++)
                          'items[$i][product_name]': idList[i],
                        for (var j = 0; j < idList1.length; j++)
                          'items[$j][quantity]': idList1[j],
                      });
                      addMarketingList(formData);
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

  void addMarketingList(FormData data) async {
    LoadingOverlay.show(context);

    final apiService = ApiService(ref.read(dioProvider));

    var url = "";
    if (widget.data != null) {
      url = ConstantApi.activitiesCreate + "/${widget.data?.id ?? 0}";
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
