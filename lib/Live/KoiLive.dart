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
  KoiLive();
  KoiLive.run({required Future<dynamic> Function() request, required this.resultTransformer}){
    this._request = request;
    this.runRequest();
  }

  KoiLogic<KoiLiveResult<T>> _data = KoiLogic(KoiLiveResult(status: KoiLiveResultStatus.Loading, message: '', errors: []));
  /// last data yang di download disimpan di sini
  ///
  /// kalau mau render widget lebih bagus pakai [render()] karena ada fitur observer
  T? get data{
    if(_data.data.data != null){
      return _data.data.data;
    }
    return null;
}

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

  Future<dynamic> Function()? _request;
  Future<KoiLive<T>> runRequest() async {
    setStatus(KoiLiveResultStatus.Loading);

    if(_request == null){
      throw UnimplementedError("KoiLive.request belum diimplementasikan");
    }

    var waitRequest = await _request!();

    try{
      this._data.data = this.resultTransformer(waitRequest);
    }catch(error){
      this._data.data = KoiLiveResult(status: KoiLiveResultStatus.Error, message: '', errors: [AsyncError(error, StackTrace.current)]);
    }

    return this;
  }

  /// misalnya kan hasil request dari api itu json. bisa pakai ini untuk ubah hasil request dari json sesuai dengan tipe <T>
  KoiLiveResult<T> Function(dynamic) resultTransformer = (realResult){
    throw UnimplementedError("KoiLive.resultTransformer belum diimplementasikan");
  };

  void setStatus(KoiLiveResultStatus newStatus){
    var copyData = _data.data;
    copyData.status = newStatus;
    _data.data = copyData;
  }
}