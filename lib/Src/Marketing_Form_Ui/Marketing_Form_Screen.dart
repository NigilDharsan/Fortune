import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortune/Common_Widgets/Common_Button.dart';
import 'package:fortune/Common_Widgets/Custom_App_Bar.dart';
import 'package:fortune/Common_Widgets/Text_Form_Field.dart';
import 'package:fortune/utilits/Common_Colors.dart';
import 'package:fortune/utilits/Text_Style.dart';
import 'dart:io';

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
  List<String> _Status = ['Pending', 'Processing', 'Cancelled',"Completed"];
  List<String> _AssignExecutive = ['Arun', 'Madhesh', 'Naveen',"Nivas"];

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
    return Scaffold(
      backgroundColor: white5,
      appBar: Custom_AppBar(title: "Marketing Form",
          actions: null, isGreen: false, isNav: true),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20,right: 20),
              child: Column(
                children: [
                  //CLIENT NAME
                  Title_Style(Title: 'Select Client', isStatus: true),
                  dropDownField(
                    context,
                    hintT:"",
                    value: clientName,
                    listValue: _SelectClientName,
                    onChanged: (String? newValue) {
                      setState(() {
                        clientName = newValue;
                      });
                    },
                  ),
                  //COMPANY NAME
                  Title_Style(Title: "Company Name", isStatus: true),
                  dropDownField(
                    hintT:'',
                    context,
                    value: companyName,
                    listValue: _CompanyName,
                    onChanged: (String? newValue) {
                      setState(() {
                        companyName = newValue;
                      });
                    },
                  ),
                  //CLIENT NAME
                  Title_Style(Title: 'Client Name', isStatus: true),
                 textFormField(
                     hintText: "Client Name",
                     keyboardtype:  TextInputType.text,
                   Controller: _ClientName,
                     validating: (value) {
                       if (value == null || value.isEmpty) {
                         return "Please Enter ${'Client Name'}";
                       }
                       if (value == null) {
                         return "Please Enter ${'Client Name'}";
                       }
                       return null;
                     }
                 ),
                  //CLIENT CONTACT NUMBER
                  Title_Style(Title: 'Client Mobile Number', isStatus: true),
                  textFormField(
                    hintText: 'Mobile Number',
                    keyboardtype: TextInputType.phone,
                    inputFormatters: [LengthLimitingTextInputFormatter(10)],
                    Controller: _ContactNumber,
                    validating: (value) {
                      if (value!.isEmpty) {
                        return "Please enter a Contact Number";
                      } else if (!RegExp(r"^[0-9]{10}$").hasMatch(value)) {
                        return "Please enter a valid 10-digit Contact Number";
                      }
                      return null;
                    },
                    onChanged: null,
                  ),
                 //CLIENT ADDRESS
                  Title_Style(Title: "Client Address", isStatus: true),
                  textfieldDescription(
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
                      }
                  ),

                  //PLAN OF ACTION FOR THE NEXT MEET
                  Title_Style(Title: 'Plan of action for the next meet', isStatus: false),
                  textfieldDescription(
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
                      }
                  ),

                  //NEXT FOLLOW UP DATE
                  Title_Style(Title: 'Next Followup date', isStatus: true),
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
                      }
                  ),

                  //ASSIGN EXECUTIVE
                  Title_Style(Title: "Assign to", isStatus: true),
                  dropDownField(
                    context,
                    hintT:"Assign to",
                    value: assignExecutive,
                    listValue: _AssignExecutive,
                    onChanged: (String? newValue) {
                      setState(() {
                        assignExecutive = newValue;
                      });
                    },
                  ),

                  const SizedBox(height: 30,),
                  //BUTTON
                  CommonElevatedButton(context, "Submit", () { }),

                  const SizedBox(height: 50,),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
