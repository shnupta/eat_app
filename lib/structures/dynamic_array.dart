import 'package:snacc/structures/exceptions.dart';

import 'dart:collection';

// This is my own List structure.

class DynamicArray<T> with IterableMixin<T> {
  List<T> _items;
  int _size;
  int _capacity;

  static const int _standardCapacity = 32;

  DynamicArray([int capacity = _standardCapacity]) {
    _items = List<T>(capacity);
    _size = 0;
    _capacity = capacity;
  }

  /// Returns the number of items inside the array.
  int get size => _size;

  /// Returns that maximum number of items this current array can hold, don't worry it will automatically
  /// resize!
  int get capacity => _capacity;

  /// Returns true if the array has no items.
  bool get isEmpty => _size == 0;

  Iterator<T> get iterator => _items.iterator;

  /// Accesses the element at [index]
  T operator [](int index) {
    return _items[index];
  }

  DynamicArray.fromList(List<T> list) {
    _items = List<T>(list.length);
    _size = list.length;
    _capacity = list.length;
    for(int i = 0; i < list.length; i++) {
      _items[i] = list[i];
    }
  }

  /// Adds [item] to the end of the array.
  void add(T item) {
    if(_size == _capacity) {
      _resize(capacity * 2);
    }

    _items[_size++] = item;
  }

  /// Inserts [item] at the front of the array.
  void prepend(T item) {
    insert(0, item);
  }

  /// Removes and returns the last element in the array.
  T pop() {
    if(_size == 0) throw new ArrayEmptyException();

    if(_size <= _capacity / 4) {
      _resize((_capacity / 2).round());
    }

    T retVal = _items[--_size];
    _items[_size] = null;

    return retVal;
  }

  /// Removes the item at [index] from the array.
  void delete(int index) {
    if(index < 0 || index >= _size) throw new NotInRangeException();

    if(_size <= _capacity / 4) {
      _resize((_capacity / 2).round());
    }

    _items[index] = null;

    for(int i = index; i < _size; i++) {
      _items[i] = _items[i+1];
    }

    _size--;
  }

  /// Removes the first instance of [item] in the array.
  void remove(T item) {
    for(int i = 0; i < _size; i++) {
      if(_items[i] == item) {
        delete(i);
        return;
      }
    }
  }

  /// Returns the index of the first instance of [item] in the array.
  /// If it isn't present, -1 is returned.
  int find(T item) {
    for(int i = 0; i < _size; i++) {
      if(_items[i] == item) return i;
    }

    return -1;
  }

  /// Inserts [item] at the specified [index] in the array.
  void insert(int index, T item) {
    if(index < 0 || index > size) throw new NotInRangeException();

    if(_size == _capacity) _resize(_capacity * 2);

    for(int i = _size -1; i >= index; i--) {
      _items[i+1] = _items[i];
    }

    _items[index] = item;

    _size++;
  }

  /// Copies the old array into a new array with capaity of [newCapacity].
  void _resize(int newCapacity) {
    if(newCapacity <= 0) throw new InvalidCapacityException();
    List<T> newItems = List<T>(newCapacity);
    int topLim = (newCapacity < _capacity) ? newCapacity : _capacity;
    for(int i = 0; i < topLim; i++) {
      newItems[i] = _items[i];
    }

    _items = newItems;
  }

}