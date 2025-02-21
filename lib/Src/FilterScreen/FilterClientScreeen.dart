import 'package:flutter/material.dart';
import 'package:fortune/Common_Widgets/Common_Button.dart';
import 'package:fortune/Common_Widgets/Custom_App_Bar.dart';
import 'package:fortune/Common_Widgets/Text_Form_Field.dart';
import 'package:fortune/Model/ServiceListModel.dart';
import 'package:fortune/utilits/Generic.dart';
import 'package:fortune/utilits/Text_Style.dart';

class FilterClientScreen extends StatefulWidget {
  Filter? filter;

  FilterClientScreen({super.key, required this.filter});

  @override
  State<FilterClientScreen> createState() => _FilterClientScreenState();
}

class _FilterClientScreenState extends State<FilterClientScreen> {
  bool isvalueUpdated = false;

  String? status;

  SingleTon singleton = SingleTon();
  var focus = FocusNode();
  var focus1 = FocusNode();

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
                    //COMPANY NAME
                    Title_Style(Title: 'Client Name', isStatus: false),
                    dropDownClientSearchField(
                      context,
                      listValue: widget.filter?.clients ?? [],
                      onChanged: ((x) {
                        focus.unfocus();

                        setState(() {
                          singleton.filterClientname = x.searchKey;
                        });
                      }),
                      focus: focus,
                      validator: (x) {
                        int index = widget.filter!.clients!
                            .indexWhere((st) => st.cusFirstName == x);

                        if (index == -1) {
                          return 'Please Choose Client';
                        }
                        return null;
                      },
                      hintText: 'Search Client name',
                      initValue: singleton.filterClientname ?? "",
                    ),

                    //COMPANY NAME
                    Title_Style(Title: 'Client Gst', isStatus: false),
                    dropDownClientGSTSearchField(
                      context,
                      listValue: widget.filter?.clients ?? [],
                      onChanged: ((x) {
                        focus1.unfocus();

                        setState(() {
                          singleton.filterClientname = x.searchKey;
                        });
                      }),
                      focus: focus1,
                      validator: (x) {
                        int index = widget.filter!.clients!
                            .indexWhere((st) => st.gstNo == x);

                        if (index == -1) {
                          return 'Please Choose Client GST No';
                        }
                        return null;
                      },
                      hintText: 'Search Client GST No',
                      initValue: '',
                    ),

                    const SizedBox(
                      height: 30,
                    ),
                    //BUTTON
                    CommonElevatedButton(context, "Filter", () async {
                      if (singleton.filterClientname != null ||
                          singleton.filterClientnameID != null) {
                        singleton.filterEnable = true;
                        Navigator.pop(context, true);
                      } else {
                        Navigator.pop(context, false);
                      }
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
