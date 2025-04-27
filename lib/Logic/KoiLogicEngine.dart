import 'dart:async';
import 'KoiLogic.dart';

abstract interface class KoiLogicEngine<T>{
  List<KoiLogicEngine<T>> _nextEngine = [];
  List<KoiLogicEngine<T>> get nextEngine{
    return nextEngine;
  }
  List<bool Function(T)> _executionCondition = [];

  /// - misalnya aku run engineA.start()
  /// - origin akan berisi data engineA.
  /// - lalu semua engine setelah engineA juga akan berisi engineA
  /// - terus pas engineA.stop(), kalo engine saat ini originnya engineA, maka request tidak akan dijalankan
  KoiLogicEngine<T>? origin;

  void addNext({required KoiLogicEngine<T> nextGear, required bool Function(T) executionCondition}){
    _nextEngine.add(nextGear);
    _executionCondition.add(executionCondition);
  }

  FutureOr<void> execute(KoiLogic<T> data);
}