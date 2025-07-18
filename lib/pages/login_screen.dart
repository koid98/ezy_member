import 'dart:convert';

import 'package:ezy_member/controller/connections.dart';
import 'package:ezy_member/globals.dart';
import 'package:ezy_member/localization_service.dart';
import 'package:ezy_member/models/member.dart';
import 'package:ezy_member/pages/forget_password_screen.dart';
import 'package:ezy_member/pages/main_screen.dart';
import 'package:ezy_member/pages/registration_screen.dart';
import 'package:ezy_member/theme/mycolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var loginController = TextEditingController();
  var passwordController = TextEditingController();

  late Box box1;

  bool langOption = false;
  bool isChecked = false;
  bool sec = true;
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
    createBox();
  }

  void createBox() async{
    box1 = await Hive.openBox('logindata');
    getdata();
  }

  void getdata() async{
    if(box1.get('email')!=null){
      loginController.text = box1.get('email');
      isChecked = true;
      setState(() {

      });
    }
    if(box1.get('password')!=null){
      passwordController.text = box1.get('password');
      isChecked = true;
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Wrap(
                      children: [
                        buildLogin(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 10,
            child: SizedBox(
              height: 50,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    langOption = true;
                  });
                },
                child: Text(
                  "MyLanguage".tr,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          langOption
              ? changeLanguegeWidget()
              : const SizedBox(
            height: 0,
          ),
        ],
      ),
    );
  }

  Widget buildLogin() {
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
        // Padding(
        //     padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        //     child: Column(
        //       children: [
        //         Padding(
        //           padding: const EdgeInsets.only(top: 10),
        //           child: Text(
        //             "Hello".tr,
        //             style: const TextStyle(
        //                 fontSize: 40
        //             ),
        //           ),
        //         ),
        //         Text("Sign in your Account".tr),
        //         Padding(
        //           padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10, bottom: 10),
        //           child: TextFormField(
        //             controller: loginController,
        //             keyboardType: TextInputType.text,
        //             style: const TextStyle(color: Colors.black),
        //             decoration: InputDecoration(
        //               enabledBorder: const UnderlineInputBorder(
        //                 borderSide: BorderSide(color: Colors.grey),
        //               ),
        //               focusedBorder: const UnderlineInputBorder(
        //                   borderSide: BorderSide(color: Colors.cyan)
        //               ),
        //               contentPadding: const EdgeInsets.only(top: 14, bottom: 10),
        //               prefixIcon: const Icon(
        //                 Icons.mail,
        //                 color: ColorConstants.mySecondaryColor,
        //               ),
        //               labelText: "Email or Phone Number".tr,
        //             ),
        //           ),
        //         ),
        //         Padding(
        //           padding: const EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 10),
        //           child: TextField(
        //             controller: passwordController,
        //             obscureText: sec,
        //             style: const TextStyle(color: Colors.black),
        //             decoration: InputDecoration(
        //               enabledBorder: const UnderlineInputBorder(
        //                 borderSide: BorderSide(color: Colors.grey),
        //               ),
        //               focusedBorder: const UnderlineInputBorder(
        //                   borderSide: BorderSide(color: Colors.cyan)
        //               ),
        //               suffixIcon: IconButton(
        //                 onPressed: () {
        //                   setState(() {
        //                     sec = !sec;
        //                   });
        //                 },
        //                 icon: sec ? visableoff : visable,
        //               ),
        //               border: InputBorder.none,
        //               contentPadding: const EdgeInsets.only(top: 14, bottom: 10),
        //               prefixIcon: const Icon(
        //                 Icons.vpn_key,
        //                 color: ColorConstants.mySecondaryColor,
        //               ),
        //               labelText: "Password".tr,
        //             ),
        //           ),
        //         ),
        //         Padding(
        //           padding: const EdgeInsets.only(right: 10.0, top: 0, bottom: 0, left: 10),
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             children: [
        //               InkWell(
        //                 onTap: (){
        //                   isChecked = !isChecked;
        //                   setState(() {
        //                   });
        //                 },
        //                 child: Row(
        //                   children: [
        //                     Checkbox(
        //                       value: isChecked,
        //                       onChanged: (value){
        //                         isChecked = !isChecked;
        //                         setState(() {
        //                         });
        //                       },
        //                     ),
        //                     Text(
        //                       "Remember Me".tr,
        //                       style: const TextStyle(
        //                           color: Colors.black45
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //               GestureDetector(
        //                 onTap: () {
        //                   Navigator.of(context).push(_forgetPasswordRoute());
        //                 },
        //                 child: Text(
        //                   "Forgot Password?".tr,
        //                   style: const TextStyle(
        //                       color: Colors.lightBlueAccent,
        //                       fontSize: 13,
        //                       fontWeight: FontWeight.bold),
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //         // Padding(
        //         //   padding: const EdgeInsets.only(right: 10.0, top: 5, bottom: 10),
        //         //   child: Align(
        //         //     alignment: Alignment.centerRight,
        //         //     child: GestureDetector(
        //         //       onTap: () {
        //         //         Navigator.of(context).push(_forgetPasswordRoute());
        //         //       },
        //         //       child: Text(
        //         //         "Forgot Password?".tr,
        //         //         style: const TextStyle(
        //         //             color: Colors.lightBlueAccent,
        //         //             fontSize: 13,
        //         //             fontWeight: FontWeight.bold),
        //         //       ),
        //         //     ),
        //         //   ),
        //         // ),
        //         Padding(
        //           padding: const EdgeInsets.only(bottom: 20.0),
        //           child: SizedBox(
        //             width: width * 0.7,
        //             child: ElevatedButton(
        //               style: ElevatedButton.styleFrom(
        //                 elevation: 10,
        //                 shape: RoundedRectangleBorder(
        //                   borderRadius: BorderRadius.circular(40),
        //                 ),
        //                 primary: ColorConstants.mySecondaryColor,
        //                 padding: const EdgeInsets.all(10),
        //               ),
        //               onPressed: () {
        //                 checkLogin();
        //                 login();
        //               },
        //               child: Text(
        //                 "Login".tr,
        //                 style: const TextStyle(
        //                     fontSize: 20,
        //                     color: ColorConstants.myTextColor,
        //                     fontWeight: FontWeight.bold),
        //               ),
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            // border: Border.all(color: Color(0xFF1574ba))
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
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    "Hello".tr,
                    style: const TextStyle(
                        fontSize: 40
                    ),
                  ),
                ),
                Text("Sign in your Account".tr),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10, bottom: 10),
                  child: TextFormField(
                    controller: loginController,
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
                        Icons.mail,
                        color: ColorConstants.mySecondaryColor,
                      ),
                      labelText: "Email or Phone Number".tr,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 10),
                  child: TextField(
                    controller: passwordController,
                    obscureText: sec,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan)
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            sec = !sec;
                          });
                        },
                        icon: sec ? visableoff : visable,
                        color: ColorConstants.mySecondaryColor,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(top: 14, bottom: 10),
                      prefixIcon: const Icon(
                        Icons.vpn_key,
                        color: ColorConstants.mySecondaryColor,
                      ),
                      labelText: "Password".tr,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0, top: 0, bottom: 0, left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: (){
                          isChecked = !isChecked;
                          setState(() {
                          });
                        },
                        child: Row(
                          children: [
                            Checkbox(
                              value: isChecked,
                              onChanged: (value){
                                isChecked = !isChecked;
                                setState(() {
                                });
                              },
                            ),
                            Text(
                              "Remember Me".tr,
                              style: const TextStyle(
                                  color: Colors.black45
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(_forgetPasswordRoute());
                        },
                        child: Text(
                          "Forgot Password?".tr,
                          style: const TextStyle(
                              color: Colors.lightBlueAccent,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(right: 10.0, top: 5, bottom: 10),
                //   child: Align(
                //     alignment: Alignment.centerRight,
                //     child: GestureDetector(
                //       onTap: () {
                //         Navigator.of(context).push(_forgetPasswordRoute());
                //       },
                //       child: Text(
                //         "Forgot Password?".tr,
                //         style: const TextStyle(
                //             color: Colors.lightBlueAccent,
                //             fontSize: 13,
                //             fontWeight: FontWeight.bold),
                //       ),
                //     ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
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
                        checkLogin();
                        login();
                      },
                      child: Text(
                        "Login".tr,
                        style: const TextStyle(
                            fontSize: 20,
                            color: ColorConstants.myTextColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Dont have an account?".tr,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(_registerRoute());
                },
                child: Text(
                  'RegisterNow'.tr,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.lightBlueAccent,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
        /*const SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Text(
              'Powered By : EzyOrder',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),*/
      ],
    );
  }

  void login(){
    if(isChecked){
      box1.put('email', loginController.text);
      box1.put('password', passwordController.text);
    }
  }

  Future<void> checkLogin() async {
    if (loginController.text.isEmpty) {
      final _snackBar = SnackBar(
        content: Text(
          "Please provide your email or phone number".tr,
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

    if (passwordController.text.isEmpty) {
      final _snackBar = SnackBar(
        content: Text(
          'Please key in your password'.tr,
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

    Map data = {
      'email': loginController.text.trim(),
      'password': passwordController.text.trim()
    };

    try {
      var res = await Network().postData(data, '/auth/$company_id/login');
      var body = json.decode(res.body);
      // debugPrint(res.statusCode.toString());
      if (res.statusCode == 200) {
        print(res.body);
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('member', json.encode(body['member']));
        prefs.setString('token', body['access_token']);
        prefs.setString('bearer', body['bearer_token']);
        CurrentMember currentMember = CurrentMember.fromJson(body['member']);

        setState(() {
          user_id = currentMember.user_id.toString();
          memberName = currentMember.memberName;
          memberID = currentMember.memberID;
          memberEmail = currentMember.memberEmail;
          accessToken = body['access_token'].toString();
          bearerToken = body['bearer_token'].toString();
        });
        Navigator.of(context).pushReplacement(_loginRoute());

        if(body['member']['date_of_birth'] == null){
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
        }
        else if(body['member']['date_of_birth'] != null){
          if(body['result'] == '200'){
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
                                  child: Text(
                                    "Got It".tr,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorConstants.myPrimaryColor,
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
          }else{

          }
        }
      } else if (res.statusCode == 401) {
        final _snackBar = SnackBar(
          content: Text(
            'Invalid Login Credentials'.tr,
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
      } else if (res.statusCode == 422) {
        final _snackBar = SnackBar(
          content: Text(
            'Invalid Login Credentials'.tr,
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
            "Login Failed! Account has not been activated within the limited 7 days, So please execute forget password to ativate.".tr,
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
    } catch (e) {
      print(e);
    } finally {
      setState(() {});
    }

    //var passwordController = TextEditingController();
  }

  Widget changeLanguegeWidget() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          height: 260,
          width: 320,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  ColorConstants.mySecondaryColor,
                  ColorConstants.myPrimaryColor,
                ],
              ),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
            child: Material(
              color: Colors.transparent,
              child: Column(
                children: [
                  Flexible(
                    flex: 2,
                    child: Text(
                      'PreferredLang'.tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      LocalizationService().changeLocale('English');
                      setState(() {
                        langOption = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstants.myPrimaryColor,
                        fixedSize: const Size(300, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: const Text(
                      'English',
                      style: TextStyle(
                        color: ColorConstants.myTextColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      LocalizationService().changeLocale('Malay');
                      setState(() {
                        langOption = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstants.myPrimaryColor,
                        fixedSize: const Size(300, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: const Text(
                      'Bahasa Melayu',
                      style: TextStyle(
                        color: ColorConstants.myTextColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      LocalizationService().changeLocale('Chinese');
                      setState(() {
                        langOption = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstants.myPrimaryColor,
                        fixedSize: const Size(300, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: const Text(
                      '中文',
                      style: TextStyle(
                        color: ColorConstants.myTextColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Route _forgetPasswordRoute() {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
      const ForgetPasswordScreen(),
      transitionDuration: const Duration(milliseconds: 800),
      transitionsBuilder: (context, animation, secondaryAnimation, child){
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      }
  );
}

Route _registerRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
    const RegistrationScreen(),
    transitionDuration: const Duration(milliseconds: 800),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Route _loginRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const MainScreen(),
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
