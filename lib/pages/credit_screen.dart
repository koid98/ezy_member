import 'dart:convert';

import 'package:ezy_member/controller/connections.dart';
import 'package:ezy_member/globals.dart';
import 'package:ezy_member/models/wallet.dart';
import 'package:ezy_member/pages/credit_log_screen.dart';
import 'package:ezy_member/pages/login_screen.dart';
import 'package:ezy_member/pages/qr_scan.dart';
import 'package:ezy_member/theme/mycolor.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreditScreen extends StatefulWidget {
  const CreditScreen({super.key});

  @override
  State<CreditScreen> createState() => _CreditScreenState();
}

class _CreditScreenState extends State<CreditScreen> {
  late UserWallet data;
  bool isEmpty = true;
  bool isLoading = true;
  var balanceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final balanceFocusNode = FocusNode();
  bool showBalance = false;

  int pointValue = 10;
  int walletValue = 10;
  int voucherNum = 10;
  final bool _visible = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getToken();
    getWallet();
    // voucherList = allVouchers;
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

  getWallet() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? token = localStorage.getString('token');
    final response = await http
        .get(Uri.parse('http://$hostServer.ezymember.com.my/api/$company_id/getwallet/$memberID/$bearerToken'), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    });

    if (response.statusCode == 200) {
      setState(() {
        data = UserWallet.fromJson(jsonDecode(response.body));
        isEmpty = false;
      });
    } else if(response.statusCode == 400){
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: true,
        ),
        body: RefreshIndicator(
          onRefresh: () async{
            setState(() {
              getWallet();
            });
            // Navigator.of(context).pushReplacement(_refreshRoute());
          },
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: 210,
                      decoration: const BoxDecoration(
                        color: ColorConstants.myPrimaryColor,
                      ),
                      child: Stack(
                        children: [
                          ListView.builder(
                            itemCount: 1,
                            itemBuilder: (context, index){
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0, left: 30.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Credit".tr,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Credit".tr,
                                          style: TextStyle(
                                              fontSize: 15,
                                              color:Colors.lightBlue[900]
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Align(
                                          alignment: Alignment.topCenter,
                                          child: isEmpty
                                              ? const SizedBox(
                                            height: 30,
                                            child: Text(
                                              '0',
                                              style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ) : Text(
                                            data.balance.toString(),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 25,
                                              color:Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          Positioned(
                            top: 5,
                            right: 5,
                            child: SizedBox(
                              height: logoSize,
                              child: Image(
                                image: AssetImage('assets/$logoName'),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 140, left: 30, right: 30),
                child: Container(
                  height: 130,
                  width: MediaQuery.of(context).size.width * 0.95,
                  padding: const EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(2, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Column(
                      //   children: [
                      //     IconButton(
                      //       icon: const Icon(Icons.add_box_outlined),
                      //       color: Colors.lightBlue[900],
                      //       iconSize: 48,
                      //       onPressed: (){
                      //         balanceController.text = '';
                      //         setState(() {
                      //           showBalance = true;
                      //         });
                      //       },
                      //     ),
                      //     Text("Top Up".tr)
                      //   ],
                      // ),
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.qr_code_scanner),
                            color: Colors.lightBlue[900],
                            iconSize: 48,
                            onPressed: (){
                              Navigator.of(context).push(_QRScannerRoute());
                            },
                          ),
                          Text("Scan".tr)
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.qr_code_2_outlined ),
                            color: Colors.lightBlue[900],
                            iconSize: 48,
                            onPressed: (){
                              setState(() {
                                generateOTP();
                                showQr = true;
                              });
                            },
                          ),
                          Text("Pay".tr)
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.history),
                            color: Colors.lightBlue[900],
                            iconSize: 48,
                            onPressed: (){
                              Navigator.of(context).push(walletLogRoute());
                            },
                          ),
                          Text("History".tr)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(visible: showQr, child: showQrCode()),
              // Visibility(visible: showBalance, child: balance()),
            ],
          ),
        ),
      ),
    );
  }

  Widget showQrCode() {
    return Container(
      color: Colors.black.withOpacity(0.7),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          const SizedBox(
            height: 90,
          ),
          Container(
            height: 300,
            width: 320,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Center(
              child: QrImageView(
                data: OTP,
                version: QrVersions.auto,
                size: 250,
                gapless: true,
                embeddedImage: const AssetImage('assets/3xpress_small_logo.png'),
                embeddedImageStyle: const QrEmbeddedImageStyle(
                  size: Size(30, 30),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                showQr = false;
                // Navigator.of(context).push(_closeRoute());
              });
            },
            child: Text('Close'.tr),
            style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstants.myPrimaryColor,
                fixedSize: const Size(300, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
          ),
        ],
      ),
    );
  }

  Future<void> generateOTP() async {
    var res = await Network().getData('/$company_id/generateOTP/$memberID');
    var body = json.decode(res.body);
    print(res.body);

    var i = body['OTP'];
    if (res.statusCode == 200) {
      setState(() {
        OTP = i['OTP'].toString();
      });
      print(OTP);
    }
  }
}

Route walletLogRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
    const CreditLogScreen(),
    transitionDuration: const Duration(milliseconds: 300),
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

Route _QRScannerRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
    const QRViewActivity(),
    transitionDuration: const Duration(milliseconds: 300),
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
