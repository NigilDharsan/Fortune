import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortune/Common_Widgets/Common_Button.dart';
import 'package:fortune/Common_Widgets/Custom_App_Bar.dart';
import 'package:fortune/Common_Widgets/Text_Form_Field.dart';
import 'package:fortune/Common_Widgets/Image_Path.dart';
import 'package:fortune/utilits/Common_Colors.dart';
import 'package:fortune/utilits/Text_Style.dart';

class Service_Detail_Screen extends StatefulWidget {
  const Service_Detail_Screen({super.key});

  @override
  State<Service_Detail_Screen> createState() => _Service_Detail_ScreenState();
}

class _Service_Detail_ScreenState extends State<Service_Detail_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white5,
      appBar: Custom_AppBar(title: 'Service Detail Screen', actions: null,
          isGreen: false, isNav: true),
      body: Padding(
        padding: EdgeInsets.only(left: 20,right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //CLIENT DETAIL
            Title_Style(Title: 'Contact Details', isStatus: false),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.black12,width: 2),
              color: Colors.white
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 10,right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 15,),
                  //CLIENT NAME
                  _Sub_Heading(subHeadingT: "Client Name",contentT: "Jhon"),
                  //CLINET NUMBER
                  _Sub_Heading(subHeadingT: "Client Number",contentT: "9095379095"),
                  _Sub_Heading(subHeadingT: "Client Address",contentT: "11, Aathiparasakthi Nagar 5th Street, Tiruppalai"),
                  const SizedBox(height: 5,),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20,),
          Container(
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.black12,width: 2),
              color: Colors.white
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 10,right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15,),
                  //CLIENT NAME
                  Text(
                    'Status Note : ',
                    style: cardDetailT,
                  ),
                  Container(
                    width: MediaQuery.sizeOf(context).width/1.5,
                    child: Text('The service still under working and wait for payment',style: phoneHT,maxLines: 2,),
                  ),
                  const SizedBox(height: 10,),

                  //DOC
                  Text(
                    'Spare Used List : ',
                    style: cardDetailT,
                  ),
                  PdfContainer(),
                  const SizedBox(height: 10,),

                  //DOC
                  Text(
                    'Assigned to : ',
                    style: cardDetailT,
                  ),
                  Container(
                    width: MediaQuery.sizeOf(context).width/1.5,
                    child: Text('Arun, Gokul, Nivas',style: phoneHT,maxLines: 2,),
                  ),

                  const SizedBox(height: 15,),
                ],
              ),
            ),
          ),
          ],
        ),
      )

    );
  }
  Widget _Sub_Heading({required String subHeadingT,required String contentT}){
    return Padding(
        padding: EdgeInsets.only(bottom: 10),
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${subHeadingT} : ',
            style: cardDetailT,
          ),
          Container(
            width: MediaQuery.sizeOf(context).width/2,
            child: Text(
              contentT,
              style: DateT,maxLines: 2,
            ),
          ),

        ],
      ),
    );
  }
  //PDF SECTION
  Widget PdfContainer(){
    return Container(
      height: 75,
      margin: EdgeInsets.only(top: 25,bottom: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: white2
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10,right: 15),
            child: ImgPathSvg("pdf.svg"),
          ),
          Container(
              width: MediaQuery.of(context).size.width/2,
              child: Text("Spare List",style: pdfT,overflow: TextOverflow.ellipsis,maxLines: 2,)),
        ],
      ),
    );
  }
}

