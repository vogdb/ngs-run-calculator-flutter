import 'dart:convert' show json;

import 'package:flutter/foundation.dart';

import 'bp.dart';

List<SeqPlatform> loadSeqPlatformList(jsonText) {
  var jsonData = json.decode(jsonText);
  return [for (var j in jsonData) SeqPlatform.fromJson(j)];
}

class SeqPlatform {
  late final String name;
  late final List<SeqPlatformMode> modes;

  SeqPlatform.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    modes = <SeqPlatformMode>[for (var mode in json['modes']) SeqPlatformMode.fromJson(mode)];
  }

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) => other is SeqPlatform && other.name == name;

  @override
  int get hashCode => name.hashCode;
}

class SeqPlatformMode {
  late final String name;
  late final List<SeqPlatformParams> params;

  SeqPlatformMode.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    params = [for (var rp in json['read_params']) SeqPlatformParams.fromJson(rp)];
  }

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) => other is SeqPlatformMode && other.name == name;

  @override
  int get hashCode => name.hashCode;
}

class SeqPlatformParams {
  late final int len;
  late final int end;
  late final BP yield;

  SeqPlatformParams.fromJson(Map<String, dynamic> json) {
    len = json['len'];
    end = json['end'];
    yield = BP(json['yield']);
  }

  @override
  String toString() => '${len}x$end, $yield';

  @override
  bool operator ==(Object other) => other is SeqPlatformParams && other.yield == yield;

  @override
  int get hashCode => Object.hash(len, end, yield.hashCode);
}

class SelectedSeqPlatform extends ChangeNotifier {
  SeqPlatform? _platform;
  SeqPlatformMode? _mode;
  SeqPlatformParams? _params;

  SeqPlatform? get platform => _platform;

  set platform(SeqPlatform? platform) {
    if (_platform != platform) {
      _platform = platform;
      mode = null;
      notifyListeners();
    }
  }

  SeqPlatformMode? get mode => _mode;

  set mode(SeqPlatformMode? mode) {
    if (_mode != mode) {
      _mode = mode;
      params = null;
      notifyListeners();
    }
  }

  SeqPlatformParams? get params => _params;

  set params(SeqPlatformParams? params) {
    if (_params != params) {
      _params = params;
      notifyListeners();
    }
  }
}
