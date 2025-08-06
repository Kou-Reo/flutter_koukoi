import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_koukoi/Service/SharedPreferenceService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KoiLocale{
  static Locale? _locale;
  /// call this to set app language
  static set setLocale(Locale locale){
    _locale = locale;
    SharedPreferenceService.setString("VMThCF5Ymdjl6uf6SxePuQ7yUJtFgM1rzsUuVDNUlJedCQpwQq", locale.languageCode);
  }

  static get locale{
    if(_locale == null){
      throw AssertionError("KoiLocale belum diinit. pangggil KoiLocale.init()");
    }
    return _locale;
  }

  /// call this before using KoiLocale
  static Future<void> init() async {
    await SharedPreferenceService.init();

    var getLanguage = SharedPreferenceService.getString("VMThCF5Ymdjl6uf6SxePuQ7yUJtFgM1rzsUuVDNUlJedCQpwQq");
    if(getLanguage == null){
      _locale = PlatformDispatcher.instance.locale;
    }
    else{
      _locale = Locale(getLanguage);
    }
  }

  /// cara panggil `KoiLocale.text.onLocale().render()`
  TextLocale get text{
    return TextLocale();
  }

}

class TextLocale{

  Map<Locale, String> _render = {};

  TextLocale onLocale(Locale locale, String text){
    _render[locale] = text;
    return this;
  }

  TextLocale en(String text){
    _render[Locale('en')] = text;
    return this;
  }
  TextLocale id(String text){
    _render[Locale('id')] = text;
    return this;
  }
  // TODO, buat locale lain

  /// if no locale match, will render first item inserted
  /// "{nama} suka main {benda}" kalo di panggil render({"nama": "andi", "benda": "bola"}) jadi "andi suka main bola"
  String render(Map<String, String> parameter){
    String toRender = _render[KoiLocale.locale] ?? _render.values.toList(growable: false)[0];

    parameter.keys.forEach((aKey){
      toRender = toRender.replaceAll("{${aKey}}", parameter[aKey]!);
    });

    return toRender;
  }
}