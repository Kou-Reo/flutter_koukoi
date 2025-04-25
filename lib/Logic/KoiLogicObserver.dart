import 'KoiLogic.dart';

class KoiLogicObserver<T>{

  static int _last_id = 0;

  /// berguna untuk mengidentifikasi observer
  final int _key;

  /// yang observer jalankan kalau data berubah
  final Function(KoiLogic<T> logic) onUpdate;
  KoiLogicObserver({required this.onUpdate}) : _key = _last_id++;

  //start-overrride operator == supaya observer bisa di remove dengan baik
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is KoiLogicObserver &&
              runtimeType == other.runtimeType &&
              _key == other._key; // Only compare based on name

  @override
  int get hashCode => _key.hashCode; // Hash code should be consistent with ==
  //end---start-overrride operator == supaya observer bisa di remove dengan baik
}