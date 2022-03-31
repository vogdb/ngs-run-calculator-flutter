import 'dart:math' as math;

class BpException implements Exception {
  final String msg;

  const BpException(this.msg);
}

final _regex = RegExp(r'^([0-9]+(?:[.,][0-9]+)?)\s*([kmgtKMGT]?)[bB][pP]$');
const _prefixFactors = {
  '': 1,
  'K': 1000,
  'M': 1000 * 1000,
  'G': 1000 * 1000 * 1000,
  'T': 1000 * 1000 * 1000 * 1000
};

/// Checks that `val` number is integer. For example, 2.0 is integer.
bool _isInt(val) => val.round() == val;

class BP {
  /// value in BP, if `value==1kbp` then `valueBP==1000bp`
  late final int valueBP;
  late final double value;
  late final String prefix;

  BP(String bpStr) {
    var match = _regex.firstMatch(bpStr);
    if (match == null) {
      throw BpException('Invalid BP value: $bpStr. Valid examples: 1bp, 3 mbp, 4.2 KB.');
    }
    value = double.parse(match.group(1)!.replaceFirst(',', '.'));
    prefix = match.groupCount >= 2 ? match.group(2)!.toUpperCase() : '';
    int prefixFactor = _prefixFactors[prefix]!;
    if (!_isInt(value * prefixFactor)) {
      throw BpException(
          '${value * prefixFactor}bp is invalid because it contains a fraction of 1bp');
    }
    valueBP = (value * prefixFactor).round();

    if (valueBP < 1) {
      throw const BpException('BP value must be more than 1bp');
    }
  }

  int percentRatio(BP bp) {
    const toPercent = 100;
    const roundTo2Decimal = 100;
    return ((toPercent * roundTo2Decimal * valueBP / bp.valueBP) / roundTo2Decimal).round();
  }

  String toOriginalString() {
    return value.toString() + ' ' + prefix.toUpperCase() + 'bp';
  }

  String toOptimalString() {
    final mgntdOrder = (math.log(valueBP) / math.ln10).round();
    if (mgntdOrder < 1) {
      return valueBP.toString() + 'bp';
    }
    final mgntd = math.pow(10, mgntdOrder);
    for (var prefixF in _prefixFactors.entries) {
      if (mgntd >= prefixF.value && mgntd < prefixF.value * 1000) {
        num optimalValue = ((valueBP / prefixF.value) * 1000).round() / 1000;
        // if `optimalValue` contains int then cast it to int.
        optimalValue = _isInt(optimalValue) ? optimalValue.round() : optimalValue;
        return '$optimalValue ${prefixF.key}bp';
      }
    }
    throw BpException('Could not find the optimal BP string for $valueBP, ' + toOriginalString());
  }
}