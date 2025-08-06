import 'dart:ui';
import 'package:flutter/material.dart';

extension FromBuildContext on BuildContext{

  /// warna warna yang ada di theme yang di define di [main()]
  ColorScheme get koiThemeColor{
    return Theme.of(this).colorScheme;
  }

  /// kumpulan textstyle untuk gigunakan agar tetap konsisten
  TextStyles get koiThemeText{
    return TextStyles(context: this);
  }

  /// breakpoint saat ini(ukuran device). Supaya bisa buat layout responsive
  ScreenBreakpoints get koiBreakpoint{
    return ScreenBreakpoint.getCurrentBreakpoint;
  }

  /// berbagai ukuran spacing antar element(padding dan margin) yang disarankan material design.
  SpacingSize get koiSpacing{
    return SpacingSize();
  }

}


/// Class untuk menyimpan daftar padding
///
/// **Note**
///
/// Berikut adalah daftar referensi dalam menentukan nilai-nilai di class ini (diurutkan dari yang terpenting)
///
/// * https://m3.material.io/foundations/layout/applying-layout/compact
/// * https://m3.material.io/foundations/layout/understanding-layout/spacing#64eb2223-f5e8-4d2a-9edc-9e3a7002220a
/// * https://m2.material.io/design/layout/spacing-methods.html#baseline-grid
class SpacingSize{
  /// nilainya 4, padding terkecil. Biasa untuk tambah padding ke komponen yang tidak perlu pading yang terlihat tapi tidak mau dempet sama elemen lain
  ///
  /// **Contoh Penggunaan**
  /// * Widget Avatar(foto profil)
  final double smallest = 4;

  /// nilainya 8, biasa digunakan untuk padding dari komponen-komponen di dalam sebuah widget yang merupakan satu kesatuan yang tidak dapat dipisah
  ///
  /// **Contoh Penggunaan**
  /// * Padding antar tiap card: https://m3.material.io/components/cards/specs#9abbced9-d5d3-4893-9a67-031825205f06
  /// * Padding vertical(atas bawah) dalam widget [TextField()] yang memisahkan label dengan border atas dan bawahnya
  final double small = 8;

  /// nilainya 12, biasa digunakan untuk padding dari komponen-komponen di dalam sebuah widget yang merupakan satu kesatuan yang tidak dapat dipisah dan padding [small] atau padding 8 masih terlalu kecil
  ///
  /// **Contoh Penggunaan**
  /// * Padding antara label dan border terluar sebuah [Button]
  final double medium = 16;

  /// nilainya 16, padding antara panel/widget dengan konteks berbeda. Biasa digunakan oleh perangkat layar kecil seperti mobile
  ///
  /// **Contoh Penggunaan**
  /// * Padding antara tepi layar dan widget pada mobile
  /// * Padding antar paragraf
  /// * Padding antar tombol
  final double large = 24;

  /// nilainya 24, padding antara panel/widget dengan konteks berbeda. Biasa digunakan oleh perangkat layar besar seperti desktop
  ///
  /// **Contoh Penggunaan**
  /// * Padding antara tepi layar dan widget pada desktop
  /// * Padding antar paragraf
  /// * Padding antar tombol
  final double xlarge = 32;

  final double xxlarge = 48;

  final double xxxlarge = 64;

  /// Otomatis pilih nilai padding antara ujung layar dan widget sesuai saran material design
  ///
  /// **Nilai yang dikembalikan**
  /// * kalau di mobile, fungsi ini akan mengembalikan nilai [SpacingSize().large]
  /// * selain mobile, fungsi ini akan mengembalikan nilai [SpacingSize().largest]
  double get autoPaddingScreen{
    switch(ScreenBreakpoint.getCurrentBreakpoint){
      case ScreenBreakpoints.phone:
        return small;
      case ScreenBreakpoints.tablet:
        return medium;
      case ScreenBreakpoints.laptop:
        return large;
      case ScreenBreakpoints.desktop:
        return xlarge;
    }
  }
  double get autoPaddingPane{
    switch(ScreenBreakpoint.getCurrentBreakpoint){
      case ScreenBreakpoints.phone:
        return small;
      case ScreenBreakpoints.tablet:
        return medium;
      case ScreenBreakpoints.laptop:
        return large;
      case ScreenBreakpoints.desktop:
        return xlarge;
    }
  }

  /// Otomatis pilih nilai padding antar pane/canvas/surface
  ///
  /// **Nilai yang dikembalikan**
  /// * kalau di mobile, fungsi ini akan mengembalikan nilai [SpacingSize().large]
  /// * selain mobile, fungsi ini akan mengembalikan nilai [SpacingSize().largest]
  double get autoBeetweenPane{
    switch(ScreenBreakpoint.getCurrentBreakpoint){
      case ScreenBreakpoints.phone:
        return large;
      case ScreenBreakpoints.tablet:
        return xlarge;
      case ScreenBreakpoints.laptop:
        return xxlarge;
      case ScreenBreakpoints.desktop:
        return xxxlarge;
    }
  }

  double get autoBetweenWidget{
    switch(ScreenBreakpoint.getCurrentBreakpoint){
      case ScreenBreakpoints.phone:
        return medium;
      case ScreenBreakpoints.tablet:
        return large;
      case ScreenBreakpoints.laptop:
        return xlarge;
      case ScreenBreakpoints.desktop:
        return xxlarge;
    }
  }

  /// padding antar card atau item di listview
  ///
  /// **Nilai yang dikembalikan**
  /// * small atau 8
  ///
  /// **Sumber**
  ///
  /// *https://m3.material.io/components/cards/specs#9abbced9-d5d3-4893-9a67-031825205f06*
  double get autoBetweenListItem{
    return small;
  }

  /// generate widget padding
  ///
  /// **Parameter**
  /// * direction : arah padding
  /// * value : nilai dari padding. Nilai defaultnya setara getter [autoBeetweenPane]
  Padding generateSpacing({
    required Axis direction,
    double? value
  }){
    if(value == null){
      value = this.autoBeetweenPane;
    }

    double vertical = 0;
    double horizontal = 0;
    if(direction == Axis.horizontal){
      horizontal = value;
    }
    else{
      vertical = value;
    }

    return Padding(padding: EdgeInsets.only(left: horizontal, top: vertical));
  }
}

class TextStyles{

  final BuildContext context;
  TextStyles({required this.context});

  /// untuk mendapat semua text style dari theme ini
  TextTheme getAllStyle(){
    return Theme.of(context).textTheme;
  }

  //======================================
  //daftar shortcut

  /// textstyle body dari theme ini
  TextStyle body({TextStyleSize size = TextStyleSize.Medium}){
    if(size == TextStyleSize.Small){
      return Theme.of(context).textTheme.bodySmall ?? TextStyle();
    }
    else if(size == TextStyleSize.Medium){
      return Theme.of(context).textTheme.bodyMedium ?? TextStyle();
    }
    else if(size == TextStyleSize.Large){
      return Theme.of(context).textTheme.bodyLarge ?? TextStyle();
    }
    else{
      throw AssertionError("KoiFromTextStyle Error");
    }
  }

  /// textstyle title dari theme ini
  TextStyle title({TextStyleSize size = TextStyleSize.Medium}){
    if(size == TextStyleSize.Small){
      return Theme.of(context).textTheme.titleSmall ?? TextStyle();
    }
    else if(size == TextStyleSize.Medium){
      return Theme.of(context).textTheme.titleMedium ?? TextStyle();
    }
    else if(size == TextStyleSize.Large){
      return Theme.of(context).textTheme.titleLarge ?? TextStyle();
    }
    else{
      throw AssertionError("KoiFromTextStyle Error");
    }
  }

  /// textstyle headline dari theme ini
  TextStyle headline({TextStyleSize size = TextStyleSize.Medium}){
    if(size == TextStyleSize.Small){
      return Theme.of(context).textTheme.headlineSmall ?? TextStyle();
    }
    else if(size == TextStyleSize.Medium){
      return Theme.of(context).textTheme.headlineMedium ?? TextStyle();
    }
    else if(size == TextStyleSize.Large){
      return Theme.of(context).textTheme.headlineLarge ?? TextStyle();
    }
    else{
      throw AssertionError("KoiFromTextStyle Error");
    }
  }

  /// textstyle display dari theme ini
  TextStyle display({TextStyleSize size = TextStyleSize.Medium}){
    if(size == TextStyleSize.Small){
      return Theme.of(context).textTheme.displaySmall ?? TextStyle();
    }
    else if(size == TextStyleSize.Medium){
      return Theme.of(context).textTheme.displayMedium ?? TextStyle();
    }
    else if(size == TextStyleSize.Large){
      return Theme.of(context).textTheme.displayLarge ?? TextStyle();
    }
    else{
      throw AssertionError("KoiFromTextStyle Error");
    }
  }

  /// textstyle label dari theme ini
  TextStyle label({TextStyleSize size = TextStyleSize.Medium}){
    if(size == TextStyleSize.Small){
      return Theme.of(context).textTheme.labelSmall ?? TextStyle();
    }
    else if(size == TextStyleSize.Medium){
      return Theme.of(context).textTheme.labelMedium ?? TextStyle();
    }
    else if(size == TextStyleSize.Large){
      return Theme.of(context).textTheme.labelLarge ?? TextStyle();
    }
    else{
      throw AssertionError("KoiFromTextStyle Error");
    }
  }
}

enum TextStyleSize{
  Small,
  Medium,
  Large
}

/// breakipoint untuk buat layout responsive
///
/// * phone = Extra-small
/// * tablet = Small
/// * laptop = Medium
/// * desktop = Large
///
/// Dibuat berdasarkan
///
/// *https://m2.material.io/design/layout/responsive-layout-grid.html#breakpoints*
enum ScreenBreakpoints{
  /// setara **Extra-small**
  phone,
  /// setara **Small**
  tablet,
  /// setara **Medium**
  laptop,
  /// setara **Large**
  desktop
}


class BreakpointRange{
  BreakpointRange({required this.min, required this.max});

  final double min;
  final double max;

  bool isWithinRange(double value){
    if(value>=min && value<=max){
      return true;
    }
    else{
      return false;
    }
  }

  bool operator >(BreakpointRange other) {
    if(this.max > other.max){
      return true;
    }
    else{
      return false;
    }
  }
  bool operator <(BreakpointRange other) {
    if(this.max < other.max){
      return true;
    }
    else{
      return false;
    }
  }
}
class ScreenBreakpoint{
  /// nama breakpoint dan ukuran maksimalnya.
  ///
  /// Nilai default didapat dari:
  /// * https://m2.material.io/design/layout/responsive-layout-grid.html#breakpoints
  /// * https://pub.dev/packages/layout
  static Map<BreakpointRange, ScreenBreakpoints> mapBreakpoint = {
    BreakpointRange(min: 0, max: 599): ScreenBreakpoints.phone,
    BreakpointRange(min: 600, max: 1239): ScreenBreakpoints.tablet,
    BreakpointRange(min: 1240, max: 1439): ScreenBreakpoints.laptop,
    BreakpointRange(min: 1440, max: double.infinity) : ScreenBreakpoints.desktop,
  };

  static ScreenBreakpoints get getCurrentBreakpoint{
    // start-ambil nilai dp
    // sumber https://stackoverflow.com/questions/49553402/how-to-determine-screen-height-and-width
    FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;
    Size size = view.physicalSize / view.devicePixelRatio;

    double screedWidth = size.width;
    // end---ambil nilai dp

    BreakpointRange storeLargestKey = BreakpointRange(min: 0, max: 0);
    mapBreakpoint.forEach((key, value) {

      if(key.isWithinRange(screedWidth)){
        if(storeLargestKey < key){
          storeLargestKey = key;
        }
      }
    });

    return mapBreakpoint[storeLargestKey] ?? ScreenBreakpoints.desktop;
  }
}