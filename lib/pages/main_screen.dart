import 'dart:convert';

import 'package:card_swiper/card_swiper.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:ezy_member/globals.dart';
import 'package:ezy_member/localization_service.dart';
import 'package:ezy_member/models/carousel_model.dart';
import 'package:ezy_member/models/voucherBatch.dart';
import 'package:ezy_member/pages/about_us_screen.dart';
import 'package:ezy_member/pages/credit_screen.dart';
import 'package:ezy_member/pages/login_screen.dart';
import 'package:ezy_member/pages/member_card_screen.dart';
import 'package:ezy_member/pages/panel_widget.dart';
import 'package:ezy_member/pages/point_log_screen.dart';
import 'package:ezy_member/pages/profile_screen.dart';
import 'package:ezy_member/pages/voucher_redeem_screen.dart';
import 'package:ezy_member/pages/voucher_screen.dart';
import 'package:ezy_member/theme/mycolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:http/http.dart' as http;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final panelController = PanelController();
  final topPanelController = PanelController();
  final termsPanelController = PanelController();
  int selectedIndex = 0;
  double widgetOpacity = 1;
  bool langOption = false;
  int notificationCount = 0;
  bool showAds = true;
  List<VoucherBatch> term = [];
  bool isEmpty = true;
  List<CarouselModel> imgList = [];
  bool isImageEmpty = true;

  @override
  void initState() {
    super.initState();
    getAds();
    getFreeVoucher();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // Remove the observer
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);
  //
  //   switch (state) {
  //     case AppLifecycleState.resumed:
  //       print("resumed");
  //       break;
  //     case AppLifecycleState.inactive:
  //       print("inactive");
  //       break;
  //     case AppLifecycleState.paused:
  //       print("paused");
  //       break;
  //     case AppLifecycleState.detached:
  //       print("detached");
  //       break;
  //   }
  // }

  static final List<Widget> _widgetOptions = <Widget>[
    const MemberCardScreen(),
    const SizedBox(
      height: 0,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void cardPage() {
    setState(() {
      selectedIndex = 0;
    });
  }

  void openTermsPanel(){
    termsPanelController.open();
  }

  getFreeVoucher() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? token = localStorage.getString('token');
    final response = await http
        .get(Uri.parse('http://$hostServer.ezymember.com.my/api/$company_id/freevoucher/$user_id/$bearerToken'), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    });
    var body = json.decode(response.body);

    if (response.statusCode == 200) {
      term = [];
      List vModel = json.decode(response.body);

      term = vModel.map((json) {
        return VoucherBatch.fromJson(json);
      }).toList();

      if (term.isNotEmpty) {
        setState(() {
          isEmpty = false;
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

  Future<void> getAds() async {
    final response = await http
        .get(Uri.parse('https://$hostServer.ezymember.com.my/api/$company_id/advertisment'));
    List body = json.decode(response.body);

    if (response.statusCode == 200) {
      imgList = [];
      List cModel = json.decode(response.body);

      imgList = cModel.map((json) {
        return CarouselModel.fromJson(json);
      }).toList();

      if (imgList.isNotEmpty) {
        setState(() {
          isImageEmpty = false;
        });
      }
    } else {
      throw Exception('Failed to update album.');
    }
  }

  @override
  Widget build(BuildContext context) {
    const panelHightClose = 50.0;
    final panelHightOpen = MediaQuery.of(context).size.height -
        (190 + AppBar().preferredSize.height);

    return WillPopScope(
      onWillPop: () async {
        if (panelController.isPanelClosed) {
          panelController.open();
        } else {
          if (await confirm(
            context,
            title: Text("Exit Application".tr),
            content:
            Text("Are you sure you want to exit the application?".tr),
            textOK: Text("Yes".tr),
            textCancel: Text("No".tr),
          )) {
            return true;
          }
        }
        return false;
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Stack(
          children: [
            Scaffold(
              key: _scaffoldKey,
              drawer: sideDrawer(),
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
              body: Stack(
                children: [
                  Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: ColorConstants.myBabyPowderWhite,
                      /*gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors:
                        [
                          ColorConstants.mySecondaryColor,
                          ColorConstants.myThirdColor,
                        ],
                      ),*/
                    ),
                  ),
                  SlidingUpPanel(
                    controller: panelController,
                    minHeight: panelHightClose,
                    maxHeight: panelHightOpen,
                    //snapPoint: 0.99,
                    isDraggable: true,
                    //Provider.of<MyPanelState>(context).panelIsDragable? true: false,
                    defaultPanelState: PanelState.OPEN,
                    color: Colors.transparent,
                    parallaxEnabled: true,
                    parallaxOffset: 0.5,
                    onPanelSlide: (position) {
                      setState(() {
                        widgetOpacity = position;
                        topPanelController.panelPosition = position;
                      });
                      if (position == 1) {
                        setState(() {
                          showQr = false;
                          showPin = false;
                          showEncrypted = false;
                          //_onItemTapped(0);
                        });
                        _onItemTapped(1);
                      }
                      if (position == 0) {
                        _onItemTapped(0);
                      }
                    },

                    body: Stack(
                      children: [
                        //Opacity(opacity: widgetOpacity, child: AddsBanner()),
                        Opacity(
                          opacity: 1 - widgetOpacity,
                          child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: _widgetOptions.elementAt(selectedIndex)),
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                      ],
                    ),
                    panelBuilder: (controller) => PanelWidget(
                      changePage: cardPage,
                      openTermsPanel: openTermsPanel,
                      panelController: panelController,
                      controller: controller,
                    ),
                  ),
                  SlidingUpPanel(
                    controller: topPanelController,
                    minHeight: 0,
                    maxHeight: 200,
                    slideDirection: SlideDirection.DOWN,
                    defaultPanelState: PanelState.OPEN,
                    isDraggable: false,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(24.0),
                      bottomLeft: Radius.circular(24.0),
                    ),
                    panelBuilder: (controller) => Opacity(
                      opacity: widgetOpacity,
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(24.0),
                            bottomRight: Radius.circular(24.0),
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: isImageEmpty
                              ? SizedBox(
                            height: MediaQuery.of(context).size.width * 0.6,
                            width: MediaQuery.of(context).size.width,
                            child: const Image(
                              image: AssetImage('assets/e_logo.png'),
                              fit: BoxFit.cover,
                            ),
                          )
                              : buildCarousel(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SlidingUpPanel(
              controller: termsPanelController,
              minHeight: 0,
              maxHeight: MediaQuery.of(context).size.height * 0.5,
              defaultPanelState: PanelState.CLOSED,
              isDraggable: false,
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
                            termsPanelController.close();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              panelBuilder: (controller) => voucherTermsWidget(),
            ),
            Visibility(
              visible: isShowImage,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      isShowImage = false;
                    });
                  },
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                image: NetworkImage(
                                    imageShow ?? ''
                                ),
                                fit: BoxFit.contain
                            )
                        ),
                      ),
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
      ),
    );
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

  Widget buildImage(CarouselModel urlImage) {
    return GestureDetector(
      onTap: () {
        setState(() {
          imageShow = urlImage.image_url;
          isShowImage = true;
        });
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24.0),
              bottomRight: Radius.circular(24.0),
            ),
            image: DecorationImage(
                image: NetworkImage(
                  urlImage.image_url,
                ),
                fit: BoxFit.cover)),
        //margin: EdgeInsets.symmetric(horizontal: 5),
      ),
    );
  }

  Widget pushNotification(){
    return const SizedBox(
      height: 300,
      width: 100,
      child: Text(
          '1'
      ),
    );
  }

  Widget sideDrawer() {
    const padding = EdgeInsets.symmetric(horizontal: 20);
    return Drawer(
      child: Material(
        //color: const Color(0xff515A5A),
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: ColorConstants.myPrimaryColor,
              ),
              child: Row(
                children: [
                  const SizedBox(width: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 45),
                      Text(
                        "Hello".tr,
                        style:
                        const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        memberName,
                        style:
                        const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: Column(
                        children: [
                          buildMenuItem(
                            text: 'Member Card'.tr,
                            icon: Icons.card_membership,
                            onClicked: () => selectedItem(context, 5),
                          ),
                          buildMenuItem(
                            text: 'Credit'.tr,
                            icon: Icons.account_balance_wallet_outlined,
                            onClicked: () => selectedItem(context, 7),
                          ),
                          buildMenuItem(
                            text: 'Vouchers'.tr,
                            icon: Icons.confirmation_num_outlined,
                            onClicked: () => selectedItem(context, 6),
                          ),
                          const Divider(color: Colors.black),
                          const SizedBox(height: 3),
                          buildMenuItem(
                            text: 'Update Profile'.tr,
                            icon: Icons.person,
                            onClicked: () => selectedItem(context, 0),
                          ),
                          const SizedBox(height: 3),
                          buildMenuItem(
                            text: 'Change Language'.tr,
                            icon: Icons.translate,
                            onClicked: () => selectedItem(context, 1),
                          ),
                          const SizedBox(height: 3),
                          buildMenuItem(
                            text: 'Transactions History'.tr,
                            icon: Icons.update,
                            onClicked: () => selectedItem(context, 2),
                          ),
                          const SizedBox(height: 3),
                          const Divider(color: Colors.black),
                          const SizedBox(height: 3),
                          buildMenuItem(
                            text: 'Redeem Voucher'.tr,
                            icon: Icons.card_giftcard,
                            onClicked: () => selectedItem(context, 8),
                          ),
                          const SizedBox(height: 3),
                          const Divider(color: Colors.black),
                          const SizedBox(height: 3),
                          buildMenuItem(
                            text: 'About Us'.tr,
                            icon: Icons.business,
                            onClicked: () => selectedItem(context, 3),
                          ),
                          const SizedBox(height: 3),
                          const Divider(color: Colors.black),
                          const SizedBox(height: 3),
                          // buildMenuItem(
                          //   text: 'Test'.tr,
                          //   icon: Icons.videogame_asset,
                          //   onClicked: () => selectedItem(context, 8),
                          // ),
                          // const SizedBox(height: 3),
                          // const Divider(color: Colors.black),
                          // const SizedBox(height: 3),
                          buildMenuItem(
                            text: 'Sign out'.tr,
                            icon: Icons.directions_run,
                            onClicked: () => selectedItem(context, 4),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    const color = Colors.black;
    const hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: const TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  Future<void> selectedItem(BuildContext context, int index) async {
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        Navigator.of(context).push(_profileRoute());
        break;
      case 1:
        setState(() {
          langOption = true;
        });
        break;
      case 2:
        Navigator.of(context).push(_pointLogRoute());
        break;
      case 3:
        Navigator.of(context).push(_aboutRoute());
        break;
      case 4:
      /*Clear All SharedPreferences*/
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.clear();

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const LoginScreen()));
        break;
      case 5:
        panelController.close();
        break;
      case 6:
        Navigator.of(context).push(_voucherRoute());
        break;
      case 7:
        Navigator.of(context).push(_walletRoute());
        break;
      case 8:
        Navigator.of(context).push(_redeemRoute());
    }
  }

  Widget showBirthdayMessage() {
    return Container(
      color: Colors.black.withOpacity(0.7),
      height: MediaQuery.of(context).size.height * 0.90,
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
              child: Column(
                children: const [
                  Text(
                      "Happy Birthday"
                  ),
                  Text(
                      "System assign the birthday voucher to you, please check in voucher page."
                  )
                ],
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

  Widget changeLanguegeWidget() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          height: 260,
          width: 320,
          decoration: BoxDecoration(
              color: ColorConstants.myThirdColor,
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
                        color: ColorConstants.mySecondaryColor,
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
                    child: const Text('English'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstants.myPrimaryColor,
                        fixedSize: const Size(300, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
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
                    child: const Text('Bahasa Melayu'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstants.myPrimaryColor,
                        fixedSize: const Size(300, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
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
                    child: const Text('中文'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstants.myPrimaryColor,
                        fixedSize: const Size(300, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget voucherTermsWidget() {
    return Material(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
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
              child: Text(
                  terms_condtion
              )
          ),
        ],
      ),
    );
  }
}

Route _walletRoute(){
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

Route _aboutRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
    const AboutUsScreen(),
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

Route _profileRoute(){
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
    const ProfileScreen(),
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

Route _pointLogRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
    const PointLogScreen(),
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

Route _redeemRoute(){
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
    const VoucherRedeemScreen(),
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
