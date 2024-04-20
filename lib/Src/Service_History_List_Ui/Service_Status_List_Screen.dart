import 'package:flutter/material.dart';
import 'package:fortune/Common_Widgets/Common_List.dart';
import 'package:fortune/Common_Widgets/Custom_App_Bar.dart';
import 'package:fortune/Src/Service_Form_Ui/Service_Detail_Screen.dart';
import 'package:fortune/utilits/Common_Colors.dart';

class Service_History_List_Screen extends StatefulWidget {
  const Service_History_List_Screen({super.key});

  @override
  State<Service_History_List_Screen> createState() => _Service_History_List_ScreenState();
}

class _Service_History_List_ScreenState extends State<Service_History_List_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white5,
      appBar: Custom_AppBar(title: 'Service History', actions: [], isGreen: false, isNav: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20,right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20,bottom: 30),
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  child:_Service_List(context) ,
                ),
              ),
            ],
          ),
        ),
      ),
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
        child: Service_List(context,isTag:"Completed", isHistory: true),
      );
    },
  );
}