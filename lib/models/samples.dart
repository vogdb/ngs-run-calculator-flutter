import 'dart:collection';
import 'dart:convert' show json;
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
  int? id;
  String? type;
  int? num;
  int? coverageX;
  int? coverageNumReads;
  BP? size;
  int? colorHex;

  String get coverage {
    var coverage = coverageX != null ? 'x$coverageX' : '';
    return (coverageNumReads ?? coverage).toString();
  }
}

class SelectedSamples extends ChangeNotifier with IterableMixin<Sample> {
  final List<Sample> _samples = [];

  void add(Sample s) {
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
