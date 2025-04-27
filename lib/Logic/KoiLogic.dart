import 'package:flutter_koukoi/Type/BoundedStack.dart';
import 'KoiLogicEngine.dart';
import 'KoiLogicObserver.dart';
import 'KoiLogicStrategy.dart';

class KoiLogic<T>{
  T _data;
  T get data => _data;
  set data(T value) {
    _data = value;
    observersNotify();
  }

  KoiLogic(this._data);

  //start-implementasi design pattern Singleton🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄
  static List<dynamic> _singleton = [];
  static KoiLogic<T> singleton<T>({T? data}){
    for(int x =0; x< _singleton.length; x++){
      if(_singleton[x] is T){
        return KoiLogic(_singleton[x]);
      }
    }
    if(data != null){
      _singleton.add(data);
      return KoiLogic(data);
    }

    throw AssertionError("Singleton belum diinisialisasi. Gunakan fungsi ini dan pass data di parameternya untuk menginisialisasi `KoiLogic.singleton(data: new YouData())`");
  }
  //end---implementasi design pattern Singleton🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄

  //start-implementasi design pattern strategy🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅
  KoiLogicStrategy<T>? _strategy;
  set strategy(KoiLogicStrategy<T>? strategy){
    _strategy = strategy;
  }
  Future<void> execute()async{

    // kalo di execute, pastikan redo stack di clear
    _undoHistory.clear();

    var previously = _data;

    var exeres = _strategy!.execute(_data);
    if(exeres is Future<T>){
      data = await exeres;
    }
    else{
      data = exeres;
    }

    if(_strategy != null){
      if(_strategy! is KoiLogicStrategyUndoable){
        _strategyHistory.push(_Snapshot(_strategy!, null, null));
      }else{
        _strategyHistory.push(_Snapshot(_strategy!, previously, _data));
      }
    }
  }
  //end---implementasi design pattern strategy🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅🥅

  //start-implementasi design pattern Observer👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀
  final List<KoiLogicObserver<T>> _observers = [];

  /// bisa juga pakai [observe()] biar lebih ringkas gak perlu init observernya langsung pass onUpdate
  void observerAdd(KoiLogicObserver<T> observer) {
    _observers.add(observer);
  }

  void observersNotify() {
    for (var observer in _observers) {
      observer.onUpdate(this);
    }
  }

  void observerRemove(KoiLogicObserver<T> observer) {
    _observers.remove(observer);
  }
  void observerRemoveAll(){
    _observers.clear();
  }

  /// this return the observer. dont forget to pass the returned value to [observerRemove()] to properly dispose it
  ///
  /// bisa juga pakai [observerAdd()]
  KoiLogicObserver<T> observe({required Function(KoiLogic<T> logic) onUpdate}){
    var observer = KoiLogicObserver<T>(
        onUpdate: (logic){
          onUpdate(logic);
        }
    );
    observerAdd(observer);
    return observer;
  }
  //end---implementasi design pattern Observer👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀👀

  //start-implementasi design pattern command🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖
  BoundedStack<_Snapshot<T>> _strategyHistory = BoundedStack(maxCapacity: 20);
  BoundedStack<_Snapshot<T>> _undoHistory = BoundedStack(maxCapacity: 20);

  Future<void> undo() async {
    var previoudData = _strategyHistory.pop();

    if(previoudData.previous != null){
      this.data = previoudData.previous!;
    }else{
      var exeres = (previoudData.strategy as KoiLogicStrategyUndoable<T>).undo(_data);
      if(exeres is Future<T>){
        this.data = await exeres;
      }
      else{
        this.data = exeres;
      }
    }

    _undoHistory.push(previoudData);
  }
  Future<void> redo() async {

    var previoudData = _undoHistory.pop();

    if(previoudData.next != null){
      this.data = previoudData.next!;
    }else{
      var exeres = previoudData.strategy.execute(_data);
      if(exeres is Future<T>){
        this.data = await exeres;
      }
      else{
        this.data = exeres;
      }
    }

    _strategyHistory.push(previoudData);
  }

  bool canUndo(){
    return !_strategyHistory.isEmpty;
  }
  bool canRedo(){
    return !_undoHistory.isEmpty;
  }
  //end---implementasi design pattern command🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖

  //start-implementasi design pattern chain of responsibility🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝
  List<KoiLogicEngine<T>> _listEngine = [];
  void engineAdd(KoiLogicEngine<T> engine){
    _listEngine.add(engine);
  }

  List<KoiLogicEngine<T>> _executionQueue = [];
  Future<void> _executeEngineStream() async{
    List<KoiLogicEngine<T>> nextExecution = [];
    for (var enEngine in _executionQueue) {
      await enEngine.execute(this);

      for (var anNextEngine in enEngine.nextEngine) {
        anNextEngine.origin = enEngine.origin;
      }

      nextExecution.addAll(enEngine.nextEngine);
    }
    //todo masih salah, harusnya cuma clear yang originnya sama
    _executionQueue.clear();
    _executionQueue.addAll(nextExecution);
  }
  Future<void> engineStart(KoiLogicEngine<T> targetEngine) async {

    targetEngine.origin = targetEngine;
    _executionQueue.add(targetEngine);

    while(_executionQueue.isNotEmpty){
      await _executeEngineStream();
    }
  }
  //todo masih belum ada jaminan semua engine bakal stop pas panggil ini
  //todo mungkin bagusan buat pause all engine?
  void engineStopAll(){
    _executionQueue.clear();
  }
  //end---implementasi design pattern chain of responsibility🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝🥝
}

// todo find a way to store state more efficient([previous] and [next])
class _Snapshot<T>{
  final KoiLogicStrategy<T> strategy;
  /// kalo strategy undoable ini null
  ///
  /// ini cuma diisi kalo strategy gak tahu cara undo(untuk restore sebagai memento)
  ///
  /// data sebelum eksekusi
  final T? previous;

  /// kalo strategy undoable ini null
  ///
  /// ini cuma diisi kalo strategy gak tahu cara undo(untuk restore sebagai memento)
  ///
  /// data setelah eksekusi
  final T? next;

  _Snapshot(this.strategy, this.previous, this.next);
}