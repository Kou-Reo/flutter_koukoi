class BoundedStack<T> {
  final int _capacity;
  final List<T> _items = [];

  List<T> toList(){
    return _items;
  }

  BoundedStack({required int maxCapacity}): this._capacity = maxCapacity{
    if (_capacity <= 0) {
      throw ArgumentError("Capacity must be a positive integer.");
    }
  }

  void clear(){
    _items.clear();
  }

  void push(T item) {
    _items.add(item);
    if (_items.length > _capacity) {
      _items.removeAt(0); // Remove the oldest element (at index 0)
    }
  }

  T pop() {
    if (_items.isEmpty) {
      throw StateError("Cannot pop from an empty stack.");
    }
    return _items.removeLast();
  }

  T get peek {
    if (_items.isEmpty) {
      throw StateError("Cannot peek at an empty stack.");
    }
    return _items.last;
  }

  int get length => _items.length;

  bool get isEmpty => _items.isEmpty;

  bool get isFull => _items.length == _capacity;

  @override
  String toString() => _items.toString();
}
