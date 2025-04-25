import 'dart:async';

abstract class KoiLogicStrategy<T>{
  FutureOr<T> execute(T data);
}

/// sama kek [KoiLogicStrategy] tapi disini user harus implement [undo()]
///
/// **kenapa harus implement undo?**
/// - coba misalnya commandnya kirim request ke api, kan gak bisa pake undo default untuk ubah data di api itu
/// - kelebihan lainnya aplikasi jadi pakai lebih sedikit memory. Soalnya kan undo perlu simpan data sebelumnya. Dengan implementasi [undo()] program ini tidak akan menyimpan data, hanya menyimpan bagaimana menjalankan perintah undonya
abstract class KoiLogicStrategyUndoable<T> implements KoiLogicStrategy<T>{
  /// kebalikan dari [execute()]. kalau [execute()] `1+1`, maka [undo()] `1-1`
  FutureOr<T> undo(T data){
    throw UnimplementedError();
  }
}