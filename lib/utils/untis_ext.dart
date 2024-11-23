import 'dart:convert';

import 'jd_convert.dart';

const String kItems = 'items';
const String kList = 'list';

extension ListNullAbleExtension<E> on List<E>? {
  bool get isNotEmptyNullable {
    return (this ?? []).isNotEmpty;
  }

  bool get isEmptyNullable {
    return (this ?? []).isEmpty;
  }

  int get lengthNullable {
    return (this != null ? (this?.length ?? 0) : 0);
  }
}


extension StringExtension on String? {
  /// String 空安全处理
  String get notNull => this ?? '';

  bool get isEmptyNullAble => (this ?? '').isEmpty;

  bool get isNotEmptyNullAble => (this ?? '').isNotEmpty;
}

typedef ListIndexFunction<E, R> = R Function(int index, E element);
typedef MapIndexFunction<K, V, R> = R Function(
    int index, MapEntry<K, V> element);

extension ListExtension<E> on List<E> {
  Iterable<R> mapIndex<R>(ListIndexFunction<E, R> function) {
    List<R> list = [];
    List.generate(length, (index) {
      list.add(function.call(index, this[index]));
    });
    return list;
  }

  E? get(int index) {
    if (index < 0 || length == 0 || index >= length) return null;
    return this[index];
  }

  int get lastIndex => isEmpty ? -1 : length - 1;

  toJson() => json.encode(this);
}

extension MapExtension<K, V> on Map<K, V> {
  V? get(K? key) => this[key];

  String getStringNotNull(String key) {
    V? value = this[key];
    if (value != null && value is String) {
      return value;
    } else {
      return JDConvert.asStringNotNull(value);
    }
  }

  Map<String, dynamic> stringDynamicMap() {
    return Map<String, dynamic>.from(this);
  }

  List getListNotNull(String key) {
    V? value = this[key];
    if (value != null && value is List) {
      return value;
    } else {
      return [];
    }
  }

  List getItemsListNotNull() {
    Map<String, dynamic> map = this.getMapNotNull(kItems);
    return map.getListNotNull(kList);
  }

  Map<String, dynamic> getMapNotNull(String key) {
    V? value = this[key];
    if (value != null && value is Map) {
      return Map<String, dynamic>.from(value);
    } else {
      return {};
    }
  }

  int getIntNotNull(String key) {
    V? value = this[key];
    if (value != null && value is int) {
      return value;
    } else {
      return JDConvert.asIntNotNull(value);
    }
  }

  bool getBoolNotNull(String key) {
    V? value = this[key];
    return JDConvert.asBoolNotNull(value);
  }

  double getDoubleNotNull(String key) {
    V? value = this[key];
    if (value != null && value is double) {
      return value;
    } else {
      return JDConvert.asDoubleNotNull(value);
    }
  }


  toJson() => json.encode(this);
}
