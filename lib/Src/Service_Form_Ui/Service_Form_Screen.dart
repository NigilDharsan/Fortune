import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortune/Common_Widgets/Common_Button.dart';
import 'package:fortune/Common_Widgets/Custom_App_Bar.dart';
import 'package:fortune/Common_Widgets/Image_Path.dart';
import 'package:fortune/Common_Widgets/Text_Form_Field.dart';
import 'package:fortune/utilits/Common_Colors.dart';
import 'package:fortune/utilits/Text_Style.dart';
import 'dart:io';

import 'package:intl/intl.dart';



class Service_Form_Screen extends ConsumerStatefulWidget {
  const Service_Form_Screen({super.key});

  @override
  ConsumerState<Service_Form_Screen> createState() => _Service_Form_ScreenState();
}

class _Service_Form_ScreenState extends ConsumerState<Service_Form_Screen> {
  TextEditingController _StatusNote = TextEditingController();
  TextEditingController _ClientName = TextEditingController();
  TextEditingController _ContactNumber = TextEditingController();
  TextEditingController _ClientAddress = TextEditingController();


  List<File> _selectedFiles = [];

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _selectedFiles.addAll(result.files.map((file) => File(file.path!)).toList());
      });
    }
  }
  void _removeImage(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });
  }


  List<String> _SelectClient = ['Bosh', 'Pricol', 'Tessolv'];
  List<String> _CompanyName = ['Zoho', 'wipro', 'Advance'];
  List<String> _AssignExecutive = ['Arun', 'Madhesh', 'Naveen',"Nivas"];

  String? Degree;
  String? clientName;
  String? companyName;
  String? assignExecutive;
  String? status;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white5,
      appBar: Custom_AppBar(title: "Service Form",
          actions: null, isGreen: false, isNav: true),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20,right: 20),
              child: Column(
                children: [
                  //CLIENT NAME
                  Title_Style(Title: 'Select Client', isStatus: true),
                  dropDownField(
                    context,
                    hintT:"",
                    value: clientName,
                    listValue: _SelectClient,
                    onChanged: (String? newValue) {
                      setState(() {
                        clientName = newValue;
                      });
                    },
                  ),
                  //COMPANY NAME
                  Title_Style(Title: "Company Name", isStatus: true),
                  dropDownField(
                    hintT:'',
                    context,
                    value: companyName,
                    listValue: _CompanyName,
                    onChanged: (String? newValue) {
                      setState(() {
                        companyName = newValue;
                      });
                    },
                  ),
                  //CLIENT NAME
                  Title_Style(Title: 'Client Name', isStatus: true),
                  textFormField(
                      hintText: "Client Name",
                      keyboardtype:  TextInputType.text,
                      Controller: _ClientName,
                      validating: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter ${'Client Name'}";
                        }
                        if (value == null) {
                          return "Please Enter ${'Client Name'}";
                        }
                        return null;
                      }
                  ),
                  //CLIENT CONTACT NUMBER
                  Title_Style(Title: 'Client Mobile Number', isStatus: true),
                  textFormField(
                    hintText: 'Mobile Number',
                    keyboardtype: TextInputType.phone,
                    inputFormatters: [LengthLimitingTextInputFormatter(10)],
                    Controller: _ContactNumber,
                    validating: (value) {
                      if (value!.isEmpty) {
                        return "Please enter a Contact Number";
                      } else if (!RegExp(r"^[0-9]{10}$").hasMatch(value)) {
                        return "Please enter a valid 10-digit Contact Number";
                      }
                      return null;
                    },
                    onChanged: null,
                  ),
                  //CLIENT ADDRESS
                  Title_Style(Title: "Client Address", isStatus: true),
                  textfieldDescription(
                      Controller: _ClientAddress,
                      hintText: 'Enter Address',
                      validating: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter ${'Address'}";
                        }
                        if (value == null) {
                          return "Please Enter ${'Address'}";
                        }
                        return null;
                      }
                  ),

                  //STATUS NOTE
                  Title_Style(Title: 'Status Note', isStatus: true),
                  textfieldDescription(
                      Controller: _StatusNote,
                      hintText: 'Enter Status Note',
                      validating: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter ${'Note'}";
                        }
                        if (value == null) {
                          return "Please Enter ${'Note'}";
                        }
                        return null;
                      }
                  ),

                  Title_Style(Title: 'Spare Used List', isStatus: true),
                  Padding(
          padding: const EdgeInsets.only(left: 100,right: 100,bottom: 15),
          child: CommonElevatedButton(context, "Pick PDF", _pickFiles),
        ),
        Container(
          height: _selectedFiles.length * 90,
          child: ListView.builder(
            itemCount: _selectedFiles.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PDFViewerScreen(pdfPath: _selectedFiles[index].path),
                    ),
                  );
                },
                child: Container(
                  height: 65,
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: white1
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10,right: 15),
                        child: Container(height:40,width:40,child: Center(child: ImgPathSvg("pdf.svg"))),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width/2,
                          child: Text(_selectedFiles[index].path.split('/').last,style: pdfT,overflow: TextOverflow.ellipsis,maxLines: 2,)),
                      Spacer(),
                      InkWell(
                        onTap: (){
                          _removeImage(index);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Icon(Icons.cancel_outlined,color: grey1,),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),


          //ASSIGN EXECUTIVE
          Title_Style(Title: "Assign Executive", isStatus: true),
          dropDownField(
            context,
            hintT:'',
            value: assignExecutive,
            listValue: _AssignExecutive,
            onChanged: (String? newValue) {
              setState(() {
                assignExecutive = newValue;
              });
            },
          ),

          const SizedBox(height: 30,),
          //BUTTON
          CommonElevatedButton(context, "Submit", () { }),

          const SizedBox(height: 50,),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}


class PDFViewerScreen extends StatelessWidget {
  final String pdfPath;

  PDFViewerScreen({required this.pdfPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: PDFView(
        filePath: pdfPath,
        onPageChanged: (int? page, int? total) {
          if (page != null && total != null) {
            print('page change: $page/$total');
          }
        },
        onViewCreated: (PDFViewController pdfViewController) {},
        onPageError: (page, error) {
          print('error: $page: $error');
        },
      ),
    );

  }

}