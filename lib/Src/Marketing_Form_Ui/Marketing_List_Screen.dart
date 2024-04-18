import 'package:flutter/material.dart';
import 'package:fortune/Common_Widgets/Common_Button.dart';
import 'package:fortune/Common_Widgets/Custom_App_Bar.dart';
import 'package:fortune/Common_Widgets/Text_Form_Field.dart';
import 'package:fortune/Common_Widgets/Common_List.dart';
import 'package:fortune/Common_Widgets/Common_Button.dart';
import 'package:fortune/utilits/Common_Colors.dart';
import 'package:fortune/utilits/Text_Style.dart';
import 'package:fortune/Src/Marketing_Form_Ui/Marketing_Form_Screen.dart';


class Marketing_List_Screen extends StatefulWidget {
  const Marketing_List_Screen({super.key});

  @override
  State<Marketing_List_Screen> createState() => _Marketing_List_ScreenState();
}

class _Marketing_List_ScreenState extends State<Marketing_List_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Floating_Button(context,onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Marketing_Form_Screen()));
      },floatT: "Add Marketing"),
      backgroundColor: white5,
      appBar: Custom_AppBar(title: "Marketing List", actions: null, isGreen: false, isNav: true),
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
                child:_Marketing_List() ,
              ),

            ],
          ),
        ) ,
      )

    );
  }
}

Widget _Marketing_List(){
  return ListView.builder(
    itemCount: 10,
    shrinkWrap: true,
    scrollDirection: Axis.vertical,
    physics: const NeverScrollableScrollPhysics(),
    itemBuilder: (BuildContext context, int index){
      return Padding(
          padding: const EdgeInsets.only(bottom: 0),
        child: Marketing_List(context,isTag:"Hot"),
      );
    },
  );
}
