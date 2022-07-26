import 'dart:collection';
import 'dart:convert' show json;

import 'package:flutter/material.dart';

import './bp.dart';

List<SampleType> loadSampleTypeList(jsonText) {
  return [for (var j in json.decode(jsonText)) SampleType.fromJson(j)];
}

class SampleType {
  late String name;
  late bool isCoverageX;
  String? sizeLabel;

  SampleType.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    isCoverageX = json['isCoverageX'];
    sizeLabel = json['sizeLabel'];
  }

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) => other is SampleType && other.name == name;

  @override
  int get hashCode => name.hashCode;
}

class Sample {
  SampleType? type;
  int? num;
  int? coverage;
  BP? size;
  late final Color color;
}

const List<Color> _colors = [
  Color(0xff6FB2D2),
  Color(0xffEBD671),
  Color(0xffF68989),
  Color(0xff85C88A),
  Color(0xffffa57c),
  Color(0xff995d81),
];

typedef RemovedItemBuilder = Widget Function(
    Sample sample, BuildContext context, Animation<double> animation);

class SelectedSamples extends ChangeNotifier with IterableMixin<Sample> {
  SelectedSamples({
    required RemovedItemBuilder removedItemBuilder,
    required GlobalKey<AnimatedListState> listKey,
  }) : _removedItemBuilder = removedItemBuilder,
        _listKey = listKey;

  final List<Sample> _samples = [];
  final GlobalKey<AnimatedListState> _listKey;
  final RemovedItemBuilder _removedItemBuilder;

  @override
  int get length => _samples.length;

  GlobalKey<AnimatedListState> get listKey => _listKey;

  void add(Sample s) {
    if (_samples.isEmpty) {
      s.color = _colors[0];
    } else {
      var lastColor = _samples.last.color;
      s.color = _colors[(_colors.lastIndexOf(lastColor) + 1) % _colors.length];
    }
    final int index = _samples.length;
    _samples.add(s);
    _listKey.currentState!.insertItem(index, duration: const Duration(seconds: 1));
    notifyListeners();
  }

  void remove(Sample s) {
    final int index = _samples.indexOf(s);
    _samples.remove(s);
    _listKey.currentState!.removeItem(
      index,
          (BuildContext context, Animation<double> animation) {
        return _removedItemBuilder(s, context, animation);
      },
      duration: const Duration(seconds: 1),
    );
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
