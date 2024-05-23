import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortune/Model/DailyActivitiesModel.dart';
import 'package:fortune/Model/MarketingHistoryModel.dart';
import 'package:fortune/Model/MarketingListModel.dart';
import 'package:fortune/Model/ServiceHistoryModel.dart';
import 'package:fortune/Model/ServiceListModel.dart';
import 'package:fortune/Model/StocksModel.dart';
import 'package:fortune/Src/Marketing_Form_Ui/Marketing_Form_Edit_Screen.dart';
import 'package:fortune/Src/Marketing_Form_Ui/Marketing_Form_Screen.dart';
import 'package:fortune/Src/Service_Form_Ui/Service_Form_Edit_Screen.dart';
import 'package:fortune/Src/Service_Form_Ui/Service_Form_Screen.dart';
import 'package:fortune/Src/StockActivity/AddDailyStockActivity.dart';
import 'package:fortune/Src/StockActivity/AddPhysicalStocks.dart';
import 'package:fortune/utilits/ApiProvider.dart';
import 'package:fortune/utilits/Common_Colors.dart';
import 'package:fortune/utilits/Generic.dart';
import 'package:fortune/utilits/Text_Style.dart';
import 'package:url_launcher/url_launcher.dart';

//Transaction List
Widget Service_List(context,
    {required ServicesData data,
    required String isTag,
    required bool isHistory,
    required WidgetRef ref}) {
  SingleTon singleton = SingleTon();

  Color? containerColor;
  TextStyle? style;
  switch (isTag) {
    case "processing":
      containerColor = orange2;
      style = red;
      break;
    case "completed":
      containerColor = green1;
      style = white;
      break;
    case "pending":
      containerColor = blue5;
      style = white;
      break;
    case "cancelled":
      containerColor = red1;
      style = white;
      break;
    default:
      containerColor = Colors.white;
      break;
  }
  return Container(
    // width: MediaQuery.of(context).size.width / 1.5,
    margin: EdgeInsets.only(
      bottom: 20,
    ),
    decoration:
        BoxDecoration(borderRadius: BorderRadius.circular(10), color: white1),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //USER NAME
              Container(
                  margin: EdgeInsets.only(top: 15, bottom: 10),
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      Text(
                        data.clientName ?? "",
                        style: cardDetailT,
                      ),
                      const Spacer(),
                      Container(
                          alignment: Alignment.topLeft,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: containerColor),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 5),
                            child: Text(
                              isTag,
                              style: style,
                            ),
                          )),
                    ],
                  )),
              //DATE
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Row(
                  children: [
                    Text(
                      data.date ?? "",
                      style: DateT,
                    ),
                    const Spacer(),
                    isHistory == true
                        ? Container()
                        : singleton.permissionList.contains("service-edit") ==
                                true
                            ? InkWell(
                                onTap: () {
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Service_Form_Edit_Screen(
                                                      service_id:
                                                          "${data.serviceId ?? 0}")))
                                      .then((value) {
                                    if (value == true) {
                                      var formData = FormData.fromMap({
                                        "executive_id": "",
                                        "client_id": "",
                                        "status_id": "",
                                        "daterange": ""
                                      });
                                      singleton.formData = formData;

                                      ref.refresh(serviceListProvider);
                                    }
                                  });
                                },
                                child: Container(
                                    height: 30,
                                    width: 30,
                                    child: Center(
                                        child: Icon(
                                      Icons.mode_edit,
                                      size: 25,
                                    ))),
                              )
                            : Container(),
                  ],
                ),
              ),
              //PHONE NUMBER
              Container(
                child: Text(
                  data.contactNo ?? "",
                  style: phoneHT,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Text(
                    data.statusNote ?? "",
                    style: phoneHT,
                    maxLines: 2,
                  ),
                ),
              ),
              //ADDRESS
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Text(
                    data.address ?? "",
                    style: phoneHT,
                    maxLines: 2,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Text(
                    'Service Rep: ${data.serviceExecutives?.map((item) => item.name).join(', ')}',
                    style: phoneHT,
                    maxLines: 2,
                  ),
                ),
              ),
              isHistory == true
                  ? SizedBox(
                      height: 5,
                    )
                  : SizedBox(
                      height: 15,
                    ),
            ],
          ),
        ),
        isHistory == true
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                  color: white3,
                ),
                height: 50,
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'View doc',
                      style: cardDetailT,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.arrow_forward),
                  ],
                )),
              )
            : Container(),
      ],
    ),
  );
}

Widget Service_HistoryList(
  context, {
  required ServicesData1 data,
  required String isTag,
  required bool isHistory,
}) {
  Color? containerColor;
  TextStyle? style;
  switch (isTag) {
    case "processing":
      containerColor = orange2;
      style = red;
      break;
    case "completed":
      containerColor = green1;
      style = white;
      break;
    case "pending":
      containerColor = blue5;
      style = white;
      break;
    case "cancelled":
      containerColor = red1;
      style = white;
      break;
    default:
      containerColor = Colors.white;
      break;
  }
  return Container(
    // width: MediaQuery.of(context).size.width / 1.5,
    margin: EdgeInsets.only(
      bottom: 20,
    ),
    decoration:
        BoxDecoration(borderRadius: BorderRadius.circular(10), color: white1),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //USER NAME
              Container(
                  margin: EdgeInsets.only(top: 15, bottom: 10),
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      Text(
                        data.clientName ?? "",
                        style: cardDetailT,
                      ),
                      const Spacer(),
                      Container(
                          alignment: Alignment.topLeft,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: containerColor),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 5),
                            child: Text(
                              isTag,
                              style: style,
                            ),
                          )),
                    ],
                  )),
              //DATE
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Row(
                  children: [
                    Text(
                      data.date ?? "",
                      style: DateT,
                    ),
                    const Spacer(),
                    isHistory == true
                        ? Container()
                        : InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Service_Form_Screen()));
                            },
                            child: Container(
                                height: 30,
                                width: 30,
                                child: Center(
                                    child: Icon(
                                  Icons.mode_edit,
                                  size: 25,
                                ))),
                          ),
                  ],
                ),
              ),
              //PHONE NUMBER
              Container(
                child: Text(
                  data.contactNo ?? "",
                  style: phoneHT,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Text(
                    data.statusNote ?? "",
                    style: phoneHT,
                    maxLines: 2,
                  ),
                ),
              ),
              //ADDRESS
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Text(
                    data.address ?? "",
                    style: phoneHT,
                    maxLines: 2,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Text(
                    'Service Rep: ${data.serviceExecutives?.map((item) => item.name).join(', ')}',
                    style: phoneHT,
                    maxLines: 2,
                  ),
                ),
              ),
              isHistory == true
                  ? SizedBox(
                      height: 5,
                    )
                  : SizedBox(
                      height: 15,
                    ),
            ],
          ),
        ),
        isHistory == true
            ? InkWell(
                onTap: () async {
                  String docurl = '${data.serviceDoc}';

                  if (docurl == "" || docurl == "null") {
                    ShowToastMessage("No Document Found!");
                  } else {
                    final Uri url = Uri.parse(docurl);

                    if (!await launchUrl(url)) {
                      ShowToastMessage("No Document Found!");
                    }
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                    color: white3,
                  ),
                  height: 50,
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      data.serviceDoc == null ||
                              data.serviceDoc == "" ||
                              data.serviceDoc == "null"
                          ? Text(
                              'No Documents',
                              style: cardDetailT,
                            )
                          : Text(
                              'View doc',
                              style: cardDetailT,
                            ),
                      const SizedBox(
                        width: 10,
                      ),
                      data.serviceDoc == null ||
                              data.serviceDoc == "" ||
                              data.serviceDoc == "null"
                          ? Container()
                          : Icon(Icons.arrow_forward),
                    ],
                  )),
                ),
              )
            : Container(),
      ],
    ),
  );
}

Widget Service_List_DashBoard(
  context, {
  required String data,
  required String isTag,
}) {
  Color? containerColor;
  TextStyle? style;
  switch (isTag) {
    case "processing":
      containerColor = orange2;
      style = red;
      break;
    case "completed":
      containerColor = green1;
      style = white;
      break;
    case "pending":
      containerColor = blue5;
      style = white;
      break;
    case "cancelled":
      containerColor = red1;
      style = white;
      break;
    default:
      containerColor = Colors.white;
      break;
  }
  return Container(
    width: MediaQuery.sizeOf(context).width / 1.8,
    decoration:
        BoxDecoration(borderRadius: BorderRadius.circular(10), color: white1),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //USER NAME
              Container(
                margin: EdgeInsets.only(top: 15, bottom: 10),
                alignment: Alignment.topLeft,
                child: Text(
                  data,
                  style: serviceHomeT,
                ),
              ),
              Container(
                  width: 120, //MediaQuery.sizeOf(context).width / 4,
                  alignment: Alignment.topLeft,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: containerColor),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 5, bottom: 5),
                    child: Center(
                      child: Text(
                        isTag,
                        style: style,
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ],
    ),
  );
}

//MARKETING LIST
Widget Marketing_List(context,
    {required MarketingListData data,
    required String isTag,
    required bool isHistory,
    required WidgetRef ref}) {
  SingleTon singleton = SingleTon();

  Color? containerColor;
  TextStyle? style;
  switch (isTag) {
    case "Hot":
      containerColor = orange2;
      style = red;
      break;
    case "completed":
      containerColor = green1;
      style = white;
      break;
    case "processing":
      containerColor = orange2;
      style = red;
      break;
    case "pending":
      containerColor = blue5;
      style = white;
      break;
    case "cancelled":
      containerColor = red1;
      style = white;
      break;
    default:
      containerColor = Colors.white;
      break;
  }
  return Container(
    // width: MediaQuery.of(context).size.width / 1.5,
    margin: EdgeInsets.only(
      bottom: 20,
    ),
    decoration:
        BoxDecoration(borderRadius: BorderRadius.circular(10), color: white1),
    child: Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 15,
          ),
          // isHistory == true
          //     ? Container()
          //     : Row(
          //         mainAxisAlignment: MainAxisAlignment.end,
          //         children: [
          //           InkWell(
          //             onTap: () {
          //               Navigator.push(
          //                   context,
          //                   MaterialPageRoute(
          //                       builder: (context) => Marketing_Form_Screen()));
          //             },
          //             child: Container(
          //                 height: 30,
          //                 width: 30,
          //                 child: Center(
          //                     child: Icon(
          //                   Icons.edit_rounded,
          //                 ))),
          //           ),
          //           const SizedBox(
          //             width: 15,
          //           ),
          //           InkWell(
          //             onTap: () {},
          //             child: Container(
          //                 height: 30,
          //                 width: 30,
          //                 child: Center(
          //                     child: Icon(
          //                   Icons.delete,
          //                 ))),
          //           ),
          //         ],
          //       ),
          isHistory == true
              ? Container()
              : const SizedBox(
                  height: 5,
                ),
          //USER NAME
          Container(
              alignment: Alignment.topLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Client Detail : ',
                    style: cardDetailT,
                  ),
                  const Spacer(),
                  singleton.permissionList.contains("lead-edit") == true
                      ? Container(
                          alignment: Alignment.topLeft,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: containerColor),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 5),
                            child: Text(
                              isTag,
                              style: style,
                            ),
                          ))
                      : Container(),
                ],
              )),
          Row(
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width / 3,
                child: Text(
                  data.clientName ?? "",
                  style: phoneHT,
                  maxLines: 2,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Marketing_Form_Edit_Screen(
                                  marketing_id: "${data.leadId ?? 0}")))
                      .then((value) {
                    if (value == true) {
                      var formData = FormData.fromMap({
                        "executive_id": "",
                        "client_id": "",
                        "status_id": "",
                        "daterange": "",
                        "page": 1
                      });
                      singleton.formData = formData;

                      ref.refresh(marketingListProvider);
                    }
                  });
                },
                child: Container(
                    height: 30,
                    width: 30,
                    child: Center(
                        child: Icon(
                      Icons.edit_rounded,
                    ))),
              )
            ],
          ),
          //detail
          Container(
              width: MediaQuery.sizeOf(context).width / 1.2,
              child: Text(
                "${data.address}",
                style: phoneHT,
                maxLines: 3,
              )),
          const SizedBox(
            height: 5,
          ),
          //PREVIOUS FOLLOWED DATE
          Text(
            'Previous Followed on : ',
            style: cardDetailT,
          ),

          Text(
            data.date ?? "",
            style: phoneHT,
          ),
          const SizedBox(
            height: 5,
          ),
          //NEXT FOLLOW DATE
          Text(
            'Next Follow Up Date :  ',
            style: cardDetailT,
          ),
          Text(
            data.nextFollowupDate ?? "",
            style: phoneHT,
          ),
          const SizedBox(
            width: 5,
          ),

          //REPORTED BY
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Reported By : ',
                style: cardDetailT,
              ),
              Flexible(
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  '${data.marketingExecutives?.map((item) => item.name).join(', ')}',
                  style: phoneHT,
                ),
              ),
            ],
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            'Plan on next : ',
            style: cardDetailT,
          ),
          Container(
              width: MediaQuery.sizeOf(context).width / 1.2,
              child: Text(
                "${data.planForNextMeet}",
                style: phoneHT,
                maxLines: 3,
              )),
          const SizedBox(
            width: 5,
          ),
          Text(
            'Status Note : ',
            style: cardDetailT,
          ),
          Container(
              width: MediaQuery.sizeOf(context).width / 1.2,
              child: Text(
                "${data.statusNote ?? ""}",
                style: phoneHT,
                maxLines: 3,
              )),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    ),
  );
}

Widget Marketing_History(
  context, {
  required HistoryData data,
  required String isTag,
  required bool isHistory,
}) {
  Color? containerColor;
  TextStyle? style;
  switch (isTag) {
    case "Hot":
      containerColor = orange2;
      style = red;
      break;
    case "processing":
      containerColor = orange2;
      style = red;
      break;
    case "completed":
      containerColor = green1;
      style = white;
      break;
    case "pending":
      containerColor = blue5;
      style = white;
      break;
    case "cancelled":
      containerColor = red1;
      style = white;
      break;
    default:
      containerColor = Colors.white;
      break;
  }
  return Container(
    // width: MediaQuery.of(context).size.width / 1.5,
    margin: EdgeInsets.only(
      bottom: 20,
    ),
    decoration:
        BoxDecoration(borderRadius: BorderRadius.circular(10), color: white1),
    child: Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 15,
          ),
          isHistory == true
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Marketing_Form_Screen()));
                      },
                      child: Container(
                          height: 30,
                          width: 30,
                          child: Center(
                              child: Icon(
                            Icons.edit_rounded,
                          ))),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                          height: 30,
                          width: 30,
                          child: Center(
                              child: Icon(
                            Icons.delete,
                          ))),
                    ),
                  ],
                ),
          isHistory == true
              ? Container()
              : const SizedBox(
                  height: 5,
                ),
          //USER NAME
          Container(
              alignment: Alignment.topLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Client Detail : ',
                    style: cardDetailT,
                  ),
                  const Spacer(),
                  Container(
                      alignment: Alignment.topLeft,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: containerColor),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                        child: Text(
                          isTag,
                          style: style,
                        ),
                      )),
                ],
              )),
          Container(
            width: MediaQuery.sizeOf(context).width / 3,
            child: Text(
              data.clientName ?? "",
              style: phoneHT,
              maxLines: 2,
            ),
          ),
          //detail
          Container(
              width: MediaQuery.sizeOf(context).width / 1.2,
              child: Text(
                "${data.address}",
                style: phoneHT,
                maxLines: 3,
              )),
          const SizedBox(
            height: 5,
          ),
          //PREVIOUS FOLLOWED DATE
          Text(
            'Previous Followed on : ',
            style: cardDetailT,
          ),

          Text(
            data.date ?? "",
            style: phoneHT,
          ),
          const SizedBox(
            height: 5,
          ),
          //NEXT FOLLOW DATE
          Text(
            'Next Follow Up Date :  ',
            style: cardDetailT,
          ),
          Text(
            data.nextFollowupDate ?? "",
            style: phoneHT,
          ),
          const SizedBox(
            width: 5,
          ),

          //REPORTED BY
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Reported By : ',
                style: cardDetailT,
              ),
              Flexible(
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  '${data.marketingExecutives?.map((item) => item.name).join(', ')}',
                  style: phoneHT,
                ),
              ),
            ],
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            'Plan on next : ',
            style: cardDetailT,
          ),
          Container(
              width: MediaQuery.sizeOf(context).width / 1.2,
              child: Text(
                "${data.planForNextMeet}",
                style: phoneHT,
                maxLines: 3,
              )),
          const SizedBox(
            width: 5,
          ),
          Text(
            'Status Note : ',
            style: cardDetailT,
          ),
          Container(
              width: MediaQuery.sizeOf(context).width / 1.2,
              child: Text(
                "${data.statusNote}",
                style: phoneHT,
                maxLines: 3,
              )),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    ),
  );
}

Widget ActivitiesList(context,
    {required ActivitiesData data,
    required bool isHistory,
    required WidgetRef ref}) {
  Color? containerColor;
  TextStyle? style;
  SingleTon singleton = SingleTon();

  return Container(
    // width: MediaQuery.of(context).size.width / 1.5,
    margin: EdgeInsets.only(
      bottom: 20,
    ),
    decoration:
        BoxDecoration(borderRadius: BorderRadius.circular(10), color: white1),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //USER NAME
              Container(
                  margin: EdgeInsets.only(top: 15, bottom: 10),
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      Text(
                        data.customer ?? "",
                        style: cardDetailT,
                      ),
                      const Spacer(),
                      singleton.permissionList.contains("activity-edit") == true
                          ? InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => InvoiceFormScreen(
                                              isEdit: true,
                                              activityId: "${data.id}",
                                            ))).then((value) {
                                  if (value == true) {
                                    ref.refresh(activityListProvider);
                                  }
                                });
                              },
                              child: Container(
                                  height: 30,
                                  width: 30,
                                  child: Center(
                                      child: Icon(
                                    Icons.mode_edit,
                                    size: 25,
                                  ))),
                            )
                          : Container(),
                    ],
                  )),
              //DATE
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Row(
                  children: [
                    Text(
                      "Date: ${data.date ?? ""}",
                      style: DateT,
                    ),
                  ],
                ),
              ),
              //PHONE NUMBER
              Container(
                child: Text(
                  "Invoice No: ${data.invoiceNo ?? ""}",
                  style: DateT,
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Text(
                    'Items Product(Quantity): ${data.items?.map((item) => "${item.productName} (${item.quantity})").join(', ')}',
                    style: DateT,
                  ),
                ),
              ),
              isHistory == true
                  ? SizedBox(
                      height: 5,
                    )
                  : SizedBox(
                      height: 15,
                    ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget StocksList(context,
    {required StocksData data,
    required bool isHistory,
    required WidgetRef ref}) {
  Color? containerColor;
  TextStyle? style;
  SingleTon singleton = SingleTon();

  return Container(
    // width: MediaQuery.of(context).size.width / 1.5,
    margin: EdgeInsets.only(
      bottom: 20,
    ),
    decoration:
        BoxDecoration(borderRadius: BorderRadius.circular(10), color: white1),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //USER NAME
              Container(
                  margin: EdgeInsets.only(top: 15, bottom: 10),
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          data.itemName ?? "",
                          style: cardDetailT,
                        ),
                      ),
                      // const Spacer(),
                      singleton.permissionList.contains("stock-edit") == true
                          ? InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AddPhysicalStockScreen(
                                              isEdit: true,
                                              stockId: "${data.id}",
                                            ))).then((value) {
                                  if (value == true) {
                                    ref.refresh(stocksListProvider);
                                  }
                                });
                              },
                              child: Container(
                                  height: 30,
                                  width: 30,
                                  child: Center(
                                      child: Icon(
                                    Icons.mode_edit,
                                    size: 25,
                                  ))),
                            )
                          : Container(),
                    ],
                  )),
              //DATE
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Row(
                  children: [
                    Text(
                      "Date: ${data.date ?? ""}",
                      style: DateT,
                    ),
                  ],
                ),
              ),
              //PHONE NUMBER
              Container(
                child: Text(
                  "Available Stocks: ${data.availableStock ?? ""}",
                  style: DateT,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
