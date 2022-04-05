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
  int? coverageX;
  int? coverageNumReads;
  BP? size;
  late final Color color;

  String get coverage {
    var coverage = coverageX != null ? 'x$coverageX' : '';
    return (coverageNumReads ?? coverage).toString();
  }
}

const List<Color> _colors = [
  Color(0xff4281a4),
  Color(0xffd4b483),
  Color(0xff48a9a6),
  Color(0xffc1666b),
  Color(0xff63a332),
  Color(0xff995d81),
  Color(0xfffff07c),
  Color(0xff87f1ff),
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

  @override
  Iterator<Sample> get iterator {
    return _samples.iterator;
  }
}
