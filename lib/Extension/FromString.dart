import 'dart:ui';

import 'package:flutter_koukoi/Localization/KoiLocale.dart';
import 'package:flutter_koukoi/Logic/KoiLogic.dart';

extension FromString on String{

  /// Kalau misalnya isi string "IkanAsinGoreng", fungsi ini akan mereturn "Ikan Asin Goreng"
  String get koiDisplaySpaceBetweenEachCapital{

    String value = this;

    String ret = "";
    value.split('').forEach((ch){
      if(ch == ch.toUpperCase()){
        ret = ret+" ";
      }
      ret = ret+ch;
    });

    return ret;
  }

  /// buat semua awal kata jadi kapital. "ikan asin" jadi "Ikan Asin"
  String get koiDisplayCapitalizedCase{
    String ret = "";
    this.split(" ").forEach((element) {
      var elementPros = element.toLowerCase();
      if(elementPros.length > 0){

        elementPros = elementPros.replaceFirst(elementPros[0], elementPros[0].toUpperCase());
      }

      if(ret == ""){
        ret = elementPros;
      }
      else{
        ret += " ${elementPros}";
      }
    });

    return ret;
  }

  /// apa string ini mengandung character lain selain whitespace (spaces, tabs atau line breaks)
  bool get IsOnlyWhitespace{
    if(this.trim().isEmpty){
      return true;
    }
    else{
      return false;
    }
  }

  /// "andi".onLocale(Locale("en"), "andi's") jadi "andi's" kalau locale yang di set user en. selain itu tetap "andi"
  String onLocale(Locale locale, String text){
    if(KoiLocale.locale == locale){
      return text;
    }
    return this;
  }
}

extension FromStringNull on String?{
  /// apa string ini null atau IsOnlyWhitespace
  bool get IsNullOrOnlyWhitespace{
    if(this == null){
      return true;
    }
    else{
      return (this as String).IsOnlyWhitespace;
    }
  }
}