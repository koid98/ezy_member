import 'package:ezy_member/localization_service.dart';
import 'package:ezy_member/theme/mycolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class ShowPasswordScreen extends StatefulWidget {
  const ShowPasswordScreen({super.key});

  @override
  State<ShowPasswordScreen> createState() => _ShowPasswordScreenState();
}

class _ShowPasswordScreenState extends State<ShowPasswordScreen> {
  final TextEditingController _textController = TextEditingController();
  bool langOption = false;

  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: _textController.text));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Copied to clipboard'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
                color: ColorConstants.LoginBackground
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: const Image(
                image: AssetImage('assets/header2.png'),
                fit: BoxFit.contain,
                color: ColorConstants.myPrimaryColor,
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.24,
              child: const Image(
                  image: AssetImage('assets/header.png'),
                  fit: BoxFit.contain,
                  color: ColorConstants.myPrimaryColor
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: Material(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Powered By : EzyOrder',
                    style: TextStyle(
                      fontSize: 12,
                      color: ColorConstants.myShadowColor.withOpacity(0.5),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Wrap(
                      children: [
                        buildPassword(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 10,
            child: SizedBox(
              height: 50,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    langOption = true;
                  });
                },
                child: Text(
                  "MyLanguage".tr,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
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
    );
  }

  Widget buildPassword(){
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: const Image(
                  image: AssetImage('assets/laozihao-logo.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border: Border.all(color: ColorConstants.myPrimaryColor)
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 20, left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Welcome to join Lao Zi Hao".tr,
                  style: const TextStyle(
                      fontSize: 18
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text("The password is show in below:".tr),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Phone number of last 6 digit".tr,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Important:".tr,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Your temporary password valid for 7 days, Please change your password.".tr,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Back to Login".tr,
                    style: const TextStyle(
                      fontSize: 15, color: Colors.lightBlueAccent, decoration: TextDecoration.underline,),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget changeLanguegeWidget() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          height: 260,
          width: 320,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  ColorConstants.mySecondaryColor,
                  ColorConstants.myPrimaryColor,
                ],
              ),
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
                        color: Colors.white,
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
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstants.myPrimaryColor,
                        fixedSize: const Size(300, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: const Text(
                      'English',
                      style: TextStyle(
                        color: ColorConstants.myTextColor,
                        fontSize: 16,
                      ),
                    ),
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
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstants.myPrimaryColor,
                        fixedSize: const Size(300, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: const Text(
                      'Bahasa Melayu',
                      style: TextStyle(
                        color: ColorConstants.myTextColor,
                        fontSize: 16,
                      ),
                    ),
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
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstants.myPrimaryColor,
                        fixedSize: const Size(300, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: const Text(
                      '中文',
                      style: TextStyle(
                        color: ColorConstants.myTextColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
