import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:ezy_member/controller/connections.dart';
import 'package:ezy_member/globals.dart';
import 'package:ezy_member/models/promotionAds.dart';
import 'package:ezy_member/models/voucherBatch.dart';
import 'package:ezy_member/pages/referral_program_screen.dart';
import 'package:ezy_member/theme/mycolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:http/http.dart' as http;
import 'package:badges/badges.dart' as badges;

class PanelWidget extends StatefulWidget {
  final ScrollController controller;
  final PanelController panelController;
  final Function() changePage;
  final Function() openTermsPanel;

  const PanelWidget(
      {Key? key,
        required this.controller,
        required this.panelController,
        required this.changePage,
        required this.openTermsPanel})
      : super(key: key);
  @override
  State<PanelWidget> createState() => _PanelWidgetState();
}

class _PanelWidgetState extends State<PanelWidget> {
  List<PromotionAds> imgList = [];
  List<VoucherBatch> list = [];
  bool isEmpty = true;
  int pointValue = 1;
  int walletValue = 10;
  int voucherNum = 10;
  String collectString = "";

  bool showVoucherRow = false;
  bool showPromoRow = false;
  bool isLoading = false;

  final int _counter = 0;

  @override
  void initState() {
    super.initState();
    // getVoucher();
    getPromotion();
    getFreeVoucher();
  }

  getFreeVoucher() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? token = localStorage.getString('token');
    final response = await http
        .get(Uri.parse('http://$hostServer.ezymember.com.my/api/$company_id/freevoucher/$memberID/$bearerToken'), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    });
    List body = json.decode(response.body);

    if (response.statusCode == 200) {
      list = [];
      List vModel = json.decode(response.body);

      list = vModel.map((json) {
        return VoucherBatch.fromJson(json);
      }).toList();

      if (list.isNotEmpty) {
        setState(() {
          isEmpty = false;
          showVoucherRow = true;
        });
      } else {
        setState(() {
          showVoucherRow = false;
        });
      }
    } else {
      throw Exception('Failed to load voucher.');
    }
  }

  Future<void> getPromotion() async {
    final response = await http
        .get(Uri.parse('https://$hostServer.ezymember.com.my/api/$company_id/event'));
    List body = json.decode(response.body);

    if (response.statusCode == 200) {
      imgList = [];
      List cModel = json.decode(response.body);

      imgList = cModel.map((json) {
        return PromotionAds.fromJson(json);
      }).toList();

      if (imgList.isNotEmpty) {
        setState(() {
          isEmpty = false;
          showPromoRow = true;
        });
      } else {
        setState(() {
          showPromoRow = false;
        });
      }
    } else {
      throw Exception('Failed to update album.');
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5.0), topRight: Radius.circular(5.0)),
          ),
          child: Column(
            children: [
              Material(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: IconButton(
                        icon: const Icon(Icons.expand_less),
                        color: ColorConstants.myPrimaryColor,
                        onPressed: () {
                          widget.panelController.open();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView(
                  controller: widget.controller,
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 20, right: 20),
                    //   child: itemBarWidget(),
                    // ),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    showVoucherRow ? Container(
                      color: ColorConstants.myBackgroundGrey,
                      height: 180,
                      padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Free Vouchers'.tr,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ColorConstants.mySecondaryColor,
                            ),
                          ),
                          freeVoucherWidget(),
                        ],
                      ),
                    ) : const SizedBox(height: 0,),
                    const SizedBox(
                      height: 10,
                    ),
                    showPromoRow ? Container(
                      height: MediaQuery.of(context).size.width * 0.57,
                      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Promotions'.tr,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: ColorConstants.mySecondaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20,),
                          ImageSlideshow(
                            indicatorColor: Colors.blue,
                            autoPlayInterval: 3000,
                            isLoop: true,
                            children: imgList.map((promo) {
                              return Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(5),
                                      bottomRight: Radius.circular(5),
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5),
                                    ),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                          promo.image_url,
                                        ),
                                        fit: BoxFit.cover)),
                                //margin: EdgeInsets.symmetric(horizontal: 5),
                              );
                              // return Image.network(promo.image_url);
                            }).toList(),
                          ),
                        ],
                      ),
                    ) : const SizedBox(height: 0,),
                    Container(
                      color: ColorConstants.myBackgroundGrey,
                      height: width * 0.55,
                      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Referral Program'.tr,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: ColorConstants.mySecondaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.of(context).push(_referralRoute());
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('assets/wave.png'),
                                      fit: BoxFit.contain
                                  )
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width: width * 0.5,
                                    height: width * 0.4,
                                    decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage('assets/refer_character.png'),
                                            fit: BoxFit.fill
                                        )
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "REFER".tr,
                                        style: const TextStyle(
                                            fontSize: 27,
                                            fontWeight: FontWeight.bold,
                                            color: ColorConstants.mySecondaryColor
                                        ),
                                      ),
                                      Text(
                                        "A FRIENDS".tr,
                                        style: const TextStyle(
                                            fontSize: 27,
                                            fontWeight: FontWeight.bold,
                                            color: ColorConstants.mySecondaryColor
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                          // Container(
                          //   height: 200,
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.all(Radius.circular(10)),
                          //     image: DecorationImage(
                          //       image: AssetImage('assets/refer_friends.png'),
                          //       fit: BoxFit.fill
                          //     )
                          //   )
                          // )
                        ],
                      ),
                    ),
                    const SizedBox(height: 50,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget itemBarWidget() {
    return Container(
      width: MediaQuery.of(context).size.height * 0.4,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 1,
            offset: const Offset(1, 2), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                badges.Badge(
                  showBadge: pointValue == 0 ? false : true,
                  animationType: badges.BadgeAnimationType.fade,
                  badgeColor: ColorConstants.myYellow,
                  badgeContent: Text(
                    pointValue.toString(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.myBabyPowderWhite,
                    ),
                  ),
                  child: IconButton(
                    icon: SvgPicture.asset(
                      'assets/wallet-membership.svg',
                      fit: BoxFit.contain,
                      color: Colors.lightBlue[900],
                      height: 30,
                    ),
                    tooltip: "Collect or redeem point".tr,
                    onPressed: () {
                      widget.changePage();
                      widget.panelController.close();
                    },
                  ),
                ),
                Text(
                  'Reward Point'.tr,
                  style: const TextStyle(
                    fontSize: 10,
                    color: ColorConstants.mySecondaryColor,
                  ),
                )
              ],
            ),
          ),
          const VerticalDivider(
            width: 5,
            thickness: 2,
            indent: 20,
            endIndent: 20,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                badges.Badge(
                  showBadge: walletValue == 0 ? false : true,
                  animationType: badges.BadgeAnimationType.fade,
                  badgeColor: ColorConstants.myYellow,
                  badgeContent: Text(
                    walletValue.toString(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.myBabyPowderWhite,
                    ),
                  ),
                  child: IconButton(
                    icon: SvgPicture.asset(
                      'assets/wallet-outline.svg',
                      fit: BoxFit.contain,
                      color: Colors.lightBlue[900],
                      height: 30,
                    ),
                    tooltip: "Use ewallet".tr,
                    onPressed: () {
                      widget.changePage();
                      // Navigator.of(context).push(_walletRoute());
                      setState(() {});
                    },
                  ),
                ),
                Text(
                  'Wallet'.tr,
                  style: const TextStyle(
                    fontSize: 10,
                    color: ColorConstants.mySecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(
            width: 5,
            thickness: 2,
            indent: 20,
            endIndent: 20,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                badges.Badge(
                  showBadge: voucherNum == 0 ? false : true,
                  animationType: badges.BadgeAnimationType.fade,
                  badgeColor: ColorConstants.myYellow,
                  badgeContent: Text(
                    voucher_count.toString(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.myBabyPowderWhite,
                    ),
                  ),
                  child: IconButton(
                    icon: SvgPicture.asset(
                      'assets/ticket-percent-outline.svg',
                      fit: BoxFit.contain,
                      color: Colors.lightBlue[900],
                      height: 30,
                    ),
                    tooltip: "Use vouchers".tr,
                    onPressed: () {
                      // Navigator.of(context).push(_voucherRoute());
                    },
                  ),
                ),
                Text(
                  'Vouchers'.tr,
                  style: const TextStyle(
                    fontSize: 10,
                    color: ColorConstants.mySecondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget offerWidget() {
    return isEmpty?Container(
      height: MediaQuery.of(context).size.width * 0.4,
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 1,
            offset: const Offset(1, 2), // changes position of shadow
          ),
        ],
      ),

    ):buildCarousel();
  }

  Widget freeVoucherWidget() {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (context, index) {
          final _voucher = list[index];

          return buildVoucher(_voucher);
        },
      ),
    );
  }

  Widget buildVoucher(VoucherBatch voucherBatch) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: 140,
      width: 320,
      padding: const EdgeInsets.all(5),
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
                  "Discount RM ".tr + voucherBatch.discount,
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
                  //'Code: ' + voucherBatch.batch_code.toString(),
                  "Minimun Spend RM ".tr + voucherBatch.min_spend.toString(),
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
                              minWidth: 100, maxWidth: 120),
                          child: AutoSizeText(
                            voucherBatch.type,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
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
                                                            voucherBatch.terms_condition,
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
                          voucherBatch.start_date + ' - ' + voucherBatch.expiry_date,
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
                            isLoading ? null : voucherCollect(voucherBatch.id);
                          },
                          child: Text(
                            "Collect Now".tr,
                            style: const TextStyle(
                                fontSize: 11,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                      // child: Container(
                      //   width: 120,
                      //   height: 30,
                      //   decoration: const BoxDecoration(
                      //     color: ColorConstants.myDarkGrey,
                      //     /*border: Border.all(color: ColorConstants.voucherLine),*/
                      //     borderRadius: BorderRadius.only(
                      //       topLeft: Radius.circular(10.0),
                      //       bottomLeft: Radius.circular(10.0),
                      //       topRight: Radius.circular(10.0),
                      //       bottomRight: Radius.circular(10.0),
                      //     ),
                      //   ),
                      //   child: Center(
                      //     child: Text(
                      //       "Collect Now".tr,
                      //       style: const TextStyle(
                      //         fontSize: 12,
                      //         fontWeight: FontWeight.bold,
                      //         color: ColorConstants.voucherText,
                      //       ),
                      //     ),
                      //   ),
                      // ),
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

  Future<void> togglePanel() {
    return widget.panelController.close();
  }

  Widget buildCarousel() {
    return Swiper(
        itemCount: imgList.length,
        autoplay: true,
        itemBuilder: (context, index) {
          final urlImage = imgList[index];
          return buildImage(urlImage);
        }
    );
  }

  Widget buildImage(PromotionAds urlImage) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(10.0),
            topLeft: Radius.circular(10.0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
          ),
          image: DecorationImage(
              image: NetworkImage(
                urlImage.image_url,
              ),
              fit: BoxFit.cover)),
    );
  }

  Future<void> voucherCollect(String id) async {
    Map data = {
      'id': id,
    };
    var res = await Network().getData('/$company_id/collect/$id/$memberID/$bearerToken');
    var body = json.decode(res.body);

    if (res.statusCode == 200) {
      setState(() {
        getFreeVoucher();
      });
      final _snackBar = SnackBar(
        content: Text(
          "Collect Voucher Successfully!".tr,
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
    }
    else if(res.statusCode == 401){
      final _snackBar = SnackBar(
        content: Text(
          "This batch of voucher is invalid".tr,
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
          "This batch of voucher is expired".tr,
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
    } else if(res.statusCode == 404) {
      final _snackBar = SnackBar(
        content: Text(
          "You already collect this batch of voucher!".tr,
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
}

Route _referralRoute(){
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const ReferralProgramScreen(),
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
