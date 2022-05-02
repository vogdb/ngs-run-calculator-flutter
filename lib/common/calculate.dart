import '../models/bp.dart';
import '../models/sample.dart';
import '../models/seq_platform.dart';

BP calcSampleLoad(Sample sample, SeqPlatformParams seqParams) {
  int loadBP;
  if (sample.type!.isCoverageX) {
    loadBP = sample.size!.valueBP * sample.num! * sample.coverage!;
  } else {
    loadBP = sample.num! * sample.coverage! * seqParams.len * seqParams.end;
  }
  return BP('$loadBP bp');
}

int calcSamplePercent(Sample sample, SeqPlatformParams seqParams) {
  int loadBP = calcSampleLoad(sample, seqParams).valueBP;
  double percent = loadBP / seqParams.yield.valueBP;
  const toPercent = 100;
  const roundTo2Decimal = 100;
  // manual rounding to preserve precision
  double roundedPercent = (toPercent * roundTo2Decimal * percent).round() / roundTo2Decimal;
  // round here to confirm the function's return type: int. Although `roundedPercent`
  // is already int but in contained in double type.
  return roundedPercent.round();
}
