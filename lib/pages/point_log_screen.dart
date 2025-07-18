import 'dart:convert';
import 'dart:io';

import 'package:ezy_member/controller/connections.dart';
import 'package:ezy_member/globals.dart';
import 'package:ezy_member/models/pointLog.dart';
import 'package:ezy_member/pages/login_screen.dart';
import 'package:ezy_member/theme/mycolor.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PointLogScreen extends StatefulWidget {
  const PointLogScreen({super.key});

  @override
  State<PointLogScreen> createState() => _PointLogScreenState();
}

class _PointLogScreenState extends State<PointLogScreen> {
  bool isEmpty = true;
  List<MemberPointLog> log = [];
  List colors = [Colors.white, ColorConstants.myPrimaryColor.withOpacity(0.5)];
  List<String> month = ['Previous 3 month'];
  String selectedMonth = '';

  @override
  void initState() {
    super.initState();
    getToken();
    getPointLog();
  }

  Future<void> getPointLog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http
        .get(Uri.parse('http://$hostServer.ezymember.com.my/api/$company_id/getPointLog/$memberID/$bearerToken'), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    });
    var body = json.decode(response.body);
    if(response.statusCode == 200){
      log = [];
      List lModel = json.decode(response.body);
      log = lModel.map((json){
        return MemberPointLog.fromJson(json);
      }).toList();
      if(log.length > 0){
        setState(() {

        });
      } else{
        setState(() {
          log = [];
        });
      }
    } else {
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

  Future<void> filterLog(String select) async {
    Map data = {
      'code': memberID,
      'date_time': select
    };

    var response = await Network().postData(data, '/$company_id/filterPointLog');
    var body = json.decode(response.body);
    if(response.statusCode == 200){
      log = [];
      List lModel = json.decode(response.body);
      log = lModel.map((json){
        return MemberPointLog.fromJson(json);
      }).toList();
      if(log.length > 0){
        setState(() {

        });
      } else {
        setState((){
          log = [];
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
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.grey[50],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                hint: Text('FILTER FOR MONTH'.tr),
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide()
                    ),
                    contentPadding: EdgeInsets.only(left: 20, right: 20)
                ),
                items: month.map((item){
                  return new DropdownMenuItem(
                      child: Text(item),
                      value: item == 'Previous 3 month' ? '3' : ''
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedMonth = value.toString();
                    filterLog(selectedMonth);
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: log.isEmpty ? Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 200,
                    child: Image(
                      image: AssetImage('assets/record-not-found.png'),
                      fit: BoxFit.contain,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Record Not Found'.tr,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey
                    ),
                  ),
                ],
              ),
            ): ListView.separated(
              itemCount: log.length,
              itemBuilder: (context, index){
                final _doc = log[index];
                return ListTile(
                  tileColor: colors[index % colors.length],
                  leading: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: Text(
                        log[index].date_time
                    ),
                  ),
                  title: Text(
                      log[index].point_action
                  ),
                  subtitle: Text(
                      log[index].DocNo
                  ),
                  trailing: Text(
                      log[index].point + ' Point'
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) { return Divider(color: Colors.grey, height: 5,); },
            ),
          )
        ],
      ),
    );
  }
}
