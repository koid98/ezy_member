import 'dart:convert';

import 'package:ezy_member/controller/connections.dart';
import 'package:ezy_member/globals.dart';
import 'package:ezy_member/models/referralProgram.dart';
import 'package:ezy_member/pages/login_screen.dart';
import 'package:ezy_member/theme/mycolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ReferralProgramScreen extends StatefulWidget {
  const ReferralProgramScreen({super.key});

  @override
  State<ReferralProgramScreen> createState() => _ReferralProgramScreenState();
}

class _ReferralProgramScreenState extends State<ReferralProgramScreen> {
  TextEditingController generateCodeController = TextEditingController();
  TextEditingController codeController = TextEditingController();

  late ReferralProgram code;
  bool isEmpty = true;

  @override
  void initState() {
    super.initState();
    getToken();
    getReferralCode();
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

  getReferralCode() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? token = localStorage.getString('token');
    final response = await http
        .get(Uri.parse('http://$hostServer.ezymember.com.my/api/$company_id/getReferralCode/$memberID/$bearerToken'), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    });

    if (response.statusCode == 200) {
      setState(() {
        code = ReferralProgram.fromJson(jsonDecode(response.body));
        isEmpty = false;
      });
    } else {
      throw Exception('Failed to update data.');
    }
  }

  Future<void> GenerateCode() async {
    var res = await Network().getData('/$company_id/generateCode/$memberID/$bearerToken');
    var body = json.decode(res.body);

    if (res.statusCode == 200) {
      final _snackBar = SnackBar(
        content: Text(
          "Generate Referral Code Successfully!".tr,
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
      setState(() {
        getReferralCode();
      });
    } else if (res.statusCode == 406){
      final _snackBar = SnackBar(
        content: Text(
          "Referral Code can generate only one time".tr,
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
  }

  Future<void> useReferralCode() async {
    if (generateCodeController.text.isEmpty) {
      final _snackBar = SnackBar(
        content: Text(
          "Please provide referral code".tr,
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

    var data = {
      'generate_code': generateCodeController.text,
    };
    var res = await Network().postData(data, '/$company_id/useReferralCode/$memberID/$bearerToken');
    var body = json.decode(res.body);

    if (res.statusCode == 200) {
      final _snackBar = SnackBar(
        content: Text(
          "Use Referral Code Successfully!".tr,
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
      setState(() {
        getReferralCode();
      });
    } else if (res.statusCode == 403) {
      final _snackBar = SnackBar(
        content: Text(
          "Referral Code is invalid!".tr,
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
    } else if (res.statusCode == 401) {
      final _snackBar = SnackBar(
        content: Text(
          "Cannot be use own referral code".tr,
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
    } else if (res.statusCode == 402) {
      final _snackBar = SnackBar(
        content: Text(
          "This account already use referral code".tr,
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
    } else if(res.statusCode == 400){
      final _snackBar = SnackBar(
        content: Text(
          "Unauthorized".tr,
          style: const TextStyle(
            fontSize: 15,
            color: ColorConstants.myTextColor,
          ),
        ),
        backgroundColor: Colors.redAccent,
      );
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(_snackBar);
    }
  }

  void _showSnackBar() {
    final snack = SnackBar(content: Text("Text copied".tr), duration: const Duration(seconds: 2));
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
        child: Container(
          height: height * 0.900,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 15, left: 10, right: 10),
                  child: Column(
                    children: [
                      Container(
                        width: width * 0.7,
                        height: width * 0.4,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/referral_program.jpg'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Text(
                        "Refer a friends".tr,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Share referral code with friends to get points.".tr,
                            style: const TextStyle(
                                fontSize: 15
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      // Container(
                      //   width: MediaQuery.of(context).size.width * 0.7,
                      //   child: TextField(
                      //     enabled: false,
                      //     controller: codeController,
                      //     decoration: InputDecoration(
                      //       contentPadding: const EdgeInsets.only(top: 2, bottom: 2, left: 5, right: 5),
                      //       border: OutlineInputBorder(
                      //         borderRadius: BorderRadius.circular(5.0)
                      //       ),
                      //       focusedBorder: OutlineInputBorder(
                      //         borderRadius: BorderRadius.circular(5.0),
                      //         borderSide: const BorderSide(
                      //           color: Colors.grey
                      //         )
                      //       ),
                      //       suffixIcon: InkWell(
                      //         onTap: () async {
                      //           ClipboardData data = ClipboardData(text: code.generate_code.toString());
                      //           await Clipboard.setData(data);
                      //           _showSnackBar();
                      //         },
                      //         child: const Icon(Icons.content_copy),
                      //       )
                      //     ),
                      //   ),
                      // ),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          decoration: BoxDecoration(
                              color: Colors.blueGrey[50],
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(color: Colors.grey)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Align(
                                    alignment: Alignment.topCenter,
                                    child: isEmpty
                                        ? const SizedBox(
                                      height: 30,
                                      child: Text(
                                          ''
                                      ),
                                    ) : Text(
                                      code.generate_code.toString(),
                                      //controller: generateCodeController,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold
                                      ),
                                    )
                                ),
                              ),
                              IconButton(
                                  onPressed: () async {
                                    ClipboardData data = ClipboardData(text: code.generate_code.toString());
                                    await Clipboard.setData(data);
                                    _showSnackBar();
                                  },
                                  icon: const Icon(Icons.content_copy)
                              )
                            ],
                          )
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorConstants.myPrimaryColor,
                          ),
                          onPressed: (){
                            GenerateCode();
                          },
                          child: Text("Generate".tr)
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: ColorConstants.myPrimaryColor.withOpacity(0.4),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Column(
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Text(
                                "Enter who Refer you".tr,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                  "Use Referral Code to get points".tr
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                width: width * 0.7,
                                child: TextFormField(
                                  controller: generateCodeController,
                                  decoration: InputDecoration(
                                    icon: const Icon(Icons.group_add),
                                    labelText: "Referral Code".tr,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorConstants.myPrimaryColor,
                                  ),
                                  onPressed: (){
                                    useReferralCode();
                                  },
                                  child: Text("Submit".tr)
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
