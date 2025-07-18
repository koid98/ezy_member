import 'dart:convert';

import 'package:ezy_member/controller/connections.dart';
import 'package:ezy_member/globals.dart';
import 'package:ezy_member/pages/login_screen.dart';
import 'package:ezy_member/pages/show_password_screen.dart';
import 'package:ezy_member/theme/mycolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController phone_number1Controller = TextEditingController();
  bool value = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
                color: ColorConstants.LoginBackground
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: const Image(
                image: AssetImage('assets/header2.png'),
                fit: BoxFit.contain,
                color: ColorConstants.myPrimaryColor,
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.24,
              child: const Image(
                  image: AssetImage('assets/header.png'),
                  fit: BoxFit.contain,
                  color: ColorConstants.myPrimaryColor
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: Material(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Powered By : EzyOrder',
                    style: TextStyle(
                      fontSize: 12,
                      color: ColorConstants.myShadowColor.withOpacity(0.5),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: SingleChildScrollView(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Wrap(
                        children: [
                          _formWidget(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _formWidget() {
    double width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.35,
                child: const Image(
                  image: AssetImage('assets/laozihao-logo.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20,),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            // boxShadow:[
            //   BoxShadow(
            //     color: Colors.grey.withOpacity(0.3),
            //     spreadRadius: 5,
            //     blurRadius: 9,
            //     offset: const Offset(0, 2),
            //   ),
            // ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Create Account".tr,
                    style: const TextStyle(
                      fontSize: 30,
                      color: ColorConstants.myTextColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10, bottom: 5),
                  child: TextFormField(
                    controller: nameController,
                    keyboardType: TextInputType.text,
                    maxLength: 100,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      counterText: '',
                      focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan)
                      ),
                      contentPadding: const EdgeInsets.only(top: 14, bottom: 10),
                      prefixIcon: const Icon(
                        Icons.account_box,
                        color: ColorConstants.mySecondaryColor,
                      ),
                      labelText: "Username".tr,),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 5),
                  child: TextFormField(
                    controller: mailController,
                    keyboardType: TextInputType.text,
                    maxLength: 80,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      counterText: '',
                      focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan)
                      ),
                      contentPadding: const EdgeInsets.only(top: 14, bottom: 10),
                      prefixIcon: const Icon(
                        Icons.mail,
                        color: ColorConstants.mySecondaryColor,
                      ),
                      labelText: "Email Address".tr,),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 5),
                  child: TextFormField(
                    controller: phone_number1Controller,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan)
                      ),
                      contentPadding: const EdgeInsets.only(top: 14, bottom: 10),
                      prefixIcon: const Icon(
                        Icons.phone,
                        color: ColorConstants.mySecondaryColor,
                      ),
                      labelText: "Phone Number".tr,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: SizedBox(
                    width: width * 0.7,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 10, backgroundColor: ColorConstants.myPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        padding: const EdgeInsets.all(10),
                      ),
                      onPressed: () {
                        isLoading ? null : registration();
                      },
                      child: Text(
                        isLoading ? "Creating...".tr : 'Create Account'.tr,
                        style: const TextStyle(
                            fontSize: 18, color: ColorConstants.myTextColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "I've read and agree with the ".tr ,
                            style: const TextStyle(fontSize: 13, color: Colors.black,),
                          ),
                          GestureDetector(
                            onTap: () {

                            },
                            child: Text(
                              "T&C".tr,
                              style: const TextStyle(fontSize: 13, color: Colors.blue,decoration: TextDecoration.underline,),
                            ),
                          ),
                        ],
                      ), //Text
                      //Checkbox
                    ], //<Widget>[]
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:  [
              Text(
                "Already have an account?".tr,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Login Now".tr,
                  style: const TextStyle(
                    fontSize: 15, color: Colors.lightBlueAccent, decoration: TextDecoration.underline,),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> registration() async{
    if (nameController.text.isEmpty) {
      final _snackBar = SnackBar(
        content: Text(
          "Please provide your name".tr,
          style: const TextStyle(
            fontSize: 15,
            color: ColorConstants.myTextColor,
          ),
        ),
        backgroundColor: ColorConstants.myScarletRed,
      );
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(_snackBar);

      return;
    }

    if (mailController.text.isEmpty) {
      final _snackBar = SnackBar(
        content: Text(
          "Please provide your email address".tr,
          style: const TextStyle(
            fontSize: 15,
            color: ColorConstants.myTextColor,
          ),
        ),
        backgroundColor: ColorConstants.myScarletRed,
      );
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(_snackBar);

      return;
    }

    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    if(!regex.hasMatch(mailController.text)) {
      final _snackBar = SnackBar(
        content: Text(
          "Please provide valid email address".tr,
          style: const TextStyle(
            fontSize: 15,
            color: ColorConstants.myTextColor,
          ),
        ),
        backgroundColor: ColorConstants.myScarletRed,
      );
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(_snackBar);

      return;
    }

    if (phone_number1Controller.text.isEmpty) {
      final _snackBar = SnackBar(
        content: Text(
          "Please provide your phone number".tr,
          style: const TextStyle(
            fontSize: 15,
            color: ColorConstants.myTextColor,
          ),
        ),
        backgroundColor: ColorConstants.myScarletRed,
      );
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(_snackBar);

      return;
    }

    // String phoneValidate = r'(^(\+?6?01)[0|1|2|3|4|6|7|8|9]\-*[0-9]{7,8}$)';
    // RegExp regExp = RegExp(phoneValidate);
    // if(!regExp.hasMatch(phone_number1Controller.text)){
    //   final _snackBar = SnackBar(
    //     content: Text(
    //       "Please provide valid phone number".tr,
    //       style: const TextStyle(
    //         fontSize: 15,
    //         color: ColorConstants.myTextColor,
    //       ),
    //     ),
    //     backgroundColor: ColorConstants.myScarletRed,
    //   );
    //   ScaffoldMessenger.of(context)
    //     ..removeCurrentSnackBar()
    //     ..showSnackBar(_snackBar);
    //
    //   return;
    // }

    setState(() {
      isLoading = true;
    });

    var data = {
      'name': nameController.text,
      'email': mailController.text,
      'phone_number1': phone_number1Controller.text
    };

    var res = await Network().postData(data, '/auth/$company_id/newRegister');
    var body = json.decode(res.body);

    if (res.statusCode == 200) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', json.encode(body['token']));
      Navigator.of(context).pushReplacement(_registerRoute());
      final _snackBar = SnackBar(
        content: Text(
          "Setting Password link is sent to your email.".tr,
          style: const TextStyle(
            fontSize: 15,
            color: ColorConstants.myTextColor,
          ),
        ),
        backgroundColor: ColorConstants.SuccessMessage,
      );
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(_snackBar);
      Navigator.of(context).push(_showPasswordRoute());
    } else if (res.statusCode == 406) {
      final _snackBar = SnackBar(
        content: Text(
          "Your Register Information is already exists!".tr,
          style: const TextStyle(
            fontSize: 15,
            color: ColorConstants.myTextColor,
          ),
        ),
        backgroundColor: ColorConstants.myScarletRed,
      );
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(_snackBar);
    }
    setState(() {
      isLoading = false;
    });
  }
}

Route _showPasswordRoute(){
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const ShowPasswordScreen(),
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        Align(
          child: SizeTransition(
            sizeFactor: animation,
            child: child,
          ),
        ),
  );
}

Route _registerRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        Align(
          child: SizeTransition(
            sizeFactor: animation,
            child: child,
          ),
        ),
  );
}
