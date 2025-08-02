import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_koukoi/Logic/KoiLogic.dart';

import 'KoiLiveResult.dart';
import 'KoiLiveWg.dart';

class KoiLive<T>{

  KoiLogic<KoiLiveResult<T>> _data = KoiLogic(KoiLiveResult(status: KoiLiveResultStatus.Loading, message: '', errors: []));

  Widget Function() renderOnLoad = (){
    return CircularProgressIndicator();
  };
  Widget Function(List<Error>) renderOnError = (error){
    return Text(error[0].toString());
  };
  KoiLiveWg<T> render(Widget Function(T) renderWidget){
    return KoiLiveWg(data: this._data, renderWidget: renderWidget, renderOnError: renderOnError, renderOnLoad: renderOnLoad);
  }

  void Function(KoiLogic<T?>) onSuccess = (data){};
  void Function(KoiLogic<T?>) onError = (data){};
  void Function(KoiLogic<T?>) onWarning = (data){};
  void Function(KoiLogic<T?>) onInfo = (data){};

  Future<dynamic> Function()? _lastRequest;
  Future<KoiLive<T>> request(Future<dynamic> Function() requestFn) async {
    setStatus(KoiLiveResultStatus.Loading);

    // store the function, not the result
    _lastRequest = requestFn;

    var waitRequest = await requestFn();

    try{
      this._data.data = this.resultTransformer(waitRequest);
    }catch(error){
      this._data.data = KoiLiveResult(status: KoiLiveResultStatus.Error, message: '', errors: [AsyncError(error, StackTrace.current)]);
    }

    return this;
  }

  /// kalo mau request ulang tanpa perlu ngetik request lagi. akan menjalankan perintah request terakhir
  Future<KoiLive<T>> reload()async{
    if(_lastRequest != null){
      return await request(_lastRequest!);
    }

    throw AssertionError("Belum pernah ada request. Buat request dengan  fungsi request()");
  }

  KoiLiveResult<T> Function(dynamic) resultTransformer = (realResult){
    throw UnimplementedError("KoiLive.resultTransformer belum diimplementasikan");
  };

  void setStatus(KoiLiveResultStatus newStatus){
    var copyData = _data.data;
    copyData.status = newStatus;
    _data.data = copyData;
  }
}