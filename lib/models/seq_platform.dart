import 'dart:convert' show json;

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
}

class SeqPlatformMode {
  late final String name;
  late final List<SeqPlatformParams> params;

  SeqPlatformMode.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    params = [for (var rp in json['read_params']) SeqPlatformParams.fromJson(rp)];
  }
}

class SeqPlatformParams {
  late final int len;
  late final int end;
  late final String yield;

  SeqPlatformParams.fromJson(Map<String, dynamic> json) {
    len = json['len'];
    end = json['end'];
    yield = json['yield'];
  }
}
