import 'package:flutter/material.dart';
import 'package:fortune/Common_Widgets/Common_Button.dart';
import 'package:fortune/Common_Widgets/Custom_App_Bar.dart';
import 'package:fortune/Common_Widgets/Text_Form_Field.dart';
import 'package:fortune/Common_Widgets/Common_List.dart';
import 'package:fortune/utilits/Common_Colors.dart';
import 'package:fortune/utilits/Text_Style.dart';
import 'package:fortune/Src/Service_Form_Ui/Service_Form_Screen.dart';
import 'package:fortune/Src/Service_Form_Ui/Service_Detail_Screen.dart';


class Service_List_Screen extends StatefulWidget {
  const Service_List_Screen({super.key});

  @override
  State<Service_List_Screen> createState() => _Service_List_ScreenState();
}

class _Service_List_ScreenState extends State<Service_List_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     floatingActionButton:
     Floating_Button(context,onTap: (){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Service_Form_Screen()));
    },floatT: "Add Service"),
        backgroundColor: white5,
        appBar: Custom_AppBar(title: "Service List", actions: null, isGreen: false, isNav: true),
        body: SingleChildScrollView(
          child:  Padding(
            padding: const EdgeInsets.only(left: 20,right: 20,bottom: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20,),
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  child:_Service_List(context) ,
                ),

              ],
            ),
          ) ,
        )

    );
  }
}

Widget _Service_List(context){
  return ListView.builder(
    itemCount: 10,
    shrinkWrap: true,
    scrollDirection: Axis.vertical,
    physics: const NeverScrollableScrollPhysics(),
    itemBuilder: (BuildContext context, int index){
      return Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Service_Detail_Screen()));
          },
          child: Service_List(context,isTag:"Completed"),
        ),
      );
    },
  );
}
