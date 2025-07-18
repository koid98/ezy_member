import 'dart:convert';

import 'package:ezy_member/globals.dart';
import 'package:ezy_member/pages/login_screen.dart';
import 'package:ezy_member/pages/main_screen.dart';
import 'package:ezy_member/theme/mycolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _visible = false;
  bool isValid = true;
  bool isAuth = false;

  @override
  void initState() {
    super.initState();
    checkVersion();
    _navigateToLogin();
  }

  void _navigateToLogin() async{
    setState(() {
      _visible = true;
    });

    await Future.delayed(const Duration(milliseconds: 2500),(){});
    if(isValid == true){
      getMemberLogIn();
    }else if(isValid == false){
      Navigator.of(context).pushReplacement(_loginRoute());
    }
  }

  checkVersion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http
        .get(Uri.parse('http://$hostServer.ezymember.com.my/api/$company_id/checkVersion/$version'), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    });
    if(response.statusCode == 200){

    } else if(response.statusCode == 401){
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: const Text(
                  'New Version Detected'
              ),
              content: const Text(
                  'Please update to new version'
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    child: const Text(
                        'OKAY'
                    )
                )
              ],
            );
          }
      );
    }
  }

  getMemberLogIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? member = (prefs.getString('member') ?? "");
    String? bearer = prefs.getString('bearer');

    //Return String
    if(member.isEmpty){
      Navigator.of(context).pushReplacement(_loginRoute());
    } else {
      final member1 = jsonDecode(member);
      setState(() {
        user_id = member1['id'].toString();
        memberName = member1['name'].toString();
        memberID = member1['code'].toString();
        memberEmail = member1['email'].toString();
        bearerToken = bearer.toString();
      });
      final response = await http
          .get(Uri.parse('http://$hostServer.ezymember.com.my/api/$company_id/preventMultipleLogin/$user_id'), headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': "Bearer $token",
      });
      var body = json.decode(response.body);
      if(token == body['token']){
        Navigator.of(context).pushReplacement(_checkKeepLogIn());
        if(body['date_of_birth'] == null){
          showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context){
                return SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    padding: MediaQuery.of(context).viewInsets,
                    color: Colors.white,
                    child: Center(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                            child: Text(
                              "Attention".tr,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Text(
                              "Please access to profile page to update rest personal information, Thank you!".tr,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
          );
        }else{
          matchVoucherSpecial();
        }
      } else if(token != body['token']){
        Navigator.of(context).pushReplacement(_loginRoute());
      }
    }
  }

  matchVoucherSpecial() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? token = localStorage.getString('token');
    final response = await http
        .get(Uri.parse('http://$hostServer.ezymember.com.my/api/$company_id/matchVoucherSpecial/$user_id'), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    });
    var body = json.decode(response.body);

    if(response.statusCode == 200){
      Navigator.of(context).pushReplacement(_checkKeepLogIn());
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(20.0)),
              //this right here
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.38,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: const Image(
                            image: AssetImage('assets/happybirthday.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text(
                            "You have received birthday voucher.".tr
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context, false),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ColorConstants.mySecondaryColor
                            ),
                            child: Text(
                              "Got It".tr,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
    } else {
      Navigator.of(context).pushReplacement(_checkKeepLogIn());
    }
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
                color: ColorConstants.myPrimaryColor,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: const Image(
                image: AssetImage('assets/e_logo.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
          Center(
            child: AnimatedOpacity(
              opacity: _visible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 1500),
              child: const SizedBox(
                height: 250,
                width: 250,
                child: Image(
                  image: AssetImage('assets/laozihao-logo.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const Positioned(
            bottom: 20,
            right: 0,
            left: 0,
            child: Material(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Powered By : EzyOrder',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Route _checkKeepLogIn() {
    return PageRouteBuilder(
      pageBuilder: (context, animation,
          secondaryAnimation) => const MainScreen(),
      transitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
          ) =>
          FadeTransition(
            opacity: animation,
            child: child,
          ),

    );
  }

  Route _loginRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation,
          secondaryAnimation) => const LoginScreen(),
      transitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
          ) =>
          FadeTransition(
            opacity: animation,
            child: child,
          ),

    );
  }
}
