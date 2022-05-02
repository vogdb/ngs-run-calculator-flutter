import 'package:test/test.dart';

import 'package:ngs_run_calculator/models/sample.dart';
import 'package:ngs_run_calculator/models/bp.dart';
import 'package:ngs_run_calculator/models/seq_platform.dart';
import 'package:ngs_run_calculator/common/calculate.dart';

void main() {
  SeqPlatformParams seqParams =
      SeqPlatformParams.fromJson({'len': 150, 'end': 2, 'yield': '120gbp'});

  test('calculate isCoverageX true', () {
    Sample sample = Sample();
    sample.type = SampleType.fromJson({'name': '', 'isCoverageX': true});
    sample.num = 2;
    sample.coverage = 100;
    sample.size = BP('60mbp');

    expect(calcSamplePercent(sample, seqParams), 10);
  });

  test('calculate isCoverageX false', () {
    Sample sample = Sample();
    sample.type = SampleType.fromJson({'name': '', 'isCoverageX': false});
    sample.num = 1000;
    sample.coverage = 50000;

    expect(calcSamplePercent(sample, seqParams), 13);
  });
}
