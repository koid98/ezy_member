import 'dart:convert';

import 'package:ezy_member/controller/connections.dart';
import 'package:ezy_member/globals.dart';
import 'package:ezy_member/pages/login_screen.dart';
import 'package:ezy_member/theme/mycolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController emailController = TextEditingController();
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
                  color: ColorConstants.myPrimaryColor
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
                color: ColorConstants.myPrimaryColor,
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
        const SizedBox(
          height: 20,
        ),
        Text(
          "Enter the email associated with your account and we will send an email with the reset password link.".tr,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black,

          ),
        ),
        const SizedBox(height: 20,),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            boxShadow:[
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 9,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Text(
                    "Forget Password".tr,
                    style: const TextStyle(
                      fontSize: 20,
                      color: ColorConstants.myTextColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10, bottom: 20),
                  child: TextField(
                    controller: emailController,
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
                        Icons.email,
                        color: ColorConstants.mySecondaryColor,
                      ),
                      labelText: "Email Address".tr,),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 25.0),
                  child: SizedBox(
                    width: width * 0.7,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 10,
                        backgroundColor: ColorConstants.myPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        padding: const EdgeInsets.all(10),
                      ),
                      onPressed: () {
                        isLoading ? null : forgetPassword();
                      },
                      child: Text(
                        isLoading ? "submitting...".tr : 'Submit Now'.tr,
                        style: const TextStyle(
                            fontSize: 20, color: ColorConstants.myTextColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(
                "Back".tr,
                style: const TextStyle(
                  fontSize: 18, color: Colors.lightBlueAccent, decoration: TextDecoration.underline,),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> forgetPassword() async{
    if (emailController.text.isEmpty) {
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

    setState(() {
      isLoading = true;
    });

    var data = {
      'email': emailController.text
    };

    var res = await Network().postData(data, '/$company_id/forgetpassword');
    var body = json.decode(res.body);

    if (res.statusCode == 200) {

      Navigator.of(context).pushReplacement(_forgetPasswordRoute());
      final _snackBar = SnackBar(
        content: Text(
          "Reset Password link is sent to your email.".tr,
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
    } else if (res.statusCode == 406) {
      final _snackBar = SnackBar(
        content: Text(
          "Email not found!".tr,
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

Route _forgetPasswordRoute() {
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
