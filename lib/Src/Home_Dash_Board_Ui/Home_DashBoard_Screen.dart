import 'package:flutter/material.dart';
import 'package:fortune/Common_Widgets/Custom_App_Bar.dart';
import 'package:fortune/Src/Login_Ui/Login_Screen.dart';
import 'package:fortune/Src/Marketing_Form_Ui/Marketing_Form_Screen.dart';
import 'package:fortune/Src/Marketing_Form_Ui/Marketing_List_Screen.dart';
import 'package:fortune/Src/Service_Form_Ui/Service_Form_Screen.dart';
import 'package:fortune/Src/Service_Form_Ui/Service_List_Screen.dart';
import 'package:fortune/utilits/Common_Colors.dart';
import 'package:fortune/utilits/Text_Style.dart';



class Home_DashBoard_Screen extends StatefulWidget {
  const Home_DashBoard_Screen({super.key});

  @override
  State<Home_DashBoard_Screen> createState() => _Home_DashBoard_ScreenState();
}

class _Home_DashBoard_ScreenState extends State<Home_DashBoard_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Custom_AppBar(title: "Home Dash Board",
          actions: [
            PopupMenuButton(
                surfaceTintColor: white1,
                icon: Icon(Icons.person_2_rounded,color: white1,),
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                      child: InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Login_Screen()));
                          },
                          child: Text(
                            'Log Out',
                            style: refferalCountT,
                          ))),
                  // PopupMenuItem(child: Text('Download',style: refferalCountT,)),
                ]),
          ], isGreen: true, isNav: false),
      backgroundColor: white5,
      body: Padding(
        padding: const EdgeInsets.only(left: 0,right: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Marketing_List_Screen()));
                  },
                  child:  _CountCard(countT: "12",cardName: "Marketing",isWhite: true,color: red1),
                ),

                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Service_List_Screen()));
                  },
                  child: _CountCard(countT: "12",cardName: "Service",isWhite: true,color:blue1 ),
                ),

              ],
            ),


          ],
        ),
      ),
    );
  }

  Widget _CountCard({required String countT,required String cardName,required bool isWhite,required Color? color}){
    return Container(
      width: MediaQuery.sizeOf(context).width/2.5,
     decoration: BoxDecoration(
       borderRadius: BorderRadius.circular(5),
       color: color,
     ),
      child:Padding(
        padding: EdgeInsets.only(left: 15,right: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 10,),
            Text(countT,style: isWhite == true?WBlack1:TBlack1,),
            const SizedBox(height: 8,),
            Text(cardName,style: isWhite == true?WcompanyDetailT:companyDetailT,),
            const SizedBox(height: 8,),
            Container(
                color: Colors.transparent,
                child: Padding(
                  padding: EdgeInsets.only(top: 10,bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("More info",style: isWhite == true?WjobHeadingT:jobHeadingT,),
                      const SizedBox(width: 5,),
                      Icon(Icons.arrow_circle_right,color: isWhite == true?Colors.white:Colors.black,size: 18,)
                    ],
                  ),
                )

            ),
          ],
        ),
      ),
    );
  }
}
