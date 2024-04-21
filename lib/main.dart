import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortune/Src/Home_Dash_Board_Ui/Home_DashBoard_Screen.dart';
import 'package:fortune/utilits/Landing.dart';
import 'Src/Login_Ui/Login_Screen.dart';
import 'Src/Marketing_Form_Ui/Marketing_Form_Screen.dart';
import 'Src/Marketing_Form_Ui/Marketing_List_Screen.dart';
import 'Src/Service_Form_Ui/Service_Form_Screen.dart';
import 'Src/Service_Form_Ui/Service_List_Screen.dart';
import 'Src/Service_Form_Ui/Service_Detail_Screen.dart';
import 'Src/Service_History_List_Ui/Service_Status_List_Screen.dart';


void main() {
  runApp(ProviderScope(child: const MyApp()) );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes:
      {
        "/": (context) => Landing(),
        "/login": (context) => Login_Screen(),
        "/home": (context) => Home_DashBoard_Screen(),
      },
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      onGenerateRoute: (value){
        return MaterialPageRoute(builder: (context)=>Login_Screen());
      },
      home:  Login_Screen(),
    );
  }
}
