import 'dart:convert';

import 'package:ezy_member/controller/connections.dart';
import 'package:ezy_member/globals.dart';
import 'package:ezy_member/pages/login_screen.dart';
import 'package:ezy_member/theme/mycolor.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var newPasswordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  bool sec = true;
  bool sec2 = true;
  bool sec3 = true;
  bool isLoading = false;
  var visable = const Icon(
    Icons.visibility,
    color: ColorConstants.mySecondaryColor,
  );
  var visableoff = const Icon(
    Icons.visibility_off,
    color: ColorConstants.mySecondaryColor,
  );

  @override
  void initState() {
    super.initState();
    getToken();
  }

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http
        .get(Uri.parse('http://$hostServer.ezymember.com.my/api/$company_id/preventMultipleLogin/$user_id'), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    });
    var body = json.decode(response.body);
    if(token == body['token']){
      print('true');
    } else {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Multiple Login Decteted".tr),
            content: Text("Detected that another device is logged in to this account and will be logged out soon".tr),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  SharedPreferences preferences = await SharedPreferences.getInstance();
                  await preferences.clear();
                  Navigator.pushAndRemoveUntil(
                      context, MaterialPageRoute(
                      builder: (BuildContext context) => const LoginScreen()), (route) => false);
                }, child: Text("Okay"),
              )
            ],
          )
      );
    }
  }

  Future<void> changePassword() async{
    if (passwordController.text.isEmpty) {
      final _snackBar = SnackBar(
        content: Text(
          "Please provide your current password".tr,
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

    if (newPasswordController.text.isEmpty) {
      final _snackBar = SnackBar(
        content: Text(
          "Please provide your new password".tr,
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

    if (confirmPasswordController.text.isEmpty) {
      final _snackBar = SnackBar(
        content: Text(
          "Please provide your confirm password".tr,
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

    if (newPasswordController.text != confirmPasswordController.text) {
      final _snackBar = SnackBar(
        content: Text(
          "New Password and Confirm Password is not match".tr,
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
      'email' : emailController.text,
      'password': passwordController.text,
      'new_password': newPasswordController.text
    };

    var res = await Network().postData(data, '/$company_id/changepassword');
    var body = json.decode(res.body);

    if (res.statusCode == 200) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', json.encode(body['token']));
      final _snackBar = SnackBar(
        content: Text(
          "Change Password Successfully! Please Login Again".tr,
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

      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.clear();

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const LoginScreen()), (Route<dynamic> route) => false);
    } else if (res.statusCode == 401) {
      final _snackBar = SnackBar(
        content: Text(
          "Current Password is incorrect!".tr,
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
    } else if (res.statusCode == 406) {
      final _snackBar = SnackBar(
        content: Text(
          "New Password and confirm password is not match!".tr,
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

  @override
  Widget build(BuildContext context) {
    emailController.text = memberEmail;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: SizedBox(
          height: logoSize,
          child: Image(
            image: AssetImage('assets/$logoName'),
            fit: BoxFit.contain,
          ),
        ),
        centerTitle: true,
        backgroundColor: ColorConstants.myPrimaryColor,
        // gradient: const LinearGradient(
        //     begin: Alignment.bottomLeft,
        //     end: Alignment.topRight,
        //     colors: [
        //       ColorConstants.myPrimaryColor,
        //       ColorConstants.mySecondaryColor,
        //       ColorConstants.mySecondaryColor,
        //     ]),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20.0, left: 20, right: 20),
          child: Container(
            child: Column(
              children: [
                TextField(
                  enabled: false,
                  controller: emailController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                        Icons.email,
                        color: ColorConstants.mySecondaryColor
                    ),
                    contentPadding: const EdgeInsets.only(
                        top: 5, bottom: 5, left: 10, right: 10
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                            color: Colors.grey
                        )
                    ),
                    hintText: "Email Address".tr,
                    hintStyle: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                const SizedBox(height: 15,),
                TextField(
                  controller: passwordController,
                  obscureText: sec,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                        Icons.vpn_key,
                        color: ColorConstants.mySecondaryColor
                    ),
                    contentPadding: const EdgeInsets.only(
                        top: 5, bottom: 5, left: 10, right: 10
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                            color: Colors.grey
                        )
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          sec = !sec;
                        });
                      },
                      icon: sec ? visableoff : visable,
                    ),
                    hintText: "Current Password".tr,
                    hintStyle: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                const SizedBox(height: 15,),
                TextField(
                  controller: newPasswordController,
                  obscureText: sec2,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                        Icons.vpn_key,
                        color: ColorConstants.mySecondaryColor
                    ),
                    contentPadding: const EdgeInsets.only(
                        top: 5, bottom: 5, left: 10, right: 10
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                            color: Colors.grey
                        )
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          sec2 = !sec2;
                        });
                      },
                      icon: sec2 ? visableoff : visable,
                    ),
                    hintText: "New Password".tr,
                    hintStyle: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                const SizedBox(height: 15,),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: sec3,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                        Icons.vpn_key,
                        color: ColorConstants.mySecondaryColor
                    ),
                    contentPadding: const EdgeInsets.only(
                        top: 5, bottom: 5, left: 10, right: 10
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                            color: Colors.grey
                        )
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          sec3 = !sec3;
                        });
                      },
                      icon: sec3 ? visableoff : visable,
                    ),
                    hintText: "Confirm Password".tr,
                    hintStyle: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                const SizedBox(height: 15,),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstants.myPrimaryColor,
                  ),
                  icon: const Icon(
                    Icons.change_circle_outlined,
                    color: Colors.white,
                  ),
                  label: Text(
                    isLoading ? "Changing...".tr : "Change Password".tr,
                  ),
                  onPressed: (){
                    isLoading ? null : changePassword();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
