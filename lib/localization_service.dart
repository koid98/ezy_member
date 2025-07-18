import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'lang/en_US.dart';
import 'lang/ms_MY.dart';
import 'lang/zh_CN.dart';

class LocalizationService extends Translations{
  static const local =  Locale('en','US');
  static const failBackLocale = Locale('en','US');

  static final langs = ['English', 'Malay', 'Chinese'];
  static final locals = [
    const Locale('en','US'),
    const Locale('ms','MY'),
    const Locale('zh','CN'),
  ];

  @override
  Map<String, Map<String,String>> get keys =>{
    'en_US' : enUS,
    'ms_MY' : msMY,
    'zh_CN' : zhCN
  };

  void changeLocale(String lang){
    final locale = getLocaleFromLanguege(lang);

    final box = GetStorage();
    box.write("lng", lang);

    Get.updateLocale(locale!);
  }

  Locale? getLocaleFromLanguege(String lang){
    for(int i=0; i < langs.length; i++){
      if (lang == langs[i]) return locals[i];
    }
    return Get.locale;
  }

  Locale getCurrentLocale(){
    final box = GetStorage();
    Locale defaultLocale;

    if (box.read("lng") != null){
      final locale = box.read('lng');
      defaultLocale = getLocaleFromLanguege(locale)!;
    } else {
      defaultLocale = const Locale('en','US');
    }

    return defaultLocale;
  }

  String getCurrentLanguege(){
    final box = GetStorage();

    return  box.read("lng") ?? 'English';
  }
}