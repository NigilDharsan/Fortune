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
import 'package:fortune/Model/ServiceModel.dart';
import 'package:fortune/Model/SuccessModel.dart';
import 'package:fortune/utilits/ApiProvider.dart';
import 'package:fortune/utilits/ApiService.dart';
import 'package:fortune/utilits/Common_Colors.dart';
import 'package:fortune/utilits/ConstantsApi.dart';
import 'package:fortune/utilits/Generic.dart';
import 'package:fortune/utilits/Loading_Overlay.dart';
import 'package:fortune/utilits/Text_Style.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:tuple/tuple.dart';

class Service_Form_Edit_Screen extends ConsumerStatefulWidget {
  String service_id = "";

  Service_Form_Edit_Screen({super.key, required this.service_id});

  @override
  ConsumerState<Service_Form_Edit_Screen> createState() =>
      _Service_Form_Edit_ScreenState();
}

class _Service_Form_Edit_ScreenState
    extends ConsumerState<Service_Form_Edit_Screen> {
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

  List<String> _selectState = [
    'completed',
    'pending',
    'processing',
    "cancelled"
  ];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? Degree;
  String? clientName;
  String? companyName;
  String? selectStatus;
  String? selectStatus_id;

  bool isvalueUpdated = false;

  String? status;
  int? clientSelectedIndex;

  String client_id = "";
  String company_id = "";

  SingleTon singleton = SingleTon();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _ServiceData = ref.watch(serviceEditProvider(widget.service_id));

    Future<File?> downloadAndSaveImage(String imageUrl) async {
      var response = await http.get(Uri.parse(imageUrl));
      final documentDirectory = await getApplicationDocumentsDirectory();

      final filename = documentDirectory.path != null
          ? documentDirectory.path.split('/').last
          : "file.jpg";

      final file = File('${documentDirectory.path}/${filename}');
      await file.writeAsBytes(response.bodyBytes);
      print('Image downloaded and saved as ${file.path}');
      return file;
    }

    getImagePath(String imageUrl) async {
      if (imageUrl != "") {
        File? _Filespath = await downloadAndSaveImage(imageUrl);

        setState(() {
          _selectedFiles = _Filespath;
        });
      }
    }

    return Scaffold(
      backgroundColor: white5,
      appBar: Custom_AppBar(
          title: "Edit Service Form",
          actions: null,
          isGreen: false,
          isNav: true),
      body: Consumer(builder: (context, watch, _) {
        return Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _ServiceData.when(
                  data: (data) {
                    _ClientName.text = data?.data?.data?[0].cusFirstName ?? "";
                    _ClientAddress.text = data?.data?.data?[0].address ?? "";
                    _ContactNumber.text =
                        data?.data?.data?[0].cusMobileNo ?? "";

                    int index = data!.data!.companies!.indexWhere(
                        (st) => st.companyId == data.data?.data?[0].companyId);
                    if (index >= 0) {
                      companyName =
                          data.data!.companies![index].companyBranch ?? "";
                    }

                    if (!isvalueUpdated) {
                      final salesrep =
                          data.data?.data?[0].servicerepsInvolved ?? "";

                      List<String> servicerepsList = salesrep.split(',');

                      // Convert the array of strings into an array of integers
                      List<int> servicerepsIntArray =
                          servicerepsList.map(int.parse).toList();

                      _selectedItems = data.data!.executives!
                          .where((executive) =>
                              servicerepsIntArray.contains(executive.id))
                          .toList();

                      _StatusNote.text =
                          data.data?.data?[0].reportDescription ?? "";

                      isvalueUpdated = true;
                      selectStatus_id = data.data?.data?[0].status ?? "";

                      selectStatus = selectStatus_id == "1"
                          ? "completed"
                          : selectStatus_id == "2"
                              ? "pending"
                              : selectStatus_id == "3"
                                  ? "processing"
                                  : selectStatus_id == "4"
                                      ? "cancelled"
                                      : "";
                      getImagePath(data.data?.data?[0].reportUpload ?? "");
                    }

                    return Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        children: [
                          //CLIENT NAME
                          Title_Style(Title: 'Select Client', isStatus: true),
                          dropDownField(
                            context,
                            hintT: "Select Client",
                            value: data.data?.data?[0].cusFirstName ?? "",
                            listValue: [
                              "${data.data?.data?[0].cusFirstName ?? ""}"
                            ],
                            onChanged: (String? newValue) {},
                          ),
                          //COMPANY NAME
                          Title_Style(Title: "Company Name", isStatus: true),
                          dropDownField(
                            hintT: 'Select Company Name',
                            context,
                            value: companyName,
                            listValue: [companyName ?? ""],
                            onChanged: (String? newValue) {},
                          ),
                          //CLIENT NAME
                          Title_Style(Title: 'Client Name', isStatus: true),
                          textFormField(
                              hintText: "Client Name",
                              keyboardtype: TextInputType.text,
                              Controller: _ClientName,
                              isEnabled: false,
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
                            hintText: 'Mobile Number',
                            isEnabled: false,
                            keyboardtype: TextInputType.phone,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10)
                            ],
                            Controller: _ContactNumber,
                            // validating: (value) {
                            //   if (value!.isEmpty) {
                            //     return "Please enter a Contact Number";
                            //   }
                            //   return null;
                            // },
                            onChanged: null,
                          ),
                          //CLIENT ADDRESS
                          Title_Style(Title: "Client Address", isStatus: true),
                          textfieldDescription(
                              readOnly: true,
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
                                    //         pdfPath:
                                    //             _selectedFiles?.path ?? ""),
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
                                                  child:
                                                      ImgPathSvg("pdf.svg"))),
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
                                            padding: const EdgeInsets.only(
                                                right: 20),
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
                                                : "";
                              });
                            },
                          ),

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
                                      items: data.data?.executives ?? [],
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
                          CommonElevatedButton(context, "Update", () async {
                            if (_formKey.currentState!.validate()) {
                              if (singleton.permissionList
                                          .contains("service-assign") ==
                                      true &&
                                  _selectedItems.length == 0) {
                                ShowToastMessage("Select executive");
                              } else {
                                List<String> idList = _selectedItems
                                    .map((item) => "${item.id ?? 0}")
                                    .toList();

                                var formData = FormData.fromMap({
                                  "status": selectStatus_id,
                                  "status_note": _StatusNote.text,
                                  for (var i = 0; i < idList.length; i++)
                                    'assign_executive[$i]': idList[i],
                                  "_method": "PUT",
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

                                LoadingOverlay.show(context);

                                final tuple =
                                    Tuple2(widget.service_id, formData);
                                final result = await ref
                                    .read(serviceUpdateProvider(tuple).future);
                                LoadingOverlay.forcedStop();
                                // Handle the result
                                if (result != null) {
                                  ShowToastMessage(result.message ?? "");
                                  Navigator.pop(context, true);

                                  // Handle success
                                } else {
                                  // Handle failure
                                  ShowToastMessage(result?.message ?? "");
                                }
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
        );
      }),
    );
  }

  void addServiceList(FormData formData) async {
    LoadingOverlay.show(context);

    final apiService = ApiService(ref.read(dioProvider));

    final postResponse = await apiService.post<SuccessModel>(
        ConstantApi.servicesStore + "/${widget.service_id}", formData);
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
