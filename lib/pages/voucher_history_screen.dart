import 'dart:convert';

import 'package:ezy_member/globals.dart';
import 'package:ezy_member/models/voucherDetail.dart';
import 'package:ezy_member/pages/login_screen.dart';
import 'package:ezy_member/theme/mycolor.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class VoucherHistoryScreen extends StatefulWidget {
  const VoucherHistoryScreen({super.key});

  @override
  State<VoucherHistoryScreen> createState() => _VoucherHistoryScreenState();
}

class _VoucherHistoryScreenState extends State<VoucherHistoryScreen> {
  List<VoucherDetail> voucherUsed = [];
  List<VoucherDetail> voucherExpired = [];
  List colors = [Colors.white, Colors.orange[50]];

  @override
  void initState() {
    super.initState();
    getToken();
    getUsed();
    getExpired();
  }

  Future<void> getUsed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http
        .get(Uri.parse('http://$hostServer.ezymember.com.my/api/$company_id/getVoucherUsed/$memberID/$bearerToken'), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    });
    if(response.statusCode == 200){
      voucherUsed = [];
      List uModel = json.decode(response.body);
      voucherUsed = uModel.map((json) {
        return VoucherDetail.fromJson(json);
      }).toList();
      if(voucherUsed.length > 0){
        setState((){

        });
      }

    }else {
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

  Future<void> getExpired() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http
        .get(Uri.parse('http://$hostServer.ezymember.com.my/api/$company_id/getVoucherExpired/$memberID/$bearerToken'), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    });
    if(response.statusCode == 200){
      voucherExpired = [];
      List eModel = json.decode(response.body);
      voucherExpired = eModel.map((json){
        return VoucherDetail.fromJson(json);
      }).toList();
      if(voucherExpired.length > 0){
        setState(() {

        });
      }
    }
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
    double height = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: ColorConstants.myTextBlackColor),
          elevation: 0,
          title: SizedBox(
            height: logoSize,
            child: Image(
              image: AssetImage('assets/$logoName'),
              fit: BoxFit.contain,
            ),
          ),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'Voucher Used',
              ),
              Tab(
                text: 'Voucher Expired',
              ),
            ],
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              color: ColorConstants.myPrimaryColor,
            ),
          ),
        ),
        body: TabBarView(
          children: [
            ListView.builder(
              itemCount: voucherUsed.length,
              itemBuilder: (context, index){
                final _doc = voucherUsed[index];
                return ListTile(
                    tileColor: colors[index % colors.length],
                    title: Text(
                        voucherUsed[index].batch_code
                    ),
                    subtitle: Text(
                        voucherUsed[index].voucher_code
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            'Claim On'
                        ),
                        Text(
                          voucherUsed[index].claim_on,
                        )
                      ],
                    )
                );
              },
            ),
            ListView.builder(
              itemCount: voucherExpired.length,
              itemBuilder: (context, index){
                final _doc = voucherExpired[index];
                return ListTile(
                    tileColor: colors[index % colors.length],
                    title: Text(
                        voucherExpired[index].batch_code
                    ),
                    subtitle: Text(
                        voucherExpired[index].voucher_code
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            'Start : ' + voucherExpired[index].start_date
                        ),
                        Text(
                            'End : ' + voucherExpired[index].expiry_date
                        )
                      ],
                    )
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
