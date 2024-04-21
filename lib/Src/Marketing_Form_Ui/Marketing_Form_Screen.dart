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

class Marketing_Form_Screen extends ConsumerStatefulWidget {
  const Marketing_Form_Screen({super.key});

  @override
  ConsumerState<Marketing_Form_Screen> createState() => _Post_Job_ScreenState();
}

class _Post_Job_ScreenState extends ConsumerState<Marketing_Form_Screen> {
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Executives> _selectedItems = [];
  String client_id = "";
  String company_id = "";

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
    final _MarketingData = ref.watch(marketingDataProvider);

    return Scaffold(
      backgroundColor: white5,
      appBar: Custom_AppBar(
          title: "Marketing Form", actions: null, isGreen: false, isNav: true),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _MarketingData.when(
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
                              clientName = newValue;
                              int index = data!.data!.clients!.indexWhere(
                                  (st) => st.cusFirstName == newValue);
                              _ClientName.text =
                                  data.data!.clients![index].cusFirstName ?? "";
                              _ContactNumber.text =
                                  data.data!.clients![index].cusMobileNo ?? "";
                              _ClientAddress.text =
                                  data.data!.clients![index].address ?? "";
                              client_id =
                                  "${data.data!.clients![index].customerId ?? 0}";
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
                              DateTime? pickdate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2050));
                              if (pickdate != null) {
                                String formatdate =
                                    DateFormat("yyyy/MM/dd").format(pickdate!);
                                if (mounted) {
                                  setState(() {
                                    _DatePicker.text = formatdate;
                                    print(_DatePicker.text);
                                  });
                                }
                              }
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
                        Title_Style(Title: "Assign to", isStatus: true),
                        MultiSelectDropdown(
                          items: data?.data?.executives ?? [],
                          selectedItems: _selectedItems,
                          onChanged: (List<Executives> selectedItems) {
                            setState(() {
                              _selectedItems = selectedItems;
                            });
                          },
                        ),

                        const SizedBox(
                          height: 30,
                        ),
                        //BUTTON
                        CommonElevatedButton(context, "Submit", () {
                          if (_formKey.currentState!.validate()) {
                            if (client_id == "") {
                              ShowToastMessage("Select client name");
                            } else if (company_id == "") {
                              ShowToastMessage("Select company name");
                            } else if (_selectedItems.length == 0) {
                              ShowToastMessage("Select executive");
                            } else {
                              List<int> idList = _selectedItems
                                  .map((item) => item.id ?? 0)
                                  .toList();

                              Map<String, dynamic> data = {
                                "is_new_client": "0",
                                "client_id": client_id,
                                "cus_mobile_no": _ContactNumber.text,
                                "cus_first_name": _ClientName.text,
                                "address": _ClientAddress.text,
                                "status_note": _StatusNote.text,
                                "assign_executive": idList,
                                "company_id": company_id,
                                "plan_for_next_meet": _PlanofAction.text,
                                "next_followup_date": _DatePicker.text
                              };

                              addMarketingList(data);
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

  void addMarketingList(Map<String, dynamic> data) async {
    LoadingOverlay.show(context);

    final apiService = ApiService(ref.read(dioProvider));

    final postResponse =
        await apiService.post1<SuccessModel>(ConstantApi.marketingStore, data);
    LoadingOverlay.forcedStop();

    if (postResponse.success == true) {
      ShowToastMessage(postResponse.message ?? "");
      Navigator.pop(context, true);
    } else {
      ShowToastMessage(postResponse.message ?? "");
    }
  }
}
