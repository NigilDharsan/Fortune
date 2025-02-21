import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortune/Common_Widgets/Common_Button.dart';
import 'package:fortune/Common_Widgets/Custom_App_Bar.dart';
import 'package:fortune/Common_Widgets/Text_Form_Field.dart';
import 'package:fortune/Model/ServiceListModel.dart';
import 'package:fortune/Model/ServiceModel.dart';
import 'package:fortune/utilits/ApiProvider.dart';
import 'package:fortune/utilits/Generic.dart';
import 'package:fortune/utilits/Text_Style.dart';

class FilterSparesScreen extends ConsumerStatefulWidget {
  Filter? filter;

  FilterSparesScreen({super.key, required this.filter});

  @override
  ConsumerState<FilterSparesScreen> createState() => _FilterSparesScreenState();
}

class _FilterSparesScreenState extends ConsumerState<FilterSparesScreen> {
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

  SingleTon singleton = SingleTon();
  final GlobalKey<FormFieldState> _formKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    final _MarketingData = ref.watch(marketingDataProvider);

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
            child: _MarketingData.when(
          data: (data) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      // singleton.permissionList.contains("lead-employee-filter") ==
                      //         true
                      //     ?
                      Column(
                        children: [
                          Title_Style(
                              Title: 'Select Sales Rep', isStatus: false),
                          dropDownField3(
                            context,
                            hintT: "Service Rep",
                            value: singleton.filterSalesrep,
                            listValue:
                                data?.data?.executives?.toSet().toList() ?? [],
                            onChanged: (String? newValue) {
                              singleton.filterSalesrep = newValue ?? "";

                              Executives? item = data?.data?.executives!
                                  .firstWhere((item) => item.name == newValue);
                              singleton.filterSalesrepID = "${item?.id ?? 0}";
                            },
                          ),
                        ],
                      ),
                      // : Container(),
                      //CLIENT NAME
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
            );
          },
          error: (Object error, StackTrace stackTrace) {
            return Center(child: Text("Connection closed, Please try again!"));
          },
          loading: () => Center(child: CircularProgressIndicator()),
        )));
  }
}
