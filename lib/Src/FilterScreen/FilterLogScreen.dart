import 'package:flutter/material.dart';
import 'package:fortune/Common_Widgets/Common_Button.dart';
import 'package:fortune/Common_Widgets/Custom_App_Bar.dart';
import 'package:fortune/Common_Widgets/Text_Form_Field.dart';
import 'package:fortune/Model/AttendanceLogsModel.dart';
import 'package:fortune/Model/ServiceListModel.dart';
import 'package:fortune/Model/ServiceModel.dart';
import 'package:fortune/utilits/Generic.dart';
import 'package:fortune/utilits/Text_Style.dart';
import 'package:intl/intl.dart';

class FilterLogScreen extends StatefulWidget {
  FilterLog? filter;

  FilterLogScreen({super.key, required this.filter});

  @override
  State<FilterLogScreen> createState() => _FilterLogScreenState();
}

class _FilterLogScreenState extends State<FilterLogScreen> {
  String? Degree;
  String? clientName;
  String? companyName;
  String? selectStatus;
  String? selectStatus_id;

  bool isvalueUpdated = false;

  String? status;
  int? clientSelectedIndex;
  List<Branch>? filterBranch = [];

  List<String> _selectState = [
    'completed',
    'pending',
    'processing',
    "cancelled"
  ];

  var dateRange = "";

  SingleTon singleton = SingleTon();
  final GlobalKey<FormFieldState> _formKey = GlobalKey<FormFieldState>();

  List<Map<String, String>> months = [];

  List<String> monthNumbers = [];
  List<String> monthNames = [];

  String year = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    DateTime now = DateTime.now();
    String month = now.month.toString().padLeft(2, '0');
    year = now.year.toString();

    months = getCurrentAndPreviousMonths();

    // Split into two separate lists
    for (var month in months) {
      month.forEach((key, value) {
        monthNumbers.add(key);
        monthNames.add(value);
      });
    }

    singleton.filterMonth = monthNumbers[0];
    singleton.filterYear = year;
    singleton.filterUserID = null;
  }

  List<Map<String, String>> getCurrentAndPreviousMonths() {
    DateTime now = DateTime.now();

    // Get the previous month and handle the year transition
    DateTime previousMonthDate;
    if (now.month == 1) {
      // If current month is January, set previous month to December of the previous year
      previousMonthDate = DateTime(now.year - 1, 12);
    } else {
      // Otherwise, just subtract one month
      previousMonthDate = DateTime(now.year, now.month - 1);
    }

    DateFormat monthFormat = DateFormat('MM');
    DateFormat monthNameFormat = DateFormat('MMMM');

    String currentMonthNumber = monthFormat.format(now);
    String currentMonthName = monthNameFormat.format(now);

    String previousMonthNumber = monthFormat.format(previousMonthDate);
    String previousMonthName = monthNameFormat.format(previousMonthDate);

    return [
      {currentMonthNumber: currentMonthName},
      {previousMonthNumber: previousMonthName},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: singleton.filterEnable == true
            ? Custom_AppBar(
                title: "Filter",
                isGreen: false,
                isNav: true,
                actions: <Widget>[
                  Stack(children: [
                    Padding(
                      padding: EdgeInsets.only(
                          right: 16.0), // Adjust the padding as needed
                      child: InkWell(
                          onTap: () {
                            singleton.filterSalesrep = null;
                            singleton.filterSalesrepID = null;

                            singleton.filterDaterange = null;

                            singleton.filterStatus = null;
                            singleton.filterStatusID = null;

                            singleton.filterClientname = null;
                            singleton.filterClientnameID = null;

                            singleton.filterCompanyname = null;
                            singleton.filterCompanynameID = null;

                            singleton.filterBranchname = null;
                            singleton.filterBranchnameID = null;

                            singleton.filterDaterangeType = null;
                            singleton.filterDaterangeTypeID = null;

                            singleton.filterNextFollowUp = null;
                            singleton.filterNextFollowUpID = null;

                            singleton.filterMonth = null;
                            singleton.filterYear = null;
                            singleton.filterUserID = null;

                            singleton.filterEnable = false;
                            Navigator.pop(context, true);
                          },
                          child: Text("Clear All")),
                    ),
                  ])
                ],
              )
            : Custom_AppBar(
                title: "Filter", isGreen: false, isNav: true, actions: null),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    singleton.permissionList
                                .contains("activity-company-filter") ==
                            true
                        ? Column(
                            children: [
                              Title_Style(Title: "Employees", isStatus: false),
                              dropDownField3(
                                hintT: 'Choose Employee',
                                context,
                                value: singleton.filterCompanyname,
                                listValue: widget.filter?.executives,
                                onChanged: (String? newValue) {
                                  Executives? item = widget.filter?.executives!
                                      .firstWhere(
                                          (item) => item.name == newValue);
                                  singleton.filterUserID = "${item?.id ?? 0}";
                                },
                              ),
                            ],
                          )
                        : Container(),
                    //COMPANY NAME
                    singleton.permissionList
                                .contains("activity-company-filter") ==
                            true
                        ? Column(
                            children: [
                              Title_Style(
                                  Title: "Select Month", isStatus: false),
                              dropDownField(
                                hintT: 'Choose Month',
                                context,
                                value: monthNames[0],
                                listValue: monthNames,
                                onChanged: (String? newValue) {
                                  singleton.filterMonth =
                                      newValue == monthNames[0]
                                          ? monthNumbers[0]
                                          : newValue == monthNames[1]
                                              ? monthNumbers[1]
                                              : null;
                                },
                              ),
                            ],
                          )
                        : Container(),

                    singleton.permissionList.contains("stock-branch-filter") ==
                            true
                        ? Column(
                            children: [
                              //BRANCH NAME
                              Title_Style(
                                  Title: "Select Year", isStatus: false),
                              dropDownField(
                                hintT: 'Choose Year',
                                context,
                                value: year,
                                listValue: [year],
                                onChanged: (String? newValue) {
                                  setState(() {
                                    singleton.filterBranchname = newValue ?? "";
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
                    CommonElevatedButton(context, "Filter", () async {
                      if (singleton.filterMonth != null ||
                          singleton.filterYear != null ||
                          singleton.filterUserID != null) {
                        singleton.filterEnable = true;
                      }
                      Navigator.pop(context, true);
                    }),

                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
