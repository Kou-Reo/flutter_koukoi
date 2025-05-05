abstract class Pipe<T>{

  Pipe? _nextPipe;

  /// if in as T, then out as T
  void execute(T input, ){
    return _nextPipe?.execute(T);
  }
}