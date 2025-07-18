import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:ezy_member/controller/connections.dart';
import 'package:ezy_member/globals.dart';
import 'package:ezy_member/pages/login_screen.dart';
import 'package:ezy_member/theme/mycolor.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:http/http.dart' as http;

import '../models/voucherFirst.dart';

class VoucherRedeemScreen extends StatefulWidget {
  const VoucherRedeemScreen({super.key});

  @override
  State<VoucherRedeemScreen> createState() => _VoucherRedeemScreenState();
}

class _VoucherRedeemScreenState extends State<VoucherRedeemScreen> {
  bool isEmpty = true;
  bool isLoading = false;
  List<VoucherFirst> list = [];
  final panelController = PanelController();
  final _formKey = GlobalKey<FormState>();
  String code = "";

  @override
  void initState() {
    super.initState();
    getToken();
    getRedeemVoucher();
  }

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http
        .get(Uri.parse('https://$hostServer.ezymember.com.my/api/$company_id/preventMultipleLogin/$user_id'), headers: {
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
            title: Text("Multiple Login Detected".tr),
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

  getRedeemVoucher() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http
        .get(Uri.parse('https://$hostServer.ezymember.com.my/api/$company_id/redeemVoucher/$bearerToken'), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    });
    List body = json.decode(response.body);
    if(response.statusCode == 200){
      list = [];
      List vModel = json.decode(response.body);

      list = vModel.map((json) {
        return VoucherFirst.fromJson(json);
      }).toList();

      if(list.length > 0){
        setState(() {
          isEmpty = false;
        });
      }
    } else if(response.statusCode == 400) {
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
    double height = MediaQuery.of(context).size.height;
    final panelHightOpen = MediaQuery.of(context).size.height * 0.5;
    return Stack(
      key: _formKey,
      children: [
        SlidingUpPanel(
          controller: panelController,
          backdropEnabled: true,
          header: Material(
            child: Container(
              color: ColorConstants.myBabyPowderWhite,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 50,),
                  Text('T&C'.tr,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.myPrimaryColor,
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      color: ColorConstants.myScarletRed,
                      onPressed: () {
                        panelController.close();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          minHeight: 0,
          maxHeight: panelHightOpen,
          body: Scaffold(
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
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: isEmpty
                              ? SizedBox(
                            height: height * 0.75,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 200,
                                  child: Image(
                                    image: AssetImage('assets/voucher.png'),
                                    color: Colors.grey,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "No any voucher event now".tr,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ) : Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: list.length,
                                itemBuilder: (context, index) {
                                  final _voucher = list[index];

                                  return buildVoucher(_voucher);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          panelBuilder: (controller) => voucherTermsWidget(terms_condtion),
        ),
      ],
    );
  }

  Widget voucherTermsWidget(String termsCondtion) {
    return Material(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 20,right: 20),
            decoration: BoxDecoration(
              color: ColorConstants.myBabyPowderWhite,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 40.0, left: 20.0),
              child: ListView(
                children: [
                  Text(
                      termsCondtion
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildVoucher(VoucherFirst voucherFirst) {
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 0),
      child: Row(
        children: [
          Container(
            height: 100,
            width: 100,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ColorConstants.voucherLine,
              border: Border.all(color: ColorConstants.voucherLine),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0),
                topRight: Radius.circular(5.0),
                bottomRight: Radius.circular(5.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(2, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: [
                AutoSizeText(
                  "Discount RM ".tr + voucherFirst.discount,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ColorConstants.voucherText,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                AutoSizeText(
                  "Minimun Spend RM ".tr + voucherFirst.min_spend,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 7,
                    fontWeight: FontWeight.bold,
                    color: ColorConstants.voucherText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 100,
            child: VerticalDivider(
              width: 2,
              thickness: 1,
              indent: 5,
              endIndent: 5,
              color: ColorConstants.voucherLine,
            ),
          ),
          Expanded(
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: ColorConstants.voucherBack,
                border: Border.all(color: ColorConstants.voucherBack),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5.0),
                    bottomLeft: Radius.circular(5.0),
                    topRight: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(2, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    right: 10, left: 10, top: 8, bottom: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          constraints: const BoxConstraints(
                              minWidth: 100, maxWidth: 150),
                          child: AutoSizeText(
                            voucherFirst.type,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: ColorConstants.voucherText,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            showModalBottomSheet<void>(
                                context: context,
                                builder: (BuildContext context){
                                  return SingleChildScrollView(
                                    child: Container(
                                      height: height * 0.4,
                                      padding: MediaQuery.of(context).viewInsets,
                                      color: Colors.white,
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                                              child: Text(
                                                "Term & Conditions".tr,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                                child: SingleChildScrollView(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(10.0),
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          width: double.infinity,
                                                          child: Text(
                                                            voucherFirst.terms_condition,
                                                            textAlign: TextAlign.justify,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                            );
                          },
                          child: Container(
                            width: 40,
                            height: 20,
                            decoration: const BoxDecoration(
                              color: ColorConstants.voucherLine,
                              /*   border:
                                  Border.all(color: ColorConstants.voucherLine),*/
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                "T&C",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: ColorConstants.voucherText,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        constraints:
                        const BoxConstraints(minWidth: 100, maxWidth: 180),
                        child: AutoSizeText(
                          voucherFirst.start_date + " - " + voucherFirst.expiry_date,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 6,
                            fontWeight: FontWeight.bold,
                            color: ColorConstants.voucherText,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: SizedBox(
                        width: 120,
                        height: 30,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0, backgroundColor: ColorConstants.voucherLine,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                              ),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              isLoading ? null : voucherRedeem(voucherFirst.batch_code);
                            });
                          },
                          child: Text(
                            voucherFirst.use_point_redeem + " point".tr,
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> voucherRedeem(String batch_code) async {
    var res = await Network().getData('/$company_id/pointRedeem/$batch_code/$memberID/$bearerToken');
    var body = json.decode(res.body);

    if(res.statusCode == 200){
      isLoading = true;
      final _snackBar = SnackBar(
        content: Text(
          "Redeem Voucher Successfully!".tr,
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
        getRedeemVoucher();
      });
      return;
    } else if(res.statusCode == 401){
      final _snackBar = SnackBar(
        content: Text(
          "This Batch of voucher is empty.".tr,
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
    } else if(res.statusCode == 402){
      final _snackBar = SnackBar(
        content: Text(
          "Your points is not enough to redeem.".tr,
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
    } else if(res.statusCode == 403){
      final _snackBar = SnackBar(
        content: Text(
          "This batch of voucher can only redeem one time".tr,
          style: const TextStyle(
            fontSize: 14,
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
}
