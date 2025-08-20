import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_koukoi/Logic/KoiLogic.dart';
import 'KoiLiveResult.dart';
import 'KoiLiveWg.dart';

class KoiLive<T>{
  /// sebelum pakai harus masukkan isi [request()] dan [resultTransformer()] lebih dulu
  ///
  /// kalau gak mau isi [request()] dan [resultTransformer()], pakai [KoiLive.run()]
  KoiLive({this.cacheLastSuccess = false});
  KoiLive.run({this.cacheLastSuccess = false, required Future<dynamic> Function() request, required this.resultTransformer}){
    this._request = request;
    this.requestRun();
  }


  //start-getter🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒
  /// last data yang di download disimpan di sini
  ///
  /// kalau mau render widget lebih bagus pakai [render()] karena ada fitur observer
  T? get data{
    if(_data.data.data != null){
      return _data.data.data;
    }
    return null;
  }

  /// status request saat ini
  KoiLiveResultStatus get status{
    return _data.data.status;
  }
  //end---getter🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒

  //start-callback🥂🥂🥂🥂🥂🥂🥂🥂🥂🥂🥂🥂🥂🥂🥂🥂🥂🥂🥂🥂🥂🥂🥂🥂🥂🥂🥂🥂🥂🥂

  // GLOBAL CALLBACK🐣

  /// dipanggil saat [requestRun()] mereturn status [KoiLiveResultStatus.Success]
  static void Function(KoiLiveResult) OnSuccess = (data){};
  /// dipanggil saat [requestRun()] mereturn status [KoiLiveResultStatus.Error]
  static void Function(KoiLiveResult) OnError = (data){};
  /// dipanggil saat [requestRun()] mereturn status [KoiLiveResultStatus.Warning]
  static void Function(KoiLiveResult) OnWarning = (data){};
  /// dipanggil saat [requestRun()] mereturn status [KoiLiveResultStatus.Info]
  static void Function(KoiLiveResult) OnInfo = (data){};
  /// dipanggil saat [requestRun()] mereturn status [KoiLiveResultStatus.Loading]
  static void Function(KoiLiveResult) OnLoading = (data){};

  // LOCAL CALLBACK🐓

  /// dipanggil saat [requestRun()] mereturn status [KoiLiveResultStatus.Success]
  void Function(KoiLiveResult<T>) onSuccess = (data){OnSuccess(data);};
  /// dipanggil saat [requestRun()] mereturn status [KoiLiveResultStatus.Error]
  void Function(KoiLiveResult<T>) onError = (data){OnError(data);};
  /// dipanggil saat [requestRun()] mereturn status [KoiLiveResultStatus.Warning]
  void Function(KoiLiveResult<T>) onWarning = (data){OnWarning(data);};
  /// dipanggil saat [requestRun()] mereturn status [KoiLiveResultStatus.Info]
  void Function(KoiLiveResult<T>) onInfo = (data){OnInfo(data);};
  /// dipanggil saat [requestRun()] mereturn status [KoiLiveResultStatus.Loading]
  void Function(KoiLiveResult<T>) onLoading = (data){OnLoading(data);};
  //end---callback🥂🥂🥂🥂🥂🥂🥂🥂🥂🥂🥂🥂🥂🥂🥂🥂🥂🥂🥂🥂🥂🥂🥂🥂🥂🥂🥂🥂🥂🥂

  //start-method🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚

  /// untuk menjalankan request.
  ///
  /// Bisa juga dipakai untuk **reload request** tinggal panggil fungsi ini, request akan tereload
  ///
  /// kalo pakai konstruktor [KoiLive.run()], fungsi ini sudah otomatis terpanggil
  ///
  /// **NOTE**
  /// Kalau ada request yang sedang berlangsung. permintaan request ini akan dibatalkan dan data saat ini akan langsung di return
  Future<KoiLive<T>> requestRun({IfThereRequestOnProgress ifThereRequestOnProgress = IfThereRequestOnProgress.WaitAndReturnFirstRequest}) async {

    if(ifThereRequestOnProgress == IfThereRequestOnProgress.CancelThisRequest){
      return this;
    }
    else if(ifThereRequestOnProgress == IfThereRequestOnProgress.WaitAndReturnFirstRequest){
      await requestWait();
      return this;
    }
    else if(ifThereRequestOnProgress == IfThereRequestOnProgress.KeepExecutingThisRequest){
      // do nothing...
    }else{
      throw UnimplementedError("ifThereRequestOnProgress belum diimplementasikan");
    }

    _setStatus(KoiLiveResultStatus.Loading);
    // mulai panggil callback isLoading
    _callCallbackStatus();

    // Reset the completer at the beginning of the request
    _requestCompleter = Completer<void>();

    if(_request == null){
      _requestCompleter.completeError(UnimplementedError("KoiLive.request belum diimplementasikan"));
      throw UnimplementedError("KoiLive.request belum diimplementasikan");
      // ---------------------
    }

    var waitRequest = await _request!();

    var previousData = this._data.data.data;
    try{
      var tempData = this.resultTransformer(waitRequest);
      if(tempData.status == KoiLiveResultStatus.Loading){
        tempData.status = KoiLiveResultStatus.Error;
        tempData.errors.add(AssertionError('Status setelah request selesai tidak boleh "KoiLiveResultStatus.Loading"'));
        tempData.message = 'Status setelah request selesai tidak boleh "KoiLiveResultStatus.Loading"';
      }
      this._data.data = tempData;
      _requestCompleter.complete();
      // ---------------------
    }catch(error){
      this._data.data = KoiLiveResult(status: KoiLiveResultStatus.Error, message: '', errors: [AsyncError(error, StackTrace.current)]);
      _requestCompleter.completeError(error);
      // ---------------------
    }

    // kalau request gagal, data tidak di update
    if(cacheLastSuccess && this._data.data.data == null && previousData != null){
      this._data.data.data = previousData;
    }

    // loading selesai panggil callback lain
    _callCallbackStatus();

    return this;
  }

  /// panggil fungsi ini untuk tunggu semua fungsi [requestRun()] selesai
  ///
  /// misalnya di splash screen, aku gak mau lanjut sampai requestRun() selesai. jadi pake ini untuk tahu apa request selesai atau tidak
  ///
  /// bisa aja pakai look cek apa status request masih loading, tapi ini lebih mudah dipakai kan, cuma 1 line
  Future<void> requestWait() {
    return _requestCompleter.future;
  }

  // GLOBAL RENDERER 🐣

  /// widget yang di render kalau request masih berjalan
  static Widget Function() RenderOnLoad = (){
    return CircularProgressIndicator();
  };
  /// widget yang di render kalau request error
  static Widget Function(List<Error>) RenderOnError = (error){
    return Text(error[0].toString());
  };

  // LOCAL RENDERER 🐓
  /// widget yang di render kalau request masih berjalan
  Widget Function() renderOnLoad = (){
    return RenderOnLoad();
  };
  /// widget yang di render kalau request error
  Widget Function(List<Error>) renderOnError = (error){
    return RenderOnError(error);
  };

  /// render widget yang di masukkan
  ///
  /// kalau request masih loading, atau error, akan otomatis menampilkan [renderOnLoad] dan [renderOnError]
  KoiLiveWg<T> render(Widget Function(T) renderWidget){
    return KoiLiveWg(data: this._data, renderWidget: renderWidget, renderOnError: renderOnError, renderOnLoad: renderOnLoad);
  }
  //end---method🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚

  Completer<void> _requestCompleter = Completer<void>();

  KoiLogic<KoiLiveResult<T>> _data = KoiLogic(KoiLiveResult(status: KoiLiveResultStatus.Loading, message: '', errors: []));

  Future<dynamic> Function()? _request;

  /// misalnya kan hasil request dari api itu json. bisa pakai ini untuk ubah hasil request dari json sesuai dengan tipe <T>
  KoiLiveResult<T> Function(dynamic) resultTransformer = (realResult){
    throw UnimplementedError("KoiLive.resultTransformer belum diimplementasikan");
  };

  void _setStatus(KoiLiveResultStatus newStatus){
    var copyData = _data.data;
    copyData.status = newStatus;
    _data.data = copyData;
  }

  void _callCallbackStatus(){
    switch(_data.data.status){
      case KoiLiveResultStatus.Success:
        onSuccess(_data.data);
        break;
      case KoiLiveResultStatus.Error:
        onError(_data.data);
        break;
      case KoiLiveResultStatus.Warning:
        onWarning(_data.data);
        break;
      case KoiLiveResultStatus.Info:
        onInfo(_data.data);
        break;
      case KoiLiveResultStatus.Loading:
        onLoading(_data.data);
        break;
    }
  }

  /// kalau [true], kalau request gagal, data tidak di update
  ///
  /// kalau [false], kalau request gagal, ya data jadi null
  bool cacheLastSuccess;
}


enum IfThereRequestOnProgress{
  /// langsung membatalkan request
  CancelThisRequest,
  /// tunggu request sebelumnya selesai dan return hasil request itu
  WaitAndReturnFirstRequest,
  /// tetap eksekusi request ini. pastikan request ini dan request sebelumnya adalah request yang berbeda ^_^
  KeepExecutingThisRequest
}