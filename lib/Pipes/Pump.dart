import 'package:flutter/foundation.dart';
import 'package:flutter_koukoi/Pipes/Pipe.dart';

abstract class Pump<T>{

  @protected
  T? _output;

  @protected
  T? get output{
    return _output;
  }

  @protected
  set output(T? data){
    _output = data;
  }

  @protected
  Pipe? _nextPipe;

  @protected
  set nextPipe(Pipe next){
    _nextPipe = next;
  }

  @protected
  FlowState _flowState = FlowState.loading;

  @protected
  FlowState get flowState{
    return _flowState;
  }

  @protected
  set flowState(FlowState data){
    _flowState = data;
  }

  void start(dynamic parameter){
    if(_nextPipe == null){
      throw StateError("next pipe belum di set");
    }

    _nextPipe!.execute(parameter);
  }

}

enum FlowState{
  loading,
  finish,
  error,
  forbidden
}