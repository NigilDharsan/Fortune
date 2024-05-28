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

class AddClientScreen extends ConsumerStatefulWidget {
  bool isEdit;
  String clientId;
  AddClientScreen({super.key, required this.isEdit, required this.clientId});

  @override
  _AddClientScreenState createState() => _AddClientScreenState();
}

class _AddClientScreenState extends ConsumerState<AddClientScreen> {
  TextEditingController _ClientGSTNo = TextEditingController();

  TextEditingController _ClientAddress = TextEditingController();
  TextEditingController _ClientName = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isvalueUpdated = false;
  List<FocusNode> focus = [];

  @override
  Widget build(BuildContext context) {
    if (widget.isEdit == true) {
      final activityEditFuture = ref.watch(clientEditProvider(widget.clientId));

      return Scaffold(
        appBar: AppBar(title: Text('Edit Client')),
        body: activityEditFuture.when(
          data: (data) {
            if (isvalueUpdated == false) {
              isvalueUpdated = true;
              // _InvoiceNumber.text = data?.data?.data?.invoiceNo ?? "";
              // _CustomerName.text = data?.data?.data?.customer ?? "";
              // _VehicleNumber.text = data?.data?.data?.dispatchVehicleNo ?? "";
            }
            return Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    //CLIENT NAME
                    Title_Style(Title: 'Client GST No', isStatus: true),
                    textFormField(
                        isEnabled: true,
                        hintText: "Enter Contact GST No",
                        keyboardtype: TextInputType.text,
                        Controller: _ClientGSTNo,
                        validating: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter ${'GST No'}";
                          }
                          if (value == null) {
                            return "Please Enter ${'GST No'}";
                          }
                          return null;
                        }),
                    //CLIENT CONTACT NUMBER
                    Title_Style(Title: 'Client Name', isStatus: false),
                    textFormField(
                        isEnabled: true,
                        hintText: "Enter Customer Name",
                        keyboardtype: TextInputType.text,
                        Controller: _ClientName,
                        validating: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter ${'Customer Name'}";
                          }
                          if (value == null) {
                            return "Please Enter ${'Customer Name'}";
                          }
                          return null;
                        }),
                    //CLIENT ADDRESS
                    Title_Style(Title: "Address", isStatus: true),
                    textfieldDescription(
                        readOnly: false,
                        Controller: _ClientAddress,
                        hintText: 'Enter Address',
                        validating: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter ${'Address'}";
                          }
                          if (value == null) {
                            return "Please Enter ${'Address'}";
                          }
                          return null;
                        }),

                    SizedBox(height: 20.0), // Add space between items

                    CommonElevatedButton(
                      context,
                      "Update",
                      () {
                        if (_formKey.currentState!.validate()) {
                          var formData = FormData.fromMap({
                            "gst_no": _ClientGSTNo.text,
                            "cus_first_name": _ClientName.text,
                            "address": _ClientAddress.text,
                            "_method": "PUT",
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
      return Scaffold(
        appBar: AppBar(
          title: Text('Add Client'),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                //CLIENT NAME
                Title_Style(Title: 'Client GST No', isStatus: true),
                textFormField(
                    isEnabled: true,
                    hintText: "Enter Contact GST No",
                    keyboardtype: TextInputType.text,
                    Controller: _ClientGSTNo,
                    validating: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter ${'GST No'}";
                      }
                      if (value == null) {
                        return "Please Enter ${'GST No'}";
                      }
                      return null;
                    }),
                //CLIENT CONTACT NUMBER
                Title_Style(Title: 'Client Name', isStatus: true),
                textFormField(
                    isEnabled: true,
                    hintText: "Enter Customer Name",
                    keyboardtype: TextInputType.text,
                    Controller: _ClientName,
                    validating: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter ${'Customer Name'}";
                      }
                      if (value == null) {
                        return "Please Enter ${'Customer Name'}";
                      }
                      return null;
                    }),
                //CLIENT ADDRESS
                Title_Style(Title: "Address", isStatus: true),
                textfieldDescription(
                    readOnly: false,
                    Controller: _ClientAddress,
                    hintText: 'Enter Address',
                    validating: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter ${'Address'}";
                      }
                      if (value == null) {
                        return "Please Enter ${'Address'}";
                      }
                      return null;
                    }),

                SizedBox(height: 20.0), // Add space between items

                CommonElevatedButton(
                  context,
                  "Submit",
                  () {
                    if (_formKey.currentState!.validate()) {
                      var formData = FormData.fromMap({
                        "gst_no": _ClientGSTNo.text,
                        "cus_first_name": _ClientName.text,
                        "address": _ClientAddress.text,
                      });
                      addStockActivity(formData);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  void addStockActivity(FormData data) async {
    LoadingOverlay.show(context);

    final apiService = ApiService(ref.read(dioProvider));

    var url = "";
    if (widget.isEdit == true) {
      url = ConstantApi.clientCreate + "/${widget.clientId}";
    } else {
      url = ConstantApi.clientCreate;
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
