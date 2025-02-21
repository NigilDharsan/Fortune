import 'package:flutter/material.dart';
import 'package:fortune/Common_Widgets/Common_Button.dart';
import 'package:fortune/Common_Widgets/Custom_App_Bar.dart';
import 'package:fortune/Common_Widgets/Text_Form_Field.dart';
import 'package:fortune/Model/ServiceListModel.dart';
import 'package:fortune/Model/ServiceModel.dart';
import 'package:fortune/utilits/Generic.dart';
import 'package:fortune/utilits/Text_Style.dart';
import 'package:intl/intl.dart';

class FilterScreen extends StatefulWidget {
  Filter? filter;

  FilterScreen({super.key, required this.filter});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String? Degree;
  String? clientName;
  String? companyName;

  String? selectStatus;
  String? selectStatus_id;

  String? selectdaterangetype;
  String? selectdaterangetype_id;

  String? selectnextfollowup;
  String? selectnectfollowup_id;

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

  List<String> dateRangeType = ["Marketing Created", "Next Followup"];

  List<String> nextfollowup = ["Today", "Tomorrow"];

  SingleTon singleton = SingleTon();
  final GlobalKey<FormFieldState> _formKey = GlobalKey<FormFieldState>();

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
                    singleton.permissionList.contains("lead-employee-filter") ==
                            true
                        ? Column(
                            children: [
                              Title_Style(
                                  Title: 'Select Sales Rep', isStatus: false),
                              dropDownField3(
                                context,
                                hintT: "Service Rep",
                                value: singleton.filterSalesrep,
                                listValue: widget.filter?.executives
                                        ?.toSet()
                                        .toList() ??
                                    [],
                                onChanged: (String? newValue) {
                                  singleton.filterSalesrep = newValue ?? "";

                                  Executives? item = widget.filter?.executives!
                                      .firstWhere(
                                          (item) => item.name == newValue);
                                  singleton.filterSalesrepID =
                                      "${item?.id ?? 0}";
                                },
                              ),
                            ],
                          )
                        : Container(),
                    //CLIENT NAME

                    Title_Style(
                        Title: "Select Date range type", isStatus: false),
                    dropDownField(
                      context,
                      hintT: 'Select daterange type',
                      value: singleton.filterDaterangeType,
                      listValue: dateRangeType,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectdaterangetype = newValue;
                          singleton.filterDaterangeType = newValue;
                          singleton.filterDaterangeTypeID =
                              selectdaterangetype == "Marketing Created"
                                  ? "1"
                                  : selectdaterangetype == "Next Followup"
                                      ? "2"
                                      : "";
                        });
                      },
                    ),
                    // DATE RANGE
                    Title_Style(Title: "Date range", isStatus: false),

                    InkWell(
                      onTap: () async {
                        final DateTimeRange? picked = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2200),
                          initialDateRange: DateTimeRange(
                            start: DateTime.now(),
                            end: DateTime.now(),
                          ),
                        );

                        if (picked != null) {
                          setState(() {
                            // fromDate = picked.start;
                            // toDate = picked.end;
                            String formatdate =
                                DateFormat("dd/MM/yyyy").format(picked.start);

                            String todate =
                                DateFormat("dd/MM/yyyy").format(picked.end);

                            setState(() {
                              singleton.filterDaterange =
                                  "${formatdate}-${todate}";
                            });
                          });
                        }
                      },
                      child: Container(
                        height: 44,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Row(
                            children: [
                              Text(singleton.filterDaterange ?? ""),
                              Spacer(),
                              Icon(Icons.date_range)
                            ],
                          ),
                        ),
                      ),
                    ),
                    Title_Style(Title: "Select Status", isStatus: false),
                    dropDownField(
                      context,
                      hintT: 'Select Status',
                      value: singleton.filterStatus,
                      listValue: _selectState,
                      onChanged: (String? newValue) {
                        setState(() {
                          singleton.filterStatus = newValue;
                          selectStatus = newValue;

                          singleton.filterStatusID = selectStatus == "completed"
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

                    Title_Style(Title: "Next Follow up", isStatus: false),
                    dropDownField(
                      context,
                      hintT: 'Select next follow up',
                      value: selectnextfollowup,
                      listValue: nextfollowup,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectnextfollowup = newValue;

                          singleton.filterNextFollowUp =
                              selectnextfollowup == "Today"
                                  ? "1"
                                  : selectnextfollowup == "Tomorrow"
                                      ? "2"
                                      : "";
                        });
                      },
                    ),

                    singleton.permissionList.contains("lead-company-filter") ==
                            true
                        ? Column(
                            children: [
                              Title_Style(
                                  Title: "Company Name", isStatus: false),
                              dropDownField4(
                                hintT: 'Select Company',
                                context,
                                value: singleton.filterCompanyname,
                                listValue: widget.filter?.company,
                                onChanged: (String? newValue) {
                                  singleton.filterCompanyname = newValue ?? "";
                                  Company? item = widget.filter?.company!
                                      .firstWhere(
                                          (item) => item.name == newValue);
                                  singleton.filterCompanynameID =
                                      "${item?.companyId ?? 0}";

                                  setState(() {
                                    singleton.filterBranchname = null;
                                    singleton.filterBranchnameID = null;

                                    filterBranch = widget.filter?.branch!
                                        .where((data) => "${data.companyId}"
                                            .contains(
                                                singleton.filterCompanynameID ??
                                                    ""))
                                        .map((data) => data)
                                        .toList();
                                  });
                                },
                              ),
                            ],
                          )
                        : Container(),
                    //COMPANY NAME

                    singleton.permissionList.contains("lead-branch-filter") ==
                            true
                        ? Column(
                            children: [
                              //BRANCH NAME
                              Title_Style(
                                  Title: "Branch Name", isStatus: false),
                              dropDownField6(
                                hintT: 'Select Branch',
                                context,
                                value: singleton.filterBranchname,
                                listValue: filterBranch,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    singleton.filterBranchname = newValue ?? "";
                                    Branch? item = filterBranch!.firstWhere(
                                        (item) => item.branchName == newValue);
                                    singleton.filterBranchnameID =
                                        "${item.id ?? 0}";
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
                      if (singleton.filterSalesrepID != null ||
                          singleton.filterDaterangeType != null ||
                          singleton.filterDaterange != null ||
                          singleton.filterStatusID != null ||
                          singleton.filterClientnameID != null ||
                          singleton.filterCompanynameID != null) {
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
