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

class AddItemsScreen extends ConsumerStatefulWidget {
  bool isEdit;
  String itemId;
  AddItemsScreen({super.key, required this.isEdit, required this.itemId});

  @override
  _AddItemsScreenState createState() => _AddItemsScreenState();
}

class _AddItemsScreenState extends ConsumerState<AddItemsScreen> {
  TextEditingController _ItemName = TextEditingController();
  TextEditingController _ItemType = TextEditingController();
  TextEditingController _Itemcategory = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isvalueUpdated = false;
  List<FocusNode> focus = [];

  @override
  Widget build(BuildContext context) {
    if (widget.isEdit == true) {
      final activityEditFuture = ref.watch(ItemsEditProvider(widget.itemId));

      return Scaffold(
        appBar: AppBar(title: Text('Edit Items')),
        body: activityEditFuture.when(
          data: (data) {
            if (isvalueUpdated == false) {
              isvalueUpdated = true;
              _ItemName.text = data?.data?.data?.itemName ?? "";
              _ItemType.text = data?.data?.data?.itemType ?? "";
              _Itemcategory.text = data?.data?.data?.itemCategory ?? "";
            }
            return Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    //CLIENT NAME
                    Title_Style(Title: 'Item Name', isStatus: true),
                    textFormField(
                        isEnabled: true,
                        hintText: "Enter Item Name",
                        keyboardtype: TextInputType.text,
                        Controller: _ItemName,
                        validating: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter ${'Item Name'}";
                          }
                          if (value == null) {
                            return "Please Enter ${'Item Name'}";
                          }
                          return null;
                        }),
                    //CLIENT CONTACT NUMBER
                    Title_Style(Title: 'Item Type', isStatus: false),
                    textFormField(
                        isEnabled: true,
                        hintText: "Enter Item Type",
                        keyboardtype: TextInputType.text,
                        Controller: _ItemType,
                        validating: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter ${'Item Type'}";
                          }
                          if (value == null) {
                            return "Please Enter ${'Item Type'}";
                          }
                          return null;
                        }),
                    //CLIENT ADDRESS
                    Title_Style(Title: "Item Category", isStatus: true),
                    textfieldDescription(
                        readOnly: false,
                        Controller: _Itemcategory,
                        hintText: 'Enter Category',
                        validating: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter ${'Category'}";
                          }
                          if (value == null) {
                            return "Please Enter ${'Categoryqwer'}";
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
                            "item_name": _ItemName.text,
                            "item_type": _ItemType.text,
                            "item_category": _Itemcategory.text,
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
          title: Text('Add Items'),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                //CLIENT NAME
                Title_Style(Title: 'Item name', isStatus: true),
                textFormField(
                    isEnabled: true,
                    hintText: "Enter Contact GST No",
                    keyboardtype: TextInputType.text,
                    Controller: _ItemName,
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
                    Controller: _ItemType,
                    validating: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter ${'Customer Name'}";
                      }
                      if (value == null) {
                        return "Please Enter ${'Customer Name'}";
                      }
                      return null;
                    }),
                //CLIENT CONTACT NUMBER
                Title_Style(Title: 'Client Name', isStatus: true),
                textFormField(
                    isEnabled: true,
                    hintText: "Enter Customer Name",
                    keyboardtype: TextInputType.text,
                    Controller: _Itemcategory,
                    validating: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter ${'Customer Name'}";
                      }
                      if (value == null) {
                        return "Please Enter ${'Customer Name'}";
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
                        "item_name": _ItemName.text,
                        "item_type": _ItemType.text,
                        "item_category": _Itemcategory.text,
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
      url = ConstantApi.itemsCreate + "/${widget.itemId}";
    } else {
      url = ConstantApi.itemsCreate;
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
