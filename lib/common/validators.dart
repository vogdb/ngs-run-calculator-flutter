import '../models/bp.dart';

String? validatePositiveInt(String? value) {
  if (value != null) {
    var n = int.tryParse(value);
    if (n != null && n > 0) {
      return null;
    }
  }
  return 'Enter a positive integer number';
}

String? validateBP(String? value) {
  if (value == null) {
    return 'Enter a BP value';
  }
  try {
    BP(value);
  } catch (e) {
    return e.toString();
  }
  return null;
}

String? validateCoverage(String? value) {
  if (value == null) {
    return 'Enter a coverage';
  }
  return validatePositiveInt(value);
}
