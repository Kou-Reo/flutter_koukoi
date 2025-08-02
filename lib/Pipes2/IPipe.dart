// pipe       flow biasa(satu input satu output)
// switch:    split data(satu input beberapa output. bisa kirim hanya ke satu output dan abaikan output lain atau kirim ke semua output)
// terminal:  merge data(beberapa input satu output. bisa cache input atau pilih default. hanya out data kalau semua input udah dikumpulkan kecuali ada input nullable)


//==============
//input:      bisa static, bisa event. input static selalu kasih data saat event trigger di terminal yang sama masuk
//output:     bisa cache bisa event. output cache, meski dia dari input event akan behave kayak input static di input pipe selanjutnya. output event hanya ommit data kalau memang pipe ini menghasilkan data
//NOTE: keknya pake cache aja deh dari static. kan input static sama juga dengan cache dia gapernah berubah

import 'package:flutter/cupertino.dart';

interface class ISocket<T>{

  ISocket({this.data, this.defaultValue, required this.nama});

  /// data yang ada di socket ini
  T? data;
  /// data yang di emmit socket ini kalau data null
  T? defaultValue;

  /// nama socket ini
  String nama;

  Type get dataType{
    return T;
  }

}

class InputSocket<T> extends ISocket<T>{

  InputSocket({required this.onReceive, required super.nama, super.defaultValue});

  /// fungsi ini dipanggil saat data masuk ke socket
  Function(T) onReceive;
}

class OutputSocket<T> extends ISocket<T>{
  InputSocket<T>? emmitTo;

  /// emmit last data when other socket emmit its data
  bool isCache = false;

  OutputSocket({required super.nama, super.defaultValue});

  /// emmit data in this socket to next input socket
  void emmit(){
    emmitTo?.data = this.data;
    emmitTo?.onReceive(this.data!);
  }
}

interface class Ipipe{

  Ipipe({required this.input, required this.output});

  List<InputSocket> input;
  List<OutputSocket> output;

  void ommit(){

  }

  @mustCallSuper
  void process(){
    ommit();
  }
}

//CONTOH
// 1. kalo maintenance tampilkan pesan maintenance
// 2. selain itu app jalan kek biasa

class IsMaintenance extends Ipipe{
  @override
  List<InputSocket> input = [
    InputSocket<bool>(onReceive: (bool value) {  }, nama: 'IsMaintenance', defaultValue: false)
  ];

  @override
  List<OutputSocket> output = [

  ];

  IsMaintenance({required super.input, required super.output});

  @override
  void process() {
    super.process();
  }

}