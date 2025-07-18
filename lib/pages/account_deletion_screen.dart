import 'dart:convert';

import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:ezy_member/globals.dart';
import 'package:ezy_member/pages/login_screen.dart';
import 'package:ezy_member/theme/mycolor.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AccountDeletionScreen extends StatefulWidget {
  const AccountDeletionScreen({super.key});

  @override
  State<AccountDeletionScreen> createState() => _AccountDeletionScreenState();
}

class _AccountDeletionScreenState extends State<AccountDeletionScreen> {
  bool isLoading = false;

  @override
  void initState(){
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

  @override
  Widget build(BuildContext context) {
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
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Account Deletion'.tr,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Delete your account is permanent. When you delete your member account, you would not be able to retrieve the content or information.'.tr,
              textAlign: TextAlign.justify,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
                'Deleting your member account will also delete your all information. You will lose any existing point and credit.'.tr
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            icon: const Icon(
              Icons.disabled_by_default,
              color: Colors.white,
            ),
            label: Text(
              isLoading ? "Deleting...".tr : "Delete Account".tr,
            ),
            onPressed: (){
              deleteAccount();
            },
          ),
        ],
      ),
    );
  }

  Future<void> deleteAccount() async {
    if(await confirm(
      context,
      title: Text(
        'Delete Account'.tr,
      ),
      content: Text(
          'Are you sure want to permanent delete account?'.tr
      ),
      textOK: const Text('Yes'),
      textCancel: const Text('No'),
    )){
      setState((){
        isLoading = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final response = await http
          .get(Uri.parse('http://$hostServer.ezymember.com.my/api/$company_id/accountDeletion/$memberID'), headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': "Bearer $token",
      });
      var body = json.decode(response.body);
      if(response.statusCode == 200){
        final _snackBar = SnackBar(
          content: Text(
            "Permanent Delete Successfully!".tr,
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
        setState((){
          isLoading = false;
        });
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.clear();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const LoginScreen()), (Route<dynamic> route) => false);
        return;
      }
    }
  }
}
