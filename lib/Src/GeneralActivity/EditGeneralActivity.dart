import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortune/Common_Widgets/Common_Button.dart';
import 'package:fortune/Common_Widgets/Custom_App_Bar.dart';
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
import 'package:intl/intl.dart';

class EditGeneralScreen extends ConsumerStatefulWidget {
  String marketing_id = "";

  EditGeneralScreen({super.key, required this.marketing_id});

  @override
  ConsumerState<EditGeneralScreen> createState() => _EditGeneralScreenState();
}

class _EditGeneralScreenState extends ConsumerState<EditGeneralScreen> {
  TextEditingController _DatePicker = TextEditingController();
  TextEditingController _NextFollowDatePicker = TextEditingController();

  TextEditingController _StatusNote = TextEditingController();
  TextEditingController _ClientAddress = TextEditingController();
  TextEditingController _ClientName = TextEditingController();
  TextEditingController _PlanofAction = TextEditingController();
  TextEditingController _ContactNumber = TextEditingController();
  TextEditingController _Reference = TextEditingController();
  TextEditingController _Requirement = TextEditingController();

  TextEditingController _CurrentFollowUp = TextEditingController();
  TextEditingController _NextFollowUp = TextEditingController();

  String TimeVal = '';
  TimeOfDay? _selectedTime;
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  String _formatTime(TimeOfDay time) {
    // Format the time as HH:mm a (e.g., 05:30 PM)
    final now = DateTime.now();
    final dateTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final formattedTime = TimeOfDay.fromDateTime(dateTime).format(context);
    return formattedTime;
  }

  List<String> _SelectClientName = ['Bosh', 'Pricol', 'Tessolv'];
  List<String> _CompanyName = ['Zoho', 'wipro', 'Advance'];
  List<String> _Status = ['Pending', 'Processing', 'Cancelled', "Completed"];
  List<String> _AssignExecutive = ['Arun', 'Madhesh', 'Naveen', "Nivas"];
  List<String> _selectState = [
    'Completed',
    'Pending',
    'Processing',
    "Cancelled"
  ];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Executives> _selectedItems = [];
  String client_id = "";
  String company_id = "";
  bool? isAddNewClient;

  bool isvalueUpdated = false;

  String? selectStatus;
  String? selectStatus_id;
  String? selectMarketing_Type;

  String? Degree;
  String? clientName;
  String? companyName;
  String? assignExecutive;
  String? status;

  List<String> _selectMarketingType = [
    'Payment',
    'Delivery',
  ];

  SingleTon singleton = SingleTon();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedTime = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    final _MarketingData = ref.watch(generalEditProvider(widget.marketing_id));
    final _exectiveListData = ref.watch(marketingDataProvider);

    return Scaffold(
      backgroundColor: white5,
      appBar: Custom_AppBar(
          title: "Edit General Activity",
          actions: null,
          isGreen: false,
          isNav: true),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _MarketingData.when(
                data: (data) {
                  // clientName = data?.data?.data?.clientName ?? "";
                  // _ClientName.text = data?.data?.data?.clientName ?? "";
                  // _ClientAddress.text = data?.data?.data?.address ?? "";
                  // _ContactNumber.text = data?.data?.data?.contactNo ?? "";

                  // int index = data!.data!.companies!.indexWhere((st) =>
                  //     st.companyId ==
                  //     int.parse(data.data?.data?.companyId ?? "0"));

                  // companyName =
                  //     data.data!.companies![index].companyBranch ?? "";
                  List<int> servicerepsIntArray = [];
                  if (!isvalueUpdated && data?.data?.length != 0) {
                    final salesrep = data?.data?[0].salesrepInvolved ?? "";
                    // _Requirement.text = data?.data?.data?.requirement ?? "";
                    selectMarketing_Type = data?.data?[0].type ?? "";

                    List<String> servicerepsList = salesrep.split(',');

                    // Convert the array of strings into an array of integers
                    servicerepsIntArray =
                        servicerepsList.map(int.parse).toList();

                    selectStatus_id = data?.data?[0].status ?? "";
                    _StatusNote.text = data?.data?[0].statusNote ?? "";
                    _DatePicker.text = data?.data?[0].currentFollowup ?? "";
                    _NextFollowDatePicker.text =
                        data?.data?[0].nextFollowup ?? "";
                    selectStatus = data?.data?[0].status ?? "";
                  }

                  return Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      children: [
                        //SELECT TYPE
                        Title_Style(Title: "Select Type", isStatus: true),
                        dropDownField(
                          context,
                          hintT: 'Select Type',
                          value: selectMarketing_Type,
                          listValue: _selectMarketingType,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectMarketing_Type = newValue ?? "";
                            });
                          },
                        ),

                        //CLIENT NAME
                        // Title_Style(Title: 'Select Client', isStatus: true),

                        // dropDownField(
                        //   context,
                        //   hintT: "Select Client",
                        //   value: clientName,
                        //   listValue: ["${clientName}"],
                        //   onChanged: (String? newValue) {},
                        // ),

                        //CLIENT NAME
                        // Title_Style(Title: 'Client Name', isStatus: true),
                        // textFormField(
                        //     isEnabled: false,
                        //     hintText: "Client Name",
                        //     keyboardtype: TextInputType.text,
                        //     Controller: _ClientName,
                        //     validating: (value) {
                        //       if (value == null || value.isEmpty) {
                        //         return "Please Enter ${'Client Name'}";
                        //       }
                        //       if (value == null) {
                        //         return "Please Enter ${'Client Name'}";
                        //       }
                        //       return null;
                        //     }),
                        // //CLIENT CONTACT NUMBER
                        // Title_Style(
                        //     Title: 'Client Mobile Number', isStatus: false),
                        // textFormField(
                        //   isEnabled: true,
                        //   hintText: 'Mobile Number',
                        //   keyboardtype: TextInputType.phone,
                        //   inputFormatters: [
                        //     LengthLimitingTextInputFormatter(10)
                        //   ],
                        //   Controller: _ContactNumber,
                        //   // validating: (value) {
                        //   //   if (value!.isEmpty) {
                        //   //     return "Please enter a Contact Number";
                        //   //   } else if (!RegExp(r"^[0-9]{10}$")
                        //   //       .hasMatch(value)) {
                        //   //     return "Please enter a valid 10-digit Contact Number";
                        //   //   }
                        //   //   return null;
                        //   // },
                        //   onChanged: null,
                        // ),
                        // //CLIENT ADDRESS
                        // Title_Style(Title: "Client Address", isStatus: true),
                        // textfieldDescription(
                        //     readOnly: false,
                        //     Controller: _ClientAddress,
                        //     hintText: 'Enter Address',
                        //     validating: (value) {
                        //       if (value == null || value.isEmpty) {
                        //         return "Please Enter ${'Address'}";
                        //       }
                        //       if (value == null) {
                        //         return "Please Enter ${'Address'}";
                        //       }
                        //       return null;
                        //     }),

                        //PLAN OF ACTION FOR THE NEXT MEET
                        Title_Style(
                            Title: 'Current Followup up', isStatus: true),
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
                                      DateFormat("dd/MM/yyyy hh:mm a")
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
                            hintText: 'dd/MM/yyyy'),

                        //NEXT FOLLOW UP DATE
                        Title_Style(Title: 'Next Followup up', isStatus: true),
                        TextFieldDatePicker(
                            Controller: _NextFollowDatePicker,
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
                                      DateFormat("dd/MM/yyyy hh:mm a")
                                          .format(selectedDateTime);
                                  if (mounted) {
                                    setState(() {
                                      _NextFollowDatePicker.text = formatdate;
                                      print(_NextFollowDatePicker.text);
                                    });
                                  }
                                }
                              }
                            },
                            hintText: 'dd/MM/yyyy'),
                        //NEXT FOLLOW UP DATE
                        // Title_Style(
                        //     Title: 'Next Followup date', isStatus: true),
                        // TextFieldDatePicker(
                        //     Controller: _DatePicker,
                        //     onChanged: null,
                        //     validating: (value) {
                        //       if (value!.isEmpty) {
                        //         return 'Please select Date';
                        //       } else {
                        //         return null;
                        //       }
                        //     },
                        //     onTap: () async {
                        //       FocusScope.of(context).unfocus();

                        //       DateTime? pickedDate = await showDatePicker(
                        //         context: context,
                        //         initialDate: DateTime.now(),
                        //         firstDate: DateTime.now(),
                        //         lastDate: DateTime(2101),
                        //       );
                        //       if (pickedDate != null) {
                        //         final TimeOfDay? pickedTime =
                        //             await showTimePicker(
                        //           context: context,
                        //           initialTime: TimeOfDay.now(),
                        //         );
                        //         if (pickedTime != null) {
                        //           final DateTime selectedDateTime = DateTime(
                        //             pickedDate.year,
                        //             pickedDate.month,
                        //             pickedDate.day,
                        //             pickedTime.hour,
                        //             pickedTime.minute,
                        //           );
                        //           setState(() {
                        //             _DatePicker.text =
                        //                 DateFormat('dd/MM/yyyy hh:mm a')
                        //                     .format(selectedDateTime);
                        //           });
                        //         }
                        //       }
                        //       // DateTime? pickdate = await showDatePicker(
                        //       //     context: context,
                        //       //     initialDate: DateTime.now(),
                        //       //     firstDate: DateTime.now(),
                        //       //     lastDate: DateTime(2050));
                        //       // if (pickdate != null) {
                        //       //   String formatdate =
                        //       //       DateFormat("dd/MM/yyyy").format(pickdate!);
                        //       //   if (mounted) {
                        //       //     if (formatdate != null) {
                        //       //       showTimePicker(
                        //       //         context: context,
                        //       //         initialTime: TimeOfDay.now(),
                        //       //       ).then((selectedTime) {
                        //       //         // Handle the selected date and time here.
                        //       //         if (selectedTime != null) {
                        //       //           DateTime selectedDateTime = DateTime(
                        //       //             selectedTime.hour,
                        //       //             selectedTime.minute,
                        //       //           );
                        //       //           print(
                        //       //               selectedDateTime); // You can use the selectedDateTime as needed.
                        //       //         }
                        //       //       });
                        //       //     }
                        //       //     setState(() {
                        //       //       _DatePicker.text = formatdate;
                        //       //       print(_DatePicker.text);
                        //       //     });
                        //       //   }
                        //       // }
                        //     },
                        //     hintText: 'dd/MM/yyyy'),

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

                              selectStatus_id = selectStatus == "Completed"
                                  ? "1"
                                  : selectStatus == "Pending"
                                      ? "2"
                                      : selectStatus == "Processing"
                                          ? "3"
                                          : selectStatus == "Cancelled"
                                              ? "4"
                                              : "";
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

                        singleton.permissionList.contains("lead-assign") == true
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
                                  _exectiveListData.when(
                                    data: (data) {
                                      if (!isvalueUpdated) {
                                        isvalueUpdated = true;
                                        _selectedItems = data!.data!.executives!
                                            .where((executive) =>
                                                servicerepsIntArray
                                                    .contains(executive.id))
                                            .toList();
                                      }

                                      return MultiSelectExectiveDropdown(
                                        items: data!.data?.executives ?? [],
                                        selectedItems: _selectedItems,
                                        onChanged:
                                            (List<Executives> selectedItems) {
                                          setState(() {
                                            _selectedItems = selectedItems;
                                          });
                                        },
                                      );
                                    },
                                    error:
                                        (Object error, StackTrace stackTrace) {
                                      return Center(
                                          child: Text(
                                              "Connection closed, Please try again!"));
                                    },
                                    loading: () => Center(
                                        child: CircularProgressIndicator()),
                                  )
                                ],
                              )
                            : Container(),
                        const SizedBox(
                          height: 30,
                        ),
                        //BUTTON
                        CommonElevatedButton(context, "Update", () {
                          // if (_formKey.currentState!.validate()) {
                          //   if (singleton.permissionList
                          //               .contains("service-assign") ==
                          //           true &&
                          //       _selectedItems.length == 0 &&
                          //       (data.data?.executives?.length ?? 0) != 0) {
                          //     ShowToastMessage("Select executive");
                          //   }
                          //    else
                          if (selectMarketing_Type == "" ||
                              selectMarketing_Type == null) {
                            ShowToastMessage("Select Type");
                          } else {
                            List<String> idList = _selectedItems
                                .map((item) => "${item.id ?? 0}")
                                .toList();
                            var formData = FormData.fromMap({
                              "followup_id": data?.data?[0].followupId,
                              "client_id": data?.data?[0].clientId,
                              "salesrep_involved":
                                  idList.join(","), //multiple sales reps 2,3,4
                              "type": selectMarketing_Type,
                              "status": selectStatus,
                              "current_followup": _DatePicker.text,
                              "next_followup": _NextFollowDatePicker.text,
                              "status_note": _StatusNote.text
                            });

                            addMarketingList(formData);
                          }
                          // }
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

  void addMarketingList(FormData data) async {
    LoadingOverlay.show(context);

    final apiService = ApiService(ref.read(dioProvider));

    final postResponse =
        await apiService.post<SuccessModel>(ConstantApi.updateGeneralUrl, data);
    LoadingOverlay.forcedStop();

    if (postResponse.success == true) {
      ShowToastMessage(postResponse.message ?? "");
      Navigator.pop(context, true);
    } else {
      ShowToastMessage(postResponse.message ?? "");
    }
  }
}
