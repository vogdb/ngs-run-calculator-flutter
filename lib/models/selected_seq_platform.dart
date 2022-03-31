import 'package:flutter/foundation.dart';
import './seq_platform.dart';

class SelectedSeqPlatform extends ChangeNotifier {
  SeqPlatform? _platform;
  SeqPlatformMode? _mode;
  SeqPlatformParams? _params;

  SeqPlatform? get platform => _platform;

  set platform(SeqPlatform? platform) {
    if (_platform != platform) {
      _platform = platform;
      mode = null;
    }
  }

  SeqPlatformMode? get mode => _mode;

  set mode(SeqPlatformMode? mode) {
    if (_mode != mode) {
      _mode = mode;
      params = null;
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
