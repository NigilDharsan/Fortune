import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class Marketing_Form_Edit_Screen extends ConsumerStatefulWidget {
  String marketing_id = "";

  Marketing_Form_Edit_Screen({super.key, required this.marketing_id});

  @override
  ConsumerState<Marketing_Form_Edit_Screen> createState() =>
      _Marketing_Form_Edit_ScreenState();
}

class _Marketing_Form_Edit_ScreenState
    extends ConsumerState<Marketing_Form_Edit_Screen> {
  TextEditingController _DatePicker = TextEditingController();
  TextEditingController _StatusNote = TextEditingController();
  TextEditingController _ClientAddress = TextEditingController();
  TextEditingController _ClientName = TextEditingController();
  TextEditingController _PlanofAction = TextEditingController();
  TextEditingController _ContactNumber = TextEditingController();

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
    'completed',
    'pending',
    'processing',
    "cancelled"
  ];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Executives> _selectedItems = [];
  String client_id = "";
  String company_id = "";
  bool? isAddNewClient;

  bool isvalueUpdated = false;

  String? selectStatus;
  String? selectStatus_id;

  String? Degree;
  String? clientName;
  String? companyName;
  String? assignExecutive;
  String? status;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedTime = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    final _MarketingData =
        ref.watch(marketingEditProvider(widget.marketing_id));

    return Scaffold(
      backgroundColor: white5,
      appBar: Custom_AppBar(
          title: "Edit Marketing Form",
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
                  clientName = data?.data?.data?.clientName ?? "";
                  _ClientName.text = data?.data?.data?.clientName ?? "";
                  _ClientAddress.text = data?.data?.data?.address ?? "";
                  _ContactNumber.text = data?.data?.data?.contactNo ?? "";

                  int index = data!.data!.companies!.indexWhere((st) =>
                      st.companyId ==
                      int.parse(data.data?.data?.companyId ?? "0"));

                  companyName = data.data!.companies![index].name ?? "";

                  if (!isvalueUpdated) {
                    isvalueUpdated = true;
                    selectStatus_id = data.data?.data?.status ?? "";
                    _StatusNote.text = data.data?.data?.instructions ?? "";
                    _PlanofAction.text = data.data?.data?.planForNextMeet ?? "";
                    _DatePicker.text = data.data?.data?.nextFollowupDate ?? "";
                    selectStatus = selectStatus_id == "1"
                        ? "completed"
                        : selectStatus_id == "2"
                            ? "pending"
                            : selectStatus_id == "3"
                                ? "processing"
                                : selectStatus_id == "4"
                                    ? "cancelled"
                                    : "";
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
                          value: clientName,
                          listValue: ["${clientName}"],
                          onChanged: (String? newValue) {},
                        ),
                        //COMPANY NAME
                        Title_Style(Title: "Company Name", isStatus: true),
                        dropDownField(
                          hintT: 'Select Company Name',
                          context,
                          value: companyName,
                          listValue: ["${companyName}"],
                          onChanged: (String? newValue) {},
                        ),
                        //CLIENT NAME
                        Title_Style(Title: 'Client Name', isStatus: true),
                        textFormField(
                            isEnabled: false,
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
                          isEnabled: false,
                          hintText: 'Mobile Number',
                          keyboardtype: TextInputType.phone,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10)
                          ],
                          Controller: _ContactNumber,
                          validating: (value) {
                            if (value!.isEmpty) {
                              return "Please enter a Contact Number";
                            } else if (!RegExp(r"^[0-9]{10}$")
                                .hasMatch(value)) {
                              return "Please enter a valid 10-digit Contact Number";
                            }
                            return null;
                          },
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

                        //PLAN OF ACTION FOR THE NEXT MEET
                        Title_Style(
                            Title: 'Plan of action for the next meet',
                            isStatus: false),
                        textfieldDescription(
                            readOnly: false,
                            Controller: _PlanofAction,
                            hintText: 'Plan of action for the next meet',
                            validating: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please Enter ${'Note'}";
                              }
                              if (value == null) {
                                return "Please Enter ${'Note'}";
                              }
                              return null;
                            }),

                        //NEXT FOLLOW UP DATE
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
                                lastDate: DateTime(2101),
                              );
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
                                  setState(() {
                                    _DatePicker.text =
                                        DateFormat('dd/MM/yyyy hh:mm a')
                                            .format(selectedDateTime);
                                  });
                                }
                              }
                              // DateTime? pickdate = await showDatePicker(
                              //     context: context,
                              //     initialDate: DateTime.now(),
                              //     firstDate: DateTime.now(),
                              //     lastDate: DateTime(2050));
                              // if (pickdate != null) {
                              //   String formatdate =
                              //       DateFormat("dd/MM/yyyy").format(pickdate!);
                              //   if (mounted) {
                              //     if (formatdate != null) {
                              //       showTimePicker(
                              //         context: context,
                              //         initialTime: TimeOfDay.now(),
                              //       ).then((selectedTime) {
                              //         // Handle the selected date and time here.
                              //         if (selectedTime != null) {
                              //           DateTime selectedDateTime = DateTime(
                              //             selectedTime.hour,
                              //             selectedTime.minute,
                              //           );
                              //           print(
                              //               selectedDateTime); // You can use the selectedDateTime as needed.
                              //         }
                              //       });
                              //     }
                              //     setState(() {
                              //       _DatePicker.text = formatdate;
                              //       print(_DatePicker.text);
                              //     });
                              //   }
                              // }
                            },
                            hintText: 'dd/MM/yyyy'),

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

                        const SizedBox(
                          height: 30,
                        ),
                        //BUTTON
                        CommonElevatedButton(context, "Submit", () {
                          if (_formKey.currentState!.validate()) {
                            var formData = FormData.fromMap({
                              "status_note": _StatusNote.text,
                              "status": selectStatus_id,
                              "_method": "PUT",
                              "plan_for_next_meet": _PlanofAction.text,
                              "next_followup_date": _DatePicker.text
                            });

                            addMarketingList(formData);
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

  void addMarketingList(FormData data) async {
    LoadingOverlay.show(context);

    final apiService = ApiService(ref.read(dioProvider));

    final postResponse = await apiService.post<SuccessModel>(
        ConstantApi.marketingStore + "/${widget.marketing_id}", data);
    LoadingOverlay.forcedStop();

    if (postResponse.success == true) {
      ShowToastMessage(postResponse.message ?? "");
      Navigator.pop(context, true);
    } else {
      ShowToastMessage(postResponse.message ?? "");
    }
  }
}
