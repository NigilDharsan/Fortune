import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortune/Common_Widgets/Common_Button.dart';
import 'package:fortune/Common_Widgets/Image_Path.dart';
import 'package:fortune/Common_Widgets/Text_Form_Field.dart';
import 'package:fortune/Model/LoginModel.dart';
import 'package:fortune/Src/Home_Dash_Board_Ui/Home_DashBoard_Screen.dart';
import 'package:fortune/utilits/ApiService.dart';
import 'package:fortune/utilits/Common_Colors.dart';
import 'package:fortune/utilits/ConstantsApi.dart';
import 'package:fortune/utilits/Generic.dart';
import 'package:fortune/utilits/Loading_Overlay.dart';
import 'package:fortune/utilits/Text_Style.dart';

class Login_Screen extends ConsumerStatefulWidget {
  Login_Screen({super.key});

  @override
  ConsumerState<Login_Screen> createState() => _Login_ScreenState();
}

class _Login_ScreenState extends ConsumerState<Login_Screen> {
  TextEditingController _employeeId = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _password = "";
  String device_id = "";
  bool _obscurePassword = true;

  //PASSWORD VISIBILITY FUNCTION
  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _employeeId.text = "ananth@fortunepowerfastening.com";
    _passwordController.text = "password";
    _password = "password";
    getDeviceID();
  }

  getDeviceID() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.deviceInfo;
    final allInfo = deviceInfo.data;
    print('Running on ${allInfo.values.last}');

    device_id = allInfo.values.last; // e.g. "Moto G (4)"
  }

//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white1,
      appBar: AppBar(
        toolbarHeight: 5,
        backgroundColor: white1,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: _mainBody(),
          ),
        ),
      ),
    );
  }

  Widget _mainBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //REGISTER LOGO
        Container(
            alignment: Alignment.center,
            height: 250,
            width: 250,
            margin: EdgeInsets.only(top: 50),
            child: ImgPathPng('logo.jpeg')),
        Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 1.5,
            decoration: BoxDecoration(
              color: white2,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sign in to start your session",
                    style: logintxt,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //EMPLOYEE ID
                  textFormField2(
                      // isEnabled: false,
                      hintText: "Employee Id",
                      keyboardtype: TextInputType.name,
                      Controller: _employeeId,
                      inputFormatters: [
                        FilteringTextInputFormatter.singleLineFormatter
                      ],
                      onChanged: null,
                      validating: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a valid Employee Id';
                        } else if (value == null) {
                          return 'Please enter a valid Employee Id';
                        }
                        return null;
                      }),
                  const SizedBox(
                    height: 25,
                  ),
                  //PASSWORD
                  textFieldPassword(
                    Controller: _passwordController,
                    obscure: _obscurePassword,
                    onPressed: _togglePasswordVisibility,
                    hintText: "Password",
                    keyboardtype: TextInputType.text,
                    onChanged: (value) {
                      setState(() {
                        _password = value;
                      });
                    },
                    validating: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a password';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  //BUTTON
                  Container(
                    margin: EdgeInsets.only(left: 30, right: 30),
                    child: CommonElevatedButton(context, "Log In", () async {
                      if (_formKey.currentState!.validate()) {
                        LoadingOverlay.show(context);

                        final apiService = ApiService(ref.read(dioProvider));

                        var formData = FormData.fromMap({
                          "email": _employeeId.text,
                          "password": _password,
                          "device_id": device_id
                        });
                        final postResponse = await apiService.login<LoginModel>(
                            ConstantApi.loginUrl, formData);
                        await LoadingOverlay.hide();

                        if (postResponse.success == true) {
                          ShowToastMessage(postResponse.message ?? "");
                          accessToken(postResponse.data?.token ?? "");
                          UserId(postResponse.data?.name ?? "");
                          UserRole(postResponse.data?.role ?? "");

                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Home_DashBoard_Screen()));
                          String Boolvalue = "true";
                          Routes(Boolvalue);
                          print('ROUTES : ${Routes(Boolvalue)}');
                        } else {
                          ShowToastMessage(postResponse.message ?? "");
                        }
                      }
                    }),
                  )
                ],
              ),
            )),
      ],
    );
  }
}
