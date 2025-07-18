import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:ezy_member/controller/connections.dart';
import 'package:ezy_member/globals.dart';
import 'package:ezy_member/models/voucherDetail.dart';
import 'package:ezy_member/pages/login_screen.dart';
import 'package:ezy_member/pages/voucher_history_screen.dart';
import 'package:ezy_member/theme/mycolor.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class VoucherScreen extends StatefulWidget {
  const VoucherScreen({super.key});

  @override
  State<VoucherScreen> createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {
  final panelController = PanelController();
  List<VoucherDetail> list = [];
  List<VoucherDetail> list1 = [];
  List<VoucherDetail> newObject = [];
  late Future<VoucherDetail> futureVoucher;
  bool isEmpty = true;
  bool isLoading = true;
  final _formKey = GlobalKey<FormState>();
  String code = "";
  String memberCode = "";
  var codeController = TextEditingController();
  late FToast fToast;


  @override
  void initState() {
    super.initState();
    getToken();
    fToast = FToast();
    fToast.init(context);
    getVoucher();
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

  Future <void> getVoucher() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? token = localStorage.getString('token');
    final response = await http
        .get(Uri.parse('http://$hostServer.ezymember.com.my/api/$company_id/getVoucherDetail/$memberID/$bearerToken'), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    });

    final response1 = await http
        .get(Uri.parse('http://$hostServer.ezymember.com.my/api/$company_id/getVoucherSecond/$memberID/$bearerToken'), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    });
    List body = json.decode(response.body);

    if (response.statusCode == 200) {
      list = [];
      newObject = [];
      List vModel = json.decode(response.body);
      List vModel1 = json.decode(response1.body);
      // vModel.addAll(json.decode(response1.body));

      list = vModel.map((json) {
        return VoucherDetail.fromJson(json);
      }).toList();

      list1 = vModel1.map((json) {
        return VoucherDetail.fromJson(json);
      }).toList();

      for(var i = 0; i < list1.length; i++){
        list1[i].voucher_type = "Special";
        newObject.add(list1[i]);
      }

      for(var i = 0; i < list.length; i++){
        list[i].voucher_type = "Normal";
        newObject.add(list[i]);
      }

      if (newObject.isNotEmpty) {
        setState(() {
          isEmpty = false;
          isLoading = false;
        });
      }
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
    double height = MediaQuery.of(context).size.height;
    final panelHightOpen = MediaQuery.of(context).size.height * 0.5;
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.history, color: ColorConstants.myTextColor),
            onPressed: () {
              Navigator.of(context).push(_HistoryRoute());
            },
          )
        ],
      ),
      body: Stack(
        children: [
          Column(
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
                                "Your Voucher is empty".tr,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ) : ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const BouncingScrollPhysics(),
                          itemCount: newObject.length,
                          itemBuilder: (context, index) {
                            final _voucher = newObject[index];

                            return buildVoucher(_voucher);
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Visibility(visible: showQr, child: showQrCode(code)),
          Visibility(visible: showTransfer, child: buildTransfer()),
        ],
      ),
    );
  }

  Widget buildTransfer(){
    return Container(
      color: Colors.black.withOpacity(0.7),
      height: MediaQuery.of(context).size.height * 0.888,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20, left: 10, right: 10),
                  child: Column(
                    children: [
                      Text(
                        "Transfer Voucher".tr,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: codeController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: "Member Code".tr,
                            hintText: "e.g. EZY-XXXXX",
                            border: OutlineInputBorder(),
                            // suffixIcon: IconButton(
                            //     onPressed: () async {
                            //       // try{
                            //       //   String result = await Navigator.of(context).push(_scanRoute());
                            //       //   codeController.text = result;
                            //       // } catch (e) {
                            //       //   print(e.toString());
                            //       // }
                            //     },
                            //     icon: Icon(Icons.qr_code_scanner)
                            // )
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorConstants.mySecondaryColor
                              ),
                              onPressed: (){
                                setState((){
                                  showTransfer = false;
                                  getVoucher();
                                });
                              },
                              child: Text(
                                  "Close".tr,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold
                                  )
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorConstants.mySecondaryColor
                              ),
                              onPressed: (){
                                setState((){
                                  transferVoucher();
                                });
                              },
                              child: Text(
                                "Transfer".tr,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Container(
                      //   width: MediaQuery.of(context).size.width * 0.3,
                      //   child: ElevatedButton(
                      //     style: ElevatedButton.styleFrom(
                      //         primary: ColorConstants.mySecondaryColor
                      //     ),
                      //     onPressed: () async {
                      //       String result = await Navigator.push(context, MaterialPageRoute(builder: (context) => TransferScanScreen()));
                      //       codeController.text = result;
                      //     },
                      //     child: Text(
                      //       "Scan".tr,
                      //       style: TextStyle(
                      //           fontWeight: FontWeight.bold
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                )
            ),
          ),
        ],
      ),
    );
  }

  Widget showQrCode(code) {
    return Container(
      color: Colors.black.withOpacity(0.7),
      height: MediaQuery.of(context).size.height * 0.888,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Container(
            height: 300,
            width: 320,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Center(
              child: QrImageView(
                data: code,
                version: QrVersions.auto,
                size: 250,
                gapless: true,
                embeddedImage: const AssetImage('assets/3xpress_small_logo.png'),
                embeddedImageStyle: const QrEmbeddedImageStyle(
                  size: Size(30, 30),
                ),
              ),
              // child: QrImage(
              //   data: code,
              //   version: QrVersions.auto,
              //   size: 250,
              //   gapless: true,
              //   embeddedImage: const AssetImage('assets/3xpress_small_logo.png'),
              //   embeddedImageStyle: QrEmbeddedImageStyle(
              //     size: const Size(30, 30),
              //   ),
              // ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                showQr = false;
                getVoucher();
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

  Widget buildVoucher(VoucherDetail voucherDetail) {
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 0),
      child: Row(
        children: [
          if(voucherDetail.voucher_type == "Normal") ...[
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
                    "Discount RM ".tr + voucherDetail.discount,
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
                    "Minimun Spend RM ".tr + voucherDetail.min_spend,
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
                              voucherDetail.type,
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
                                                              voucherDetail.terms_condition,
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
                            voucherDetail.start_date + " - " + voucherDetail.expiry_date,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Material(
                            color: ColorConstants.voucherLine,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: InkWell(
                              splashColor: Colors.grey,
                              child: SizedBox(
                                width: 30,
                                height: 30,
                                child: Icon(Icons.transfer_within_a_station, color: Colors.white,),
                              ),
                              onTap: () {
                                // Navigator.push(context, MaterialPageRoute(builder: (context) => TransferScreen()));
                                setState(() {
                                  showTransfer = true;
                                  voucher_code = voucherDetail.voucher_code;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 10,
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
                                    showQr = true;
                                    code = voucherDetail.voucher_code;
                                  });
                                },
                                child: Text(
                                  "Use Now".tr,
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
                    ],
                  ),
                ),
              ),
            )
          ] else if(voucherDetail.voucher_type == "Special")...[
            Container(
              height: 100,
              width: 100,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: ColorConstants.voucherSecond,
                border: Border.all(color: ColorConstants.voucherSecond),
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
                    "Discount RM ".tr + voucherDetail.discount,
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
                    "Minimun Spend RM ".tr + voucherDetail.min_spend,
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
                color: ColorConstants.voucherSecond,
              ),
            ),
            Expanded(
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: ColorConstants.voucherSpecial,
                  border: Border.all(color: ColorConstants.voucherSpecial),
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
                              voucherDetail.type,
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
                                                              voucherDetail.terms_condition,
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
                                color: ColorConstants.voucherSecond,
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
                            voucherDetail.start_date + " - " + voucherDetail.expiry_date,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Material(
                            color: ColorConstants.voucherSecond,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: InkWell(
                              splashColor: Colors.grey,
                              child: SizedBox(
                                width: 30,
                                height: 30,
                                child: Icon(Icons.transfer_within_a_station, color: Colors.white,),
                              ),
                              onTap: () {
                                // Navigator.push(context, MaterialPageRoute(builder: (context) => TransferScreen()));
                                setState(() {
                                  showTransfer = true;
                                  voucher_code = voucherDetail.voucher_code;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: SizedBox(
                              width: 120,
                              height: 30,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0, backgroundColor: ColorConstants.voucherSecond,
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
                                    showQr = true;
                                    code = voucherDetail.voucher_code;
                                  });
                                },
                                child: Text(
                                  "Use Now".tr,
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
                    ],
                  ),
                ),
              ),
            )
          ]
        ],
      ),
    );
  }

  Future<void> transferVoucher() async {
    if(codeController.text.isEmpty){
      Fluttertoast.cancel();
      Fluttertoast.showToast(
          msg: "Please key in your target member code".tr,
          // toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 14.0
      );
      // _showToast();
      return;
    }

    Map data = {
      'code': codeController.text.trim(),
    };

    var res = await Network().postData(data, '/$company_id/voucherTransfer/$voucher_code/$memberID/$bearerToken');
    var body = json.decode(res.body);

    if(res.statusCode == 200){
      isLoading = true;
      showTransfer = false;
      ScanData = '';
      setState(() {
        getVoucher();
      });
      // Navigator.of(context).pushReplacement(_refreshRoute());
      final _snackBar = SnackBar(
        content: Text(
          "Transfer Voucher Successfully!".tr,
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
    } else if(res.statusCode == 401){
      ScanData = '';
      Fluttertoast.cancel();
      Fluttertoast.showToast(
          msg: "Please key in valid member code".tr,
          // toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 14.0
      );
    } else if(res.statusCode == 402){
      ScanData = '';
      Fluttertoast.cancel();
      Fluttertoast.showToast(
          msg: "Cannot found the voucher!".tr,
          // toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 14.0
      );
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

// Route _scanRoute(){
//   return PageRouteBuilder(
//     pageBuilder: (context, animation, secondaryAnimation) => const CameraScanScreen(),
//     transitionDuration: const Duration(milliseconds: 300),
//     transitionsBuilder: (
//         BuildContext context,
//         Animation<double> animation,
//         Animation<double> secondaryAnimation,
//         Widget child,
//         ) =>
//         Align(
//           child: SizeTransition(
//             sizeFactor: animation,
//             child: child,
//           ),
//         ),
//   );
// }

Route _HistoryRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const VoucherHistoryScreen(),
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

class CircularProgressIndicatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return const CircularProgressIndicator(
      backgroundColor: Colors.orange,
      strokeWidth: 8,
    );
  }
}
