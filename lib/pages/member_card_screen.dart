import 'dart:convert';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:barcode_widgets/barcode_flutter.dart';
import 'package:ezy_member/controller/connections.dart';
import 'package:ezy_member/controller/encryptor.dart';
import 'package:ezy_member/globals.dart';
import 'package:ezy_member/models/memberCard.dart';
import 'package:ezy_member/models/point.dart';
import 'package:ezy_member/models/voucherCount.dart';
import 'package:ezy_member/models/wallet.dart';
import 'package:ezy_member/pages/credit_screen.dart';
import 'package:ezy_member/pages/login_screen.dart';
import 'package:ezy_member/pages/voucher_screen.dart';
import 'package:ezy_member/theme/mycolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MemberCardScreen extends StatefulWidget {
  const MemberCardScreen({super.key});

  @override
  State<MemberCardScreen> createState() => _MemberCardScreenState();
}

class _MemberCardScreenState extends State<MemberCardScreen> {
  final _formKey = GlobalKey<FormState>();

  String encryptedString = "";
  final _pinPutController = TextEditingController();
  final _pinPutFocusNode = FocusNode();

  List<MemberCard> card = [];
  late UserPoint data;
  late MemberCard data1;
  late UserWallet value;
  late VoucherCount count;
  bool isEmpty = true;
  String point = "";
  int voucherCount = 0;
  String walletCredit = "";


  @override
  void initState() {
    super.initState();
    checkVersion();
    getToken();
    getInformation();
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
                    child: Text(
                        'OKAY'
                    )
                )
              ],
            );
          }
      );
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
      // print('true');
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

  Future<void> getInformation() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? token = localStorage.getString('token');
    final response = await http
        .get(Uri.parse('http://$hostServer.ezymember.com.my/api/$company_id/memberCardPage/$memberID/$bearerToken'), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    });
    if(response.statusCode == 200){
      setState(() {
        Map cModel = json.decode(response.body);
        Map data1 = cModel['MemberCard'];
        value = UserWallet.fromJson(cModel['Wallet']);
        data = UserPoint.fromJson(cModel['Point']);
        voucher_count = cModel['VoucherCount'].toString();
        isEmpty = false;
        card_type = data1['card_type'];
        member_card_month = data1['member_card_month'];
        member_card_year = data1['member_card_year'];
        image = data1['image'];
      });
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

  void ReInitState(){
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index){
                return Column(
                  children: [
                    SizedBox(
                      height: 260,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            height: double.infinity,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: NetworkImage(image),
                                    fit: BoxFit.cover
                                )
                            ),
                            child: Stack(
                              children: [
                                const Center(
                                  child: Text(
                                    'LAO ZI HAO',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                ClipRect(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                    child: Container(
                                      color: Colors.black.withOpacity(0),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              padding: const EdgeInsets.all(5.0),
                                              constraints: const BoxConstraints(
                                                  minWidth: 100, maxWidth: 150
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: Colors.white70,
                                              ),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Name'.tr,
                                                        style: const TextStyle(
                                                            color: ColorConstants.myDarkGrey,
                                                            fontSize: 15,
                                                            fontWeight: FontWeight.bold
                                                        ),
                                                      ),
                                                      Container(
                                                        constraints: const BoxConstraints(
                                                            minWidth: 100,
                                                            maxWidth: 160
                                                        ),
                                                        child: AutoSizeText(
                                                          ' : $memberName',
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 5,),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Card Type'.tr,
                                                        style: const TextStyle(
                                                            color: ColorConstants.myDarkGrey,
                                                            fontSize: 15,
                                                            fontWeight: FontWeight.bold
                                                        ),
                                                      ),
                                                      Text(
                                                        ' : $card_type ' ,

                                                        // card[index].card_type.toString(),
                                                        overflow: TextOverflow.ellipsis,
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 5,),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Expiry Date'.tr,
                                                        style: const TextStyle(
                                                            color: ColorConstants.myDarkGrey,
                                                            fontSize: 15,
                                                            fontWeight: FontWeight.bold
                                                        ),
                                                      ),
                                                      Text(
                                                        // card[index].member_card_month.toString() + ' - ' + card[index].member_card_year.toString(),
                                                        ' : $member_card_month / $member_card_year',
                                                        overflow: TextOverflow.ellipsis,
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 5,),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                showQr = true;
                                              });
                                            },
                                            child: SizedBox(
                                              height: 70,
                                              width: 70,
                                              child: QrImageView(
                                                backgroundColor: Colors.white,
                                                data: memberID,
                                                version: QrVersions.auto,
                                                size: 100,
                                                gapless: true,
                                                embeddedImageStyle: const QrEmbeddedImageStyle(
                                                  size: Size(30, 30),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 15),
                                          child: BarCodeImage(
                                            params: Code128BarCodeParams(
                                              memberID,
                                              lineWidth: 1.5,
                                              barHeight: 40.0,
                                              withText: true,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                        width: MediaQuery.of(context).size.width * 0.8,
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                              child: SizedBox(
                                width: 150,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      "Reward Point".tr,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: ColorConstants.mySecondaryColor,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: isEmpty
                                          ? const SizedBox(
                                        height: 20,
                                        child: Text(
                                          '0',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: ColorConstants.mySecondaryColor,
                                          ),
                                        ),
                                      ) : Text(
                                        data.total_point.toString(),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: ColorConstants.mySecondaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 60,
                              width: 5,
                              child: VerticalDivider(
                                width: 3,
                                thickness: 2,
                                indent: 2,
                                endIndent: 2,
                              ),
                            ),
                            Flexible(
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.of(context).push(_creditRoute()).then((value) => ReInitState());
                                },
                                child: SizedBox(
                                  width: 150,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        "Credit".tr,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: ColorConstants.mySecondaryColor,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Align(
                                        alignment: Alignment.topCenter,
                                        child: isEmpty
                                            ? const SizedBox(
                                          height: 20,
                                          child: Text(
                                            '0',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: ColorConstants.mySecondaryColor,
                                            ),
                                          ),
                                        ) : Text(
                                          value.balance.toString(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: ColorConstants.mySecondaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 60,
                              width: 5,
                              child: VerticalDivider(
                                width: 3,
                                thickness: 2,
                                indent: 2,
                                endIndent: 2,
                              ),
                            ),
                            Flexible(
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.of(context).push(_voucherRoute()).then((value) => ReInitState());
                                },
                                child: SizedBox(
                                  width: 150,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        "Vouchers".tr,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: ColorConstants.mySecondaryColor,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        voucher_count,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: ColorConstants.mySecondaryColor,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 10, backgroundColor: ColorConstants.myPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.all(20),
                        ),
                        onPressed: () {
                          // _pinPutController.text = '';
                          setState(() {
                            // showPin = true;
                            storePin();
                            showEncrypted = true;
                          });
                        },
                        child: Text(
                          "Use point".tr,
                          style: const TextStyle(
                              fontSize: 20,
                              color: ColorConstants.myTextColor,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),

                    ),
                  ],
                );
              },
            ),
            Visibility(visible: showQr, child: showQrCode()),
            Visibility(visible: showEncrypted, child: encryptedQrScreen()),
            // Visibility(visible: showPin, child: pinCode()),
          ],
        )
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
                data: memberID,
                version: QrVersions.auto,
                size: 250,
                gapless: true,
                embeddedImage: AssetImage('assets/$smallIcon'),
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

  Widget encryptedQrScreen() {
    return Container(
      color: Colors.black.withOpacity(0.7),
      height: MediaQuery.of(context).size.height,
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
                data: encryptedString,
                version: QrVersions.auto,
                size: 250,
                gapless: true,
                embeddedImage: AssetImage('assets/$smallIcon'),
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
                showEncrypted = false;
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

  Future<void> storePin() async{
    var data = {
      'pin': _pinPutController.text
    };

    var res = await Network().postData(data, '/$company_id/generatePin/$memberID');
    var body = json.decode(res.body);
    var i = body['pin'];

    if(res.statusCode == 200){
      setState(() {
        Pin = i['pin'].toString();
      });
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      Map<String, dynamic> toJson() => {
        '"member"': '"$memberID"',
        '"pin"': '"$Pin"',
      };

      String _encrptedString = await encryptMyData(toJson().toString());
      setState(() {
        encryptedString = _encrptedString;
        showEncrypted = true;
      });
    }
  }
}

Route _voucherRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
    const VoucherScreen(),
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

Route _creditRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
    const CreditScreen(),
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

class RoundedButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const RoundedButton({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: ColorConstants.myPrimaryColor,
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}
