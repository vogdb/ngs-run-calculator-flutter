import 'dart:collection';
import 'dart:convert' show json;
import 'package:flutter/material.dart' show Color;
import 'package:flutter/foundation.dart';

import 'BP.dart';

List<SampleType> loadSampleTypeList(jsonText) {
  var jsonData = json.decode(jsonText);
  return [for (var j in jsonData) SampleType.fromJson(j)];
}

class SampleType {
  late final String id;
  late final String name;

  SampleType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}

class Sample {
  String? type;
  int? num;
  int? coverage;
  bool isCoverageX = true;
  BP? size;
  late final Color color;
}

const List<Color> _colors = [
  Color(0xff4281a4),
  Color(0xffd4b483),
  Color(0xff48a9a6),
  Color(0xffc1666b),
  Color(0xff63a332),
  Color(0xff995d81),
  Color(0xffffa57c),
  Color(0xff12c1ff),
  Color(0xffffbbff),
];

class SelectedSamples extends ChangeNotifier with IterableMixin<Sample> {
  final List<Sample> _samples = [];

  void add(Sample s) {
    if (_samples.isEmpty) {
      s.color = _colors[0];
    } else {
      var lastColor = _samples.last.color;
      s.color = _colors[(_colors.lastIndexOf(lastColor) + 1) % _colors.length];
    }
    _samples.add(s);
    notifyListeners();
  }

  void remove(Sample s) {
    _samples.remove(s);
    notifyListeners();
  }

  /// `notifyListeners` can't be used directly outside of the class, so `update` is used
  /// to notify listeners when an item of samples is updated.
  void update() {
    notifyListeners();
  }

  @override
  Iterator<Sample> get iterator {
    return _samples.iterator;
  }
}