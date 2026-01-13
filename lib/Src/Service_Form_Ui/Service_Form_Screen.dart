import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortune/Common_Widgets/Common_Button.dart';
import 'package:fortune/Common_Widgets/Custom_App_Bar.dart';
import 'package:fortune/Common_Widgets/Image_Path.dart';
import 'package:fortune/Common_Widgets/Text_Form_Field.dart';
import 'package:fortune/Model/EditModel.dart';
import 'package:fortune/Model/ServiceModel.dart';
import 'package:fortune/Model/SuccessModel.dart';
import 'package:fortune/utilits/ApiProvider.dart';
import 'package:fortune/utilits/ApiService.dart';
import 'package:fortune/utilits/Common_Colors.dart';
import 'package:fortune/utilits/ConstantsApi.dart';
import 'package:fortune/utilits/Generic.dart';
import 'package:fortune/utilits/Loading_Overlay.dart';
import 'package:fortune/utilits/Text_Style.dart';
import 'package:intl/intl.dart';

class Service_Form_Screen extends ConsumerStatefulWidget {
  const Service_Form_Screen({super.key});

  @override
  ConsumerState<Service_Form_Screen> createState() =>
      _Service_Form_ScreenState();
}

class _Service_Form_ScreenState extends ConsumerState<Service_Form_Screen> {
  TextEditingController _DatePicker = TextEditingController();
  TextEditingController _StatusNote = TextEditingController();
  TextEditingController _ClientName = TextEditingController();
  TextEditingController _ContactNumber = TextEditingController();
  TextEditingController _ClientAddress = TextEditingController();
  TextEditingController _Requirement = TextEditingController();

  List<File> _selectedFiles = [];
  Executives? _selectedItems;

  String? selectStatus;
  String selectStatus_id = "";

  List<String> _selectState = [
    'completed',
    'pending',
    'processing',
    "cancelled",
  ];

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.any,
      // allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _selectedFiles.add(File(result.files.single.path!));
      });
    } else {
      print("User canceled the file picker.");
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
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
  var focus = FocusNode();

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
                        dropDownClientSearchField(
                          context,
                          listValue: data?.data?.clients ?? [],
                          onChanged: ((x) {
                            focus.unfocus();

                            setState(() {
                              if (x.searchKey == "Add New") {
                                isAddNewClient = true;
                                clientName = x.searchKey;
                                _ClientName.text = " ";
                                _ContactNumber.text = "";
                                _ClientAddress.text = "";
                                client_id = 0;
                              } else {
                                isAddNewClient = false;
                                clientName = x.searchKey;
                                int index = data!.data!.clients!.indexWhere(
                                    (st) => st.cusFirstName == x.searchKey);
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
                          }),
                          focus: focus,
                          validator: (x) {
                            int index = data!.data!.clients!
                                .indexWhere((st) => st.cusFirstName == x);

                            if (index == -1) {
                              return 'Please Choose Client';
                            }
                            return null;
                          },
                          hintText: 'Search Client name',
                          initValue: clientName ?? "",
                        ),
                        // dropDownField1(
                        //   context,
                        //   hintT: "Select Client",
                        //   value: clientName,
                        //   listValue: data?.data?.clients ?? [],
                        //   onChanged: (String? newValue) {
                        //     setState(() {
                        //       if (newValue == "Add New") {
                        //         isAddNewClient = true;
                        //         clientName = newValue;
                        //         _ClientName.text = " ";
                        //         _ContactNumber.text = "";
                        //         _ClientAddress.text = "";
                        //         client_id = 0;
                        //       } else {
                        //         isAddNewClient = false;
                        //         clientName = newValue;
                        //         int index = data!.data!.clients!.indexWhere(
                        //             (st) => st.cusFirstName == newValue);
                        //         clientSelectedIndex = index;
                        //         _ClientName.text =
                        //             data.data!.clients![index].cusFirstName ??
                        //                 "";
                        //         _ContactNumber.text =
                        //             data.data!.clients![index].cusMobileNo ??
                        //                 "";
                        //         _ClientAddress.text =
                        //             data.data!.clients![index].address ?? "";
                        //         client_id =
                        //             data.data!.clients![index].customerId ?? 0;
                        //       }
                        //     });
                        //   },
                        // ),

                        //REQUIRMENT
                        Title_Style(Title: 'Requirement', isStatus: true),
                        textfieldDescription(
                            readOnly: false,
                            Controller: _Requirement,
                            hintText: 'Enter Requirement',
                            validating: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please Enter ${'Requirement'}";
                              }
                              if (value == null) {
                                return "Please Enter ${'Requirement'}";
                              }
                              return null;
                            }),

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
                            isEnabled: true,
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
                            Title: 'Client Mobile Number', isStatus: false),
                        textFormField(
                          isEnabled:
                              true, //isAddNewClient == true ? true : false,
                          hintText: 'Mobile Number',
                          keyboardtype: TextInputType.phone,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10)
                          ],
                          Controller: _ContactNumber,
                          // validating: (value) {
                          //   if (isAddNewClient == true) {
                          //     if (value!.isEmpty) {
                          //       return "Please enter a Contact Number";
                          //     } else if (!RegExp(r"^[0-9]{10}$")
                          //         .hasMatch(value)) {
                          //       return "Please enter a valid 10-digit Contact Number";
                          //     }
                          //   }

                          //   return null;
                          // },
                          onChanged: null,
                        ),
                        //CLIENT ADDRESS
                        Title_Style(Title: "Client Address", isStatus: true),
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

//SELECT STATUS
                        Title_Style(Title: "Select Status", isStatus: true),
                        dropDownField(
                          context,
                          hintT: 'Select Status',
                          value: selectStatus,
                          listValue: _selectState,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectStatus = newValue;

                              selectStatus_id = selectStatus == "completed"
                                  ? "1"
                                  : selectStatus == "pending"
                                      ? "2"
                                      : selectStatus == "processing"
                                          ? "3"
                                          : selectStatus == "cancelled"
                                              ? "4"
                                              : "5";
                            });
                          },
                        ),
                        //STATUS NOTE
                        Title_Style(Title: 'Status Note', isStatus: false),
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

                        Title_Style(
                            Title: 'Next Followup date', isStatus: true),
                        TextFieldDatePicker(
                            Controller: _DatePicker,
                            onChanged: null,
                            validating: (value) {
                              if (value!.isEmpty) {
                                return 'Please select Date';
                              } else {
                                return null;
                              }
                            },
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2050));
                              if (pickedDate != null) {
                                final TimeOfDay? pickedTime =
                                    await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (pickedTime != null) {
                                  final DateTime selectedDateTime = DateTime(
                                    pickedDate.year,
                                    pickedDate.month,
                                    pickedDate.day,
                                    pickedTime.hour,
                                    pickedTime.minute,
                                  );

                                  String formatdate =
                                      DateFormat("yyyy-MM-dd hh:mm a")
                                          .format(selectedDateTime);
                                  if (mounted) {
                                    setState(() {
                                      _DatePicker.text = formatdate;
                                      print(_DatePicker.text);
                                    });
                                  }
                                }
                              }
                            },
                            hintText: 'yyyy-MM-dd'),
                        Title_Style(Title: 'Spare Used List', isStatus: true),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 100, right: 100, bottom: 15),
                          child: CommonElevatedButton(
                              context, "Pick PDF", _pickFiles),
                        ),
                        Container(
                          height: _selectedFiles == []
                              ? 0
                              : _selectedFiles.length * 90,
                          child: ListView.builder(
                            itemCount: _selectedFiles.length,
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
                                            _selectedFiles != []
                                                ? _selectedFiles[index]
                                                    .path
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
                                  SingleSelectDropdown(
                                    items: data?.data?.executives ?? [],
                                    selectedItem: _selectedItems,
                                    onChanged: (Executives? selectedItems) {
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
                                _selectedItems == null &&
                                (data?.data?.executives?.length ?? 0) != 0) {
                              ShowToastMessage("Select executive");
                            } else if (selectStatus_id == "") {
                              ShowToastMessage("Select Status");
                            } else {
                              String idList = "${_selectedItems?.id ?? ""}";

                              LoadingOverlay.show(context);

                              var formData = FormData.fromMap({
                                "is_new_client":
                                    isAddNewClient == true ? "1" : "0",
                                "requirement": _Requirement.text,
                                "client_id": client_id,
                                "cus_mobile_no": _ContactNumber.text,
                                "cus_first_name": _ClientName.text,
                                "address": _ClientAddress.text,
                                "status": selectStatus_id,
                                "status_note": _StatusNote.text,
                                "next_followup_date": _DatePicker.text,
                                for (var i = 0; i < idList.length; i++)
                                  'assign_executive[$i]': idList[i],
                                "company_id": company_id,
                              });

                              if (_selectedFiles != []) {
                                for (int i = 0;
                                    i < _selectedFiles.length;
                                    i++) {
                                  List<int> fileBytes =
                                      await _selectedFiles[i].readAsBytes();

                                  final filename = _selectedFiles[i].path != ""
                                      ? _selectedFiles[i].path.split('/').last
                                      : "file.jpg";

                                  formData.files.addAll([
                                    MapEntry(
                                        'report_upload[$i]',
                                        await MultipartFile.fromBytes(
                                          fileBytes,
                                          filename: filename,
                                        )),
                                  ]);
                                }
                                // formData.fields.add(MapEntry(
                                //     'education[$i][institute]', eduHistory[i].university_id));
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
                  return Center(
                      child: Text("Connection closed, Please try again!"));
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
