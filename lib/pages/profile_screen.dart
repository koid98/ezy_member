import 'dart:convert';

import 'package:ezy_member/controller/connections.dart';
import 'package:ezy_member/globals.dart';
import 'package:ezy_member/models/memberData.dart';
import 'package:ezy_member/pages/account_deletion_screen.dart';
import 'package:ezy_member/pages/change_password_screen.dart';
import 'package:ezy_member/pages/login_screen.dart';
import 'package:ezy_member/theme/mycolor.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEmpty = true;
  List<MemberData> list = [];
  late MemberData data;
  bool isLoading = false;
  var memberData;
  String selectedValue = "";
  bool status = true;
  bool status2 = true;
  bool status3 = true;
  bool status4 = true;
  bool status5 = true;
  String _selection = "";
  List<String> gender_type = ['Male'.tr, 'Female'.tr];
  bool isEdit = false;

  DateTime selectedDate = DateTime.now();
  TextEditingController codeController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phone1Controller = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController address1Controller = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController postcodeController = TextEditingController();
  var myFormat = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    getToken();
    getMember();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController.text = myFormat.format(selectedDate);
      });

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

  Future <void> getMember() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? token = localStorage.getString('token');
    final response = await http
        .get(Uri.parse('http://$hostServer.ezymember.com.my/api/$company_id/getcurrentmember/$memberID/$bearerToken'), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    });

    if (response.statusCode == 200) {
      setState(() {
        data = MemberData.fromJson(jsonDecode(response.body));
        nameController.text = data.name.toString();
        codeController.text = data.code.toString();
        emailController.text = data.email.toString();
        phone1Controller.text = data.phone_number1.toString();
        address1Controller.text = data.address1 == 'null' ? '' : data.address1;
        stateController.text = data.state_name == 'null' ? '' : data.state_name;
        areaController.text = data.area_name == 'null' ? '' : data.area_name;
        dateController.text = data.date_of_birth == 'null' ? '' : data.date_of_birth;
        genderController.text = data.gender_type == 'null' ? '' : data.gender_type;
        postcodeController.text = data.postcode == 'null' ? '' : data.postcode;
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

  Future<void> updateMember() async{
    var data = {
      'code': memberID,
      'name': nameController.text,
      'phone_number1': phone1Controller.text,
      'date_of_birth': dateController.text,
      'address1': address1Controller.text,
      'gender_type': genderController.text,
      'area_name': areaController.text,
      'state_name': stateController.text,
      'postcode': postcodeController.text
    };

    var res = await Network().postData(data, '/$company_id/memberDetailUpdate/$bearerToken');
    var body = json.decode(res.body);

    if(res.statusCode == 200){
      setState((){
        memberName = nameController.text;
        isEdit = false;
        getMember();
      });
      final _snackBar = SnackBar(
        content: Text(
          "Member Information Update Successfully!".tr,
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
      // Navigator.of(context).pushReplacement(_refreshRoute());
    } else if(res.statusCode == 401){
      final _snackBar = SnackBar(
        content: Text(
          "Phone number is already existing".tr,
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

  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text('Male'), value: "Male"),
      DropdownMenuItem(child: Text('Female'), value: "Female")
    ];
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
          actions: <Widget>[
            IconButton(
              icon: isEdit ? Icon(Icons.save) : Icon(Icons.edit),
              onPressed: () {
                if(isEdit){
                  updateMember();
                } else {
                  setState(() {
                    isEdit = true;
                  });
                }
              },
            ),
            isEdit ? IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () {
                setState(() {
                  isEdit = false;
                  getMember();
                });
              },
            ) : SizedBox()
          ]
      ),
      body: Container(
        height: height * 0.9,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  height: height * 0.87,
                  color: Colors.white,
                  child: Center(
                      child: isEmpty ? SizedBox(
                        height: height * 0.70,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(
                              backgroundColor: Colors.red,
                              strokeWidth: 8,
                            ),
                            const SizedBox(height: 10,),
                            Text(
                              "LOADING...".tr,
                            )
                          ],
                        ),
                      ): ListView.builder(
                          itemCount: 1,
                          itemBuilder: (context, index){
                            return Column(
                              children: [
                                // Padding(
                                //   padding: const EdgeInsets.only(top: 10, left: 10.0, right: 10, bottom: 10),
                                //   child: Container(
                                //     decoration: BoxDecoration(
                                //         borderRadius: const BorderRadius.all(Radius.circular(10)),
                                //         border: Border.all(color: Colors.grey),
                                //         color: Colors.blueGrey[50]
                                //     ),
                                //     child: Padding(
                                //       padding: const EdgeInsets.only(top: 22.0, bottom: 22.0, left: 10.0, right: 10.0),
                                //       child: Row(
                                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //         children: [
                                //           Container(
                                //             child: Row(
                                //               children: [
                                //                 const Icon(Icons.library_books),
                                //                 const SizedBox(width: 20,),
                                //                 Text(
                                //                   data.code.toString(),
                                //                   style: const TextStyle(
                                //                       fontSize: 20
                                //                   ),
                                //                 ),
                                //               ],
                                //             )
                                //           ),
                                //         ],
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                // Padding(
                                //   padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 10),
                                //   child: Container(
                                //     decoration: BoxDecoration(
                                //         borderRadius: const BorderRadius.all(Radius.circular(10)),
                                //         border: Border.all(color: Colors.grey),
                                //         color: Colors.blueGrey[50]
                                //     ),
                                //     child: Padding(
                                //       padding: const EdgeInsets.only(top: 22.0, bottom: 22.0, left: 10.0, right: 10.0),
                                //       child: Row(
                                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //         children: [
                                //           Container(
                                //             child: Row(
                                //               children: [
                                //                 const Icon(Icons.email),
                                //                 const SizedBox(width: 20,),
                                //                 Text(
                                //                   data.email.toString(),
                                //                   style: const TextStyle(
                                //                       fontSize: 20
                                //                   ),
                                //                 )
                                //               ],
                                //             ),
                                //           ),
                                //         ],
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 10, top: 10),
                                  child: TextField(
                                    enabled: false,
                                    controller: codeController,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                          Icons.library_books,
                                          color: ColorConstants.mySecondaryColor
                                      ),
                                      contentPadding: const EdgeInsets.only(
                                          top: 5, bottom: 5, left: 10, right: 10
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          borderSide: const BorderSide(
                                              color: Colors.grey
                                          )
                                      ),
                                      hintText: "Member Code".tr,
                                      hintStyle: TextStyle(
                                          color: Colors.grey[500],
                                          fontStyle: FontStyle.italic
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 10),
                                  child: TextField(
                                    enabled: false,
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                          Icons.email,
                                          color: ColorConstants.mySecondaryColor
                                      ),
                                      contentPadding: const EdgeInsets.only(
                                          top: 5, bottom: 5, left: 10, right: 10
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          borderSide: const BorderSide(
                                              color: Colors.grey
                                          )
                                      ),
                                      hintText: "Email Address".tr,
                                      hintStyle: TextStyle(
                                          color: Colors.grey[500],
                                          fontStyle: FontStyle.italic
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 10),
                                  child: TextField(
                                    enabled: isEdit ? true : false,
                                    controller: nameController,
                                    maxLength: 100,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                          Icons.person,
                                          color: ColorConstants.mySecondaryColor
                                      ),
                                      counterText: '',
                                      contentPadding: const EdgeInsets.only(
                                          top: 5, bottom: 5, left: 10, right: 10
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          borderSide: const BorderSide(
                                              color: Colors.grey
                                          )
                                      ),
                                      hintText: "Name".tr,
                                      hintStyle: TextStyle(
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 10),
                                  child: TextField(
                                    enabled: isEdit ? true : false,
                                    controller: phone1Controller,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                          Icons.phone,
                                          color: ColorConstants.mySecondaryColor
                                      ),
                                      contentPadding: const EdgeInsets.only(
                                          top: 5, bottom: 5, left: 10, right: 10
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          borderSide: const BorderSide(
                                              color: Colors.grey
                                          )
                                      ),
                                      hintText: "Phone Number".tr,
                                      hintStyle: TextStyle(
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 10),
                                  child: TextField(
                                    enabled: dateController.text == '' ? (isEdit ? true : false) : (dateController.text != null) ? false : false,
                                    controller: dateController,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                          Icons.cake,
                                          color: ColorConstants.mySecondaryColor
                                      ),
                                      contentPadding: const EdgeInsets.only(
                                          top: 5, bottom: 5, left: 10, right: 10
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          borderSide: const BorderSide(
                                              color: Colors.grey
                                          )
                                      ),
                                      suffixIcon: InkWell(
                                        onTap: () {
                                          _selectDate(context);
                                        },
                                        child: dateController.text == '' ? (isEdit ? Icon(
                                          Icons.calendar_month,
                                          color: ColorConstants.mySecondaryColor,
                                        ) : Icon(
                                          Icons.calendar_month,
                                          color: Colors.grey,
                                        )) : dateController.text != 'null' ? Icon(
                                          Icons.calendar_month,
                                          color: Colors.grey,
                                        ) : Icon(
                                          Icons.calendar_month,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      hintText: "Date of Birth".tr,
                                      hintStyle: TextStyle(
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 10),
                                  child: TextField(
                                    enabled: isEdit ? true : false,
                                    controller: address1Controller,
                                    maxLength: 40,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                          Icons.home,
                                          color: ColorConstants.mySecondaryColor
                                      ),
                                      counterText: '',
                                      contentPadding: const EdgeInsets.only(
                                          top: 5, bottom: 5, left: 10, right: 10
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          borderSide: const BorderSide(
                                              color: Colors.grey
                                          )
                                      ),
                                      hintText: "Home Address".tr,
                                      hintStyle: TextStyle(
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 10),
                                  child: TextField(
                                    enabled: isEdit ? true : false,
                                    controller: postcodeController,
                                    maxLength: 40,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                          Icons.location_on,
                                          color: ColorConstants.mySecondaryColor
                                      ),
                                      counterText: '',
                                      contentPadding: const EdgeInsets.only(
                                          top: 5, bottom: 5, left: 10, right: 10
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          borderSide: const BorderSide(
                                              color: Colors.grey
                                          )
                                      ),
                                      hintText: "Postcode".tr,
                                      hintStyle: TextStyle(
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 10),
                                  child: TextField(
                                    enabled: isEdit ? true : false,
                                    controller: areaController,
                                    maxLength: 40,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                          Icons.location_city,
                                          color: ColorConstants.mySecondaryColor
                                      ),
                                      counterText: '',
                                      contentPadding: const EdgeInsets.only(
                                          top: 5, bottom: 5, left: 10, right: 10
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          borderSide: const BorderSide(
                                              color: Colors.grey
                                          )
                                      ),
                                      hintText: "Area".tr,
                                      hintStyle: TextStyle(
                                        color: Colors.grey[500],
                                      ),
                                      // label: const Text("Name"),
                                      // labelStyle: const TextStyle(
                                      //   color: Colors.black
                                      // )
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 10),
                                  child: TextField(
                                    enabled: isEdit ? true : false,
                                    controller: stateController,
                                    maxLength: 40,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                          Icons.home,
                                          color: ColorConstants.mySecondaryColor
                                      ),
                                      counterText: '',
                                      contentPadding: const EdgeInsets.only(
                                          top: 5, bottom: 5, left: 10, right: 10
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          borderSide: const BorderSide(
                                              color: Colors.grey
                                          )
                                      ),
                                      hintText: "State".tr,
                                      hintStyle: TextStyle(
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 10),
                                    child: isEdit ? DropdownButtonFormField(
                                      disabledHint: Text('select gender'.tr),
                                      // value: genderController.text == ''? '' : genderController.text,
                                      onChanged: (String? newValue){
                                        setState(() {
                                          selectedValue = newValue!;
                                          genderController.text = selectedValue;
                                        });
                                      },
                                      items: gender_type.map((item){
                                        return new DropdownMenuItem(
                                          child: Text(item),
                                          value: item,
                                        );
                                      }).toList(),
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(
                                            Icons.transgender,
                                            color: ColorConstants.mySecondaryColor
                                        ),
                                        contentPadding: const EdgeInsets.only(
                                            top: 5, bottom: 5, left: 10, right: 10
                                        ),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(5)
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(5),
                                            borderSide: const BorderSide(
                                                color: Colors.grey
                                            )
                                        ),
                                        hintText: "Gender".tr,
                                        hintStyle: TextStyle(
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ) : TextField(
                                      enabled: isEdit ? true : false,
                                      controller: genderController,
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(
                                            Icons.transgender,
                                            color: ColorConstants.mySecondaryColor
                                        ),
                                        contentPadding: const EdgeInsets.only(
                                            top: 5, bottom: 5, left: 10, right: 10
                                        ),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(5)
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(5),
                                            borderSide: const BorderSide(
                                                color: Colors.grey
                                            )
                                        ),
                                        hintText: "Gender".tr,
                                        hintStyle: TextStyle(
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    )
                                ),
                                Divider(height: 5, color: Colors.grey,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 10, top: 10),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(_changeRoute());
                                    },
                                    child: TextField(
                                      enabled: false,
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(
                                            Icons.lock,
                                            color: ColorConstants.mySecondaryColor
                                        ),
                                        contentPadding: const EdgeInsets.only(
                                            top: 5, bottom: 5, left: 10, right: 10
                                        ),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(5)
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(5),
                                            borderSide: const BorderSide(
                                                color: Colors.grey
                                            )
                                        ),
                                        suffixIcon: InkWell(
                                            onTap: () {

                                            },
                                            child: Icon(
                                              Icons.change_circle_outlined,
                                              color: ColorConstants.mySecondaryColor,
                                            )
                                        ),
                                        hintText: "Password".tr,
                                        hintStyle: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 10),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(_deleteRoute());
                                    },
                                    child: TextField(
                                      enabled: false,
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(
                                            Icons.account_box,
                                            color: ColorConstants.mySecondaryColor
                                        ),
                                        contentPadding: const EdgeInsets.only(
                                            top: 5, bottom: 5, left: 10, right: 10
                                        ),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(5)
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(5),
                                            borderSide: const BorderSide(
                                                color: Colors.grey
                                            )
                                        ),
                                        suffixIcon: InkWell(
                                            onTap: () {

                                            },
                                            child: Icon(
                                              Icons.disabled_by_default,
                                              color: ColorConstants.mySecondaryColor,
                                            )
                                        ),
                                        hintText: "Account Deletion".tr,
                                        hintStyle: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                      )
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Route _deleteRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
    const AccountDeletionScreen(),
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

Route _changeRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
    const ChangePasswordScreen(),
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
