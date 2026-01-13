import 'dart:io';

import 'package:collection/collection.dart';
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
import 'package:intl/intl.dart';
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
  TextEditingController _DatePicker = TextEditingController();
  TextEditingController _StatusNote = TextEditingController();
  TextEditingController _ClientName = TextEditingController();
  TextEditingController _ContactNumber = TextEditingController();
  TextEditingController _ClientAddress = TextEditingController();
  TextEditingController _Requirement = TextEditingController();

  List<File> _selectedFiles = [];
  Executives? _selectedItems;
  List<FocusNode> focus = [];
  List<Map<String, dynamic>> itemsData = [];
  List<int> itemsDeleteID = [];

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

    getImagePath(List<String> imageUrl) async {
      List<File> _selectedFiles1 = [];

      for (var obj in imageUrl) {
        if (obj != "") {
          File? _Filespath = await downloadAndSaveImage(obj);
          _selectedFiles1.add(_Filespath!);
        }
      }
      // setState(() {
      _selectedFiles = _selectedFiles1;
      // });
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
                    _Requirement.text = data?.data?.data?[0].requirement ?? "";

                    int index = data!.data!.companies!.indexWhere(
                        (st) => st.companyId == data.data?.data?[0].companyId);
                    if (index >= 0) {
                      companyName =
                          data.data!.companies![index].companyBranch ?? "";
                    }

                    if (!isvalueUpdated) {
                      itemsData = [
                        {
                          'item_id': "",
                          'productName': "",
                          'quantity': "",
                        }
                      ];
                      final focusCount = FocusNode();
                      focus = [focusCount];

                      final salesrep =
                          data.data?.data?[0].servicerepsInvolved ?? "";

                      List<String> servicerepsList = salesrep.split(',');

                      // Convert the array of strings into an array of integers
                      List<int> servicerepsIntArray =
                          servicerepsList.map(int.parse).toList();

                      _selectedItems = data.data!.executives!.firstWhereOrNull(
                          (executive) =>
                              servicerepsIntArray.contains(executive.id));

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
                      _DatePicker.text =
                          data?.data?.data?[0].nextFollowupDate ?? "";

                      getImagePath(data.data?.data?[0].reportUpload ?? []);
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
                              isEnabled: true,
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
                            hintText: 'Mobile Number',
                            isEnabled: true,
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

                          //STATUS NOTE
                          Title_Style(Title: 'Status Note', isStatus: false),
                          textfieldDescription(
                              readOnly: false,
                              Controller: _StatusNote,
                              hintText: 'Enter Status Note',
                              validating: null),

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
                                              _selectedFiles[index].path != null
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
                                    SingleSelectDropdown(
                                      items: data.data?.executives ?? [],
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

                          for (int i = 0;
                              i < (data.data?.serviceSpare?.length ?? 0);
                              i++)
                            Column(
                              children: [
                                SizedBox(height: 16.0),

                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: TextEditingController()
                                      ..text =
                                          "${data.data?.serviceSpare?[i].spare?.item?.itemName}",
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 20.0, horizontal: 20.0),
                                      labelText: 'Spare Items',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),

                                SizedBox(height: 16.0),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: TextFormField(
                                          readOnly: true,
                                          controller: TextEditingController()
                                            ..text =
                                                "${data.data?.serviceSpare?[i].quantity}",
                                          onChanged: (typed) {},
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
                                      child: IconButton(
                                        alignment: Alignment.topRight,
                                        icon: Icon(Icons.remove_circle),
                                        onPressed: () {
                                          setState(() {
                                            itemsDeleteID.add(data.data
                                                    ?.serviceSpare?[i].id ??
                                                0);
                                            data.data?.serviceSpare
                                                ?.removeAt(i);
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

                          // Add space between items
                          Title_Style(Title: "Add Spares", isStatus: false),

                          for (int i = 0; i < itemsData.length; i++)
                            Column(
                              children: [
                                SizedBox(height: 16.0),

                                dropDownSparesSearchField(
                                  context,
                                  listValue: data.data?.spareItem ?? [],
                                  onChanged: ((x) {
                                    focus[i].unfocus();

                                    setState(() {
                                      int index = data!.data!.spareItem!
                                          .indexWhere((st) =>
                                              st.itemName == x.searchKey);

                                      final getValue = {
                                        'item_id':
                                            "${data.data!.spareItem![index].spareId}",
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
                                    int index = data!.data!.spareItem!
                                        .indexWhere((st) => st.itemName == x);

                                    if (index == -1) {
                                      return null;
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
                                          },
                                          keyboardType: TextInputType.number,

                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            TextInputFormatter.withFunction(
                                                (oldValue, newValue) {
                                              if (newValue.text.isEmpty) {
                                                return newValue; // Allow empty input
                                              }
                                              final int value =
                                                  int.tryParse(newValue.text) ??
                                                      0;

                                              int index = data.data!.spareItem!
                                                  .indexWhere((st) =>
                                                      st.spareId ==
                                                      int.parse(itemsData[i]
                                                          ['item_id']));
                                              int qty = 0;
                                              if (index >= 0) {
                                                qty = data.data!.spareItem
                                                            ?.length !=
                                                        0
                                                    ? (data
                                                            .data!
                                                            .spareItem?[index]
                                                            .quantity ??
                                                        0)
                                                    : 0;
                                              }

                                              if (value <= (qty)) {
                                                return newValue; // Allow if value is less than or equal to 10000
                                              }
                                              return oldValue; // Reject the input if it exceeds 10000
                                            }),
                                          ], // Only numbers can be entered

                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 20.0,
                                                    horizontal: 20.0),
                                            labelText: 'Quantity',
                                            border: OutlineInputBorder(),
                                            hintText: 'Enter quantity',
                                          ),
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
                          const SizedBox(
                            height: 30,
                          ),
                          //BUTTON
                          CommonElevatedButton(context, "Update", () async {
                            if (_formKey.currentState!.validate()) {
                              if (singleton.permissionList
                                          .contains("service-assign") ==
                                      true &&
                                  _selectedItems == null &&
                                  (data.data?.executives?.length ?? 0) != 0) {
                                ShowToastMessage("Select executive");
                              } else {
                                String idList = "${_selectedItems?.id ?? ""}";

                                final spareData = itemsData
                                    .where(
                                        (toElement) => toElement["new"] == true)
                                    .toList();
                                var formData = FormData();
                                if (itemsData[0]['item_id'] != "") {
                                  formData = FormData.fromMap({
                                    "status": selectStatus_id,
                                    "requirement": _Requirement.text,
                                    "status_note": _StatusNote.text,
                                    "next_followup_date": _DatePicker.text,
                                    for (var i = 0; i < idList.length; i++)
                                      'assign_executive[$i]': idList[i],
                                    "_method": "PUT",
                                    "deleted_spare": itemsDeleteID.join(","),
                                    for (var i = 0; i < itemsData.length; i++)
                                      'spare_lists[$i][spare_id]': itemsData[i]
                                          ['item_id'],
                                    for (var j = 0; j < itemsData.length; j++)
                                      'spare_lists[$j][quantity]': itemsData[j]
                                          ['quantity'],
                                  });
                                } else {
                                  formData = FormData.fromMap({
                                    "status": selectStatus_id,
                                    "requirement": _Requirement.text,
                                    "status_note": _StatusNote.text,
                                    "next_followup_date": _DatePicker.text,
                                    for (var i = 0; i < idList.length; i++)
                                      'assign_executive[$i]': idList[i],
                                    "_method": "PUT",
                                    "deleted_spare": itemsDeleteID.join(","),
                                  });
                                }

                                if (_selectedFiles.length != 0) {
                                  for (int i = 0;
                                      i < _selectedFiles.length;
                                      i++) {
                                    List<int> fileBytes =
                                        await _selectedFiles[i].readAsBytes();

                                    final filename = _selectedFiles[i].path !=
                                            ""
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
                    return Center(
                        child: Text("Connection closed, Please try again!"));
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
