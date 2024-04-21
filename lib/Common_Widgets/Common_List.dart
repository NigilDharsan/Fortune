import 'package:flutter/material.dart';
import 'package:fortune/Model/MarketingListModel.dart';
import 'package:fortune/Model/ServiceHistoryModel.dart';
import 'package:fortune/Model/ServiceListModel.dart';
import 'package:fortune/Src/Service_Form_Ui/Service_Form_Edit_Screen.dart';
import 'package:fortune/Src/Service_Form_Ui/Service_Form_Screen.dart';
import 'package:fortune/utilits/Common_Colors.dart';
import 'package:fortune/utilits/Text_Style.dart';

//Transaction List
Widget Service_List(context,
    {required ServicesData data,
    required String isTag,
    required bool isHistory}) {
  Color? containerColor;
  TextStyle? style;
  switch (isTag) {
    case "processing":
      containerColor = orange2;
      style = red;
      break;
    case "Completed":
      containerColor = blue2;
      style = blue;
      break;
    case "pending":
      containerColor = blue5;
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
                                          Service_Form_Edit_Screen(
                                              service_id:
                                                  "${data.serviceId ?? 0}")));
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

Widget Service_HistoryList(context,
    {required ServicesData1 data,
    required String isTag,
    required bool isHistory}) {
  Color? containerColor;
  TextStyle? style;
  switch (isTag) {
    case "processing":
      containerColor = orange2;
      style = red;
      break;
    case "Completed":
      containerColor = blue2;
      style = blue;
      break;
    case "pending":
      containerColor = blue5;
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

//MARKETING LIST
Widget Marketing_List(context,
    {required MarketingListData data, required String isTag}) {
  Color? containerColor;
  TextStyle? style;
  switch (isTag) {
    case "Hot":
      containerColor = orange2;
      style = red;
      break;
    case "completed":
      containerColor = blue2;
      style = blue;
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
          //USER NAME
          Container(
              margin: EdgeInsets.only(
                top: 15,
              ),
              alignment: Alignment.topLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Client Name : ',
                    style: cardDetailT,
                  ),
                  Container(
                    width: MediaQuery.sizeOf(context).width / 3,
                    child: Text(
                      data.clientName ?? "",
                      style: DateT,
                      maxLines: 2,
                    ),
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
          //PREVIOUS FOLLOWED DATE
          Row(
            children: [
              Text(
                'Previous Followed on : ',
                style: cardDetailT,
              ),
              Text(
                data.date ?? "",
                style: DateT,
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'Next Follow Up Date :  ',
                style: cardDetailT,
              ),
              Text(
                data.nextFollowupDate ?? "",
                style: DateT,
              ),
            ],
          ),

          //REPORTED BY
          Row(
            children: [
              Text(
                'Reported By : ',
                style: cardDetailT,
              ),
              Text(
                '${data.marketingExecutives?.map((item) => item.name).join(', ')}',
                style: phoneHT,
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    ),
  );
}
