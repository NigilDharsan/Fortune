import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortune/Common_Widgets/Common_Button.dart';
import 'package:fortune/Common_Widgets/Custom_App_Bar.dart';
import 'package:fortune/Common_Widgets/Image_Path.dart';
import 'package:fortune/Common_Widgets/Text_Form_Field.dart';
import 'package:fortune/Model/ServiceModel.dart';
import 'package:fortune/Model/SuccessModel.dart';
import 'package:fortune/utilits/ApiProvider.dart';
import 'package:fortune/utilits/ApiService.dart';
import 'package:fortune/utilits/Common_Colors.dart';
import 'package:fortune/utilits/ConstantsApi.dart';
import 'package:fortune/utilits/Generic.dart';
import 'package:fortune/utilits/Loading_Overlay.dart';
import 'package:fortune/utilits/Text_Style.dart';

class Service_Form_Screen extends ConsumerStatefulWidget {
  const Service_Form_Screen({super.key});

  @override
  ConsumerState<Service_Form_Screen> createState() =>
      _Service_Form_ScreenState();
}

class _Service_Form_ScreenState extends ConsumerState<Service_Form_Screen> {
  TextEditingController _StatusNote = TextEditingController();
  TextEditingController _ClientName = TextEditingController();
  TextEditingController _ContactNumber = TextEditingController();
  TextEditingController _ClientAddress = TextEditingController();

  File? _selectedFiles;
  List<Executives> _selectedItems = [];

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.any,
      // allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _selectedFiles = File(result.files.single.path!);
      });
    } else {
      print("User canceled the file picker.");
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedFiles = null;
    });
  }

  List<String> _SelectClient = ['Bosh', 'Pricol', 'Tessolv'];
  List<String> _CompanyName = ['Zoho', 'wipro', 'Advance'];
  List<String> _AssignExecutive = ['Arun', 'Madhesh', 'Naveen', "Nivas"];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? Degree;
  String? clientName;
  String? companyName;
  String? assignExecutive;
  String? status;
  int? clientSelectedIndex;

  bool? isAddNewClient;

  int client_id = 0;
  String company_id = "";

  @override
  Widget build(BuildContext context) {
    SingleTon singleton = SingleTon();

    final _ServiceData = ref.watch(serviceDataProvider);

    return Scaffold(
      backgroundColor: white5,
      appBar: Custom_AppBar(
          title: "Service Form", actions: null, isGreen: false, isNav: true),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _ServiceData.when(
                data: (data) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      children: [
                        //CLIENT NAME
                        Title_Style(Title: 'Select Client', isStatus: true),
                        dropDownField1(
                          context,
                          hintT: "Select Client",
                          value: clientName,
                          listValue: data?.data?.clients ?? [],
                          onChanged: (String? newValue) {
                            setState(() {
                              if (newValue == "Add New") {
                                isAddNewClient = true;
                                clientName = newValue;
                                _ClientName.text = " ";
                                _ContactNumber.text = "";
                                _ClientAddress.text = "";
                                client_id = 0;
                              } else {
                                isAddNewClient = false;
                                clientName = newValue;
                                int index = data!.data!.clients!.indexWhere(
                                    (st) => st.cusFirstName == newValue);
                                clientSelectedIndex = index;
                                _ClientName.text =
                                    data.data!.clients![index].cusFirstName ??
                                        "";
                                _ContactNumber.text =
                                    data.data!.clients![index].cusMobileNo ??
                                        "";
                                _ClientAddress.text =
                                    data.data!.clients![index].address ?? "";
                                client_id =
                                    data.data!.clients![index].customerId ?? 0;
                              }
                            });
                          },
                        ),
                        //COMPANY NAME
                        Title_Style(Title: "Company Name", isStatus: true),
                        dropDownField2(
                          hintT: 'Select Company Name',
                          context,
                          value: companyName,
                          listValue: data?.data?.companies ?? [],
                          onChanged: (String? newValue) {
                            setState(() {
                              companyName = newValue;
                              Companies? item = data?.data?.companies!
                                  .firstWhere(
                                      (item) => item.companyBranch == newValue);
                              company_id = "${item?.companyId ?? 0}";
                            });
                          },
                        ),
                        //CLIENT NAME
                        Title_Style(Title: 'Client Name', isStatus: true),
                        textFormField(
                            isEnabled: isAddNewClient == true ? true : false,
                            hintText: "Client Name",
                            keyboardtype: TextInputType.text,
                            Controller: _ClientName,
                            validating: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please Enter ${'Client Name'}";
                              }
                              if (value == null) {
                                return "Please Enter ${'Client Name'}";
                              }
                              return null;
                            }),
                        //CLIENT CONTACT NUMBER
                        Title_Style(
                            Title: 'Client Mobile Number', isStatus: true),
                        textFormField(
                          isEnabled: isAddNewClient == true ? true : false,
                          hintText: 'Mobile Number',
                          keyboardtype: TextInputType.phone,
                          // inputFormatters: [
                          //   LengthLimitingTextInputFormatter(10)
                          // ],
                          Controller: _ContactNumber,
                          validating: (value) {
                            if (value!.isEmpty) {
                              return "Please enter a Contact Number";
                            }
                            // else if (!RegExp(r"^[0-9]{10}$")
                            //     .hasMatch(value)) {
                            //   return "Please enter a valid 10-digit Contact Number";
                            // }
                            return null;
                          },
                          onChanged: null,
                        ),
                        //CLIENT ADDRESS
                        Title_Style(Title: "Client Address", isStatus: true),
                        textfieldDescription(
                            readOnly: isAddNewClient == true ? false : true,
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

                        //STATUS NOTE
                        Title_Style(Title: 'Status Note', isStatus: true),
                        textfieldDescription(
                            readOnly: false,
                            Controller: _StatusNote,
                            hintText: 'Enter Status Note',
                            validating: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please Enter ${'Note'}";
                              }
                              if (value == null) {
                                return "Please Enter ${'Note'}";
                              }
                              return null;
                            }),

                        Title_Style(Title: 'Spare Used List', isStatus: true),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 100, right: 100, bottom: 15),
                          child: CommonElevatedButton(
                              context, "Pick PDF", _pickFiles),
                        ),
                        Container(
                          height: (_selectedFiles?.path ?? "") == "" ? 0 : 90,
                          child: ListView.builder(
                            itemCount:
                                (_selectedFiles?.path ?? "") == "" ? 0 : 1,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => PDFViewerScreen(
                                  //         pdfPath: _selectedFiles?.path ?? ""),
                                  //   ),
                                  // );
                                },
                                child: Container(
                                  height: 65,
                                  margin: EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: white1),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 15),
                                        child: Container(
                                            height: 40,
                                            width: 40,
                                            child: Center(
                                                child: ImgPathSvg("pdf.svg"))),
                                      ),
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
                                          child: Text(
                                            _selectedFiles?.path != null
                                                ? _selectedFiles!.path
                                                    .split('/')
                                                    .last
                                                : "",
                                            style: pdfT,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          )),
                                      Spacer(),
                                      InkWell(
                                        onTap: () {
                                          _removeImage(index);
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 20),
                                          child: Icon(
                                            Icons.cancel_outlined,
                                            color: grey1,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        //ASSIGN EXECUTIVE

                        singleton.permissionList.contains("service-assign") ==
                                true
                            ? Column(
                                children: [
                                  Title_Style(
                                      Title: "Assign Executive",
                                      isStatus: true),
                                  // dropDownField3(
                                  //   context,
                                  //   hintT: 'Select Executive',
                                  //   value: assignExecutive,
                                  //   listValue: data?.data?.executives ?? [],
                                  //   onChanged: (String? newValue) {
                                  //     setState(() {
                                  //       assignExecutive = newValue;
                                  //     });
                                  //   },
                                  // ),
                                  MultiSelectDropdown(
                                    items: data?.data?.executives ?? [],
                                    selectedItems: _selectedItems,
                                    onChanged:
                                        (List<Executives> selectedItems) {
                                      setState(() {
                                        _selectedItems = selectedItems;
                                      });
                                    },
                                  ),
                                ],
                              )
                            : Container(),

                        const SizedBox(
                          height: 30,
                        ),

                        //BUTTON
                        CommonElevatedButton(context, "Submit", () async {
                          if (_formKey.currentState!.validate()) {
                            if (client_id == "") {
                              ShowToastMessage("Select client name");
                            } else if (company_id == "") {
                              ShowToastMessage("Select company name");
                            } else if (singleton.permissionList
                                        .contains("service-assign") ==
                                    true &&
                                _selectedItems.length == 0) {
                              ShowToastMessage("Select executive");
                            } else {
                              List<String> idList = _selectedItems
                                  .map((item) => "${item.id ?? 0}")
                                  .toList();

                              LoadingOverlay.show(context);

                              var formData = FormData.fromMap({
                                "is_new_client":
                                    isAddNewClient == true ? "1" : "0",
                                "client_id": client_id,
                                "cus_mobile_no": _ContactNumber.text,
                                "cus_first_name": _ClientName.text,
                                "address": _ClientAddress.text,
                                "status_note": _StatusNote.text,
                                for (var i = 0; i < idList.length; i++)
                                  'assign_executive[$i]': idList[i],
                                "company_id": company_id,
                              });

                              if (_selectedFiles != null) {
                                List<int> fileBytes =
                                    await _selectedFiles!.readAsBytes();

                                final filename = _selectedFiles?.path != null
                                    ? _selectedFiles!.path.split('/').last
                                    : "file.jpg";

                                formData.files.addAll([
                                  MapEntry(
                                      'report_upload',
                                      await MultipartFile.fromBytes(
                                        fileBytes,
                                        filename: filename,
                                      )),
                                ]);
                              }
                              final result = await ref
                                  .read(servicePostProvider(formData).future);
                              LoadingOverlay.forcedStop();
                              // Handle the result
                              if (result?.success == true) {
                                ShowToastMessage(result?.message ?? "");
                                Navigator.pop(context, true);

                                // Handle success
                              } else {
                                // Handle failure
                                ShowToastMessage(result?.message ?? "");
                              }
                              // addServiceList(data);
                            }
                          }
                        }),

                        const SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  );
                },
                error: (Object error, StackTrace stackTrace) {
                  return Text(error.toString());
                },
                loading: () => Center(child: CircularProgressIndicator()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addServiceList(Map<String, dynamic> data) async {
    LoadingOverlay.show(context);

    final apiService = ApiService(ref.read(dioProvider));

    final postResponse =
        await apiService.post1<SuccessModel>(ConstantApi.servicesStore, data);
    LoadingOverlay.forcedStop();

    if (postResponse.success == true) {
      ShowToastMessage(postResponse.message ?? "");
      Navigator.pop(context, true);
    } else {
      ShowToastMessage(postResponse.message ?? "");
    }
  }
}

class PDFViewerScreen extends StatelessWidget {
  final String pdfPath;

  PDFViewerScreen({required this.pdfPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: PDFView(
        filePath: pdfPath,
        onPageChanged: (int? page, int? total) {
          if (page != null && total != null) {
            print('page change: $page/$total');
          }
        },
        onViewCreated: (PDFViewController pdfViewController) {},
        onPageError: (page, error) {
          print('error: $page: $error');
        },
      ),
    );
  }
}
