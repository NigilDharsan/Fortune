import 'package:flutter/material.dart';
import 'package:fortune/Common_Widgets/Common_Button.dart';
import 'package:fortune/Common_Widgets/Custom_App_Bar.dart';
import 'package:fortune/Common_Widgets/Text_Form_Field.dart';
import 'package:fortune/Model/ServiceListModel.dart';
import 'package:fortune/utilits/Generic.dart';
import 'package:fortune/utilits/Text_Style.dart';
import 'package:intl/intl.dart';

class FilterDailyStockScreen extends StatefulWidget {
  Filter? filter;

  FilterDailyStockScreen({super.key, required this.filter});

  @override
  State<FilterDailyStockScreen> createState() => _FilterDailyStockScreenState();
}

class _FilterDailyStockScreenState extends State<FilterDailyStockScreen> {
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

                    //COMPANY NAME
                    Title_Style(Title: "Company Name", isStatus: false),
                    dropDownField4(
                      hintT: 'Select Company',
                      context,
                      value: singleton.filterCompanyname,
                      listValue: widget.filter?.company,
                      onChanged: (String? newValue) {
                        singleton.filterCompanyname = newValue ?? "";
                        Company? item = widget.filter?.company!.firstWhere(
                            (item) => item.companyBranch == newValue);
                        singleton.filterCompanynameID =
                            "${item?.companyId ?? 0}";

                        setState(() {
                          filterBranch = widget.filter?.branch!
                              .where((data) => "${data.companyId}".contains(
                                  singleton.filterCompanynameID ?? ""))
                              .map((data) => data)
                              .toList();
                        });
                      },
                    ),

                    //COMPANY NAME
                    Title_Style(Title: "Branch Name", isStatus: false),
                    dropDownField6(
                      hintT: 'Select Branch',
                      context,
                      value: singleton.filterBranchname,
                      listValue: filterBranch,
                      onChanged: (String? newValue) {
                        singleton.filterBranchname = newValue ?? "";
                        Branch? item = filterBranch!
                            .firstWhere((item) => item.branchName == newValue);
                        singleton.filterBranchnameID = "${item.id ?? 0}";
                      },
                    ),

                    const SizedBox(
                      height: 30,
                    ),
                    //BUTTON
                    CommonElevatedButton(context, "Filter", () async {
                      if (singleton.filterBranchname != null ||
                          singleton.filterDaterange != null ||
                          singleton.filterCompanyname != null) {
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
