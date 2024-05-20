import 'package:flutter/material.dart';
import 'package:fortune/Common_Widgets/Common_Button.dart';
import 'package:fortune/Common_Widgets/Custom_App_Bar.dart';
import 'package:fortune/Common_Widgets/Text_Form_Field.dart';
import 'package:fortune/Model/ServiceListModel.dart';
import 'package:fortune/Model/ServiceModel.dart';
import 'package:fortune/utilits/Generic.dart';
import 'package:fortune/utilits/Text_Style.dart';
import 'package:intl/intl.dart';

class FilterServiceScreen extends StatefulWidget {
  Filter? filter;

  FilterServiceScreen({super.key, required this.filter});

  @override
  State<FilterServiceScreen> createState() => _FilterServiceScreenState();
}

class _FilterServiceScreenState extends State<FilterServiceScreen> {
  String? clientName;
  String? companyName;
  String? selectStatus;
  String? assignExecutive;

  bool isvalueUpdated = false;

  String? status;
  int? clientSelectedIndex;

  List<String> _selectState = [
    'completed',
    'pending',
    'processing',
    "cancelled"
  ];

  var dateRange = "";

  SingleTon singleton = SingleTon();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Custom_AppBar(
            title: "Filter", actions: null, isGreen: false, isNav: true),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    //CLIENT NAME
                    Title_Style(Title: 'Service Rep', isStatus: false),
                    dropDownField3(
                      context,
                      hintT: "Service Rep",
                      value: singleton.filterSalesrep,
                      listValue:
                          widget.filter?.executives?.toSet().toList() ?? [],
                      onChanged: (String? newValue) {
                        singleton.filterSalesrep = newValue ?? "";

                        Executives? item = widget.filter?.executives!
                            .firstWhere((item) => item.name == newValue);
                        singleton.filterSalesrepID = "${item?.companyId ?? 0}";
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
                    Title_Style(Title: "Status", isStatus: false),
                    dropDownField(
                      context,
                      hintT: 'Select Status',
                      value: selectStatus,
                      listValue: _selectState,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectStatus = newValue;
                          singleton.filterStatus = newValue ?? "";

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

                    //CLIENT NAME
                    Title_Style(Title: "Client Name", isStatus: false),
                    dropDownField5(
                      hintT: 'Select Client',
                      context,
                      value: singleton.filterClientname,
                      listValue: widget.filter?.clientDetails,
                      onChanged: (String? newValue) {
                        singleton.filterClientname = newValue ?? "";

                        ClientDetails? item = widget.filter?.clientDetails!
                            .firstWhere(
                                (item) => item.cusFirstName == newValue);
                        singleton.filterClientnameID = "${item?.clientId ?? 0}";
                      },
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
                        Company? item = widget.filter?.company!
                            .firstWhere((item) => item.name == newValue);
                        singleton.filterCompanynameID =
                            "${item?.companyId ?? 0}";
                      },
                    ),

                    const SizedBox(
                      height: 30,
                    ),
                    //BUTTON
                    CommonElevatedButton(context, "Filter", () async {
                      if (singleton.filterSalesrepID != null ||
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
