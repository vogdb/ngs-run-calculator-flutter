import 'package:test/test.dart';
import 'package:ngs_run_calculator/models/bp.dart';

void main() {
  test('Success validation', () {
    expect(BP('1bp').valueBP, 1);
    expect(BP('0.5 kbp').valueBP, 500);
    expect(BP('34.04Kbp').valueBP, 34040);
    expect(BP('1.05mbp').valueBP, 1050000);
    expect(BP('1,05 mbp').valueBP, 1050000);
  });

  test('Failed validation', () {
    expect(() => BP(''), throwsA(predicate((e) => e is BpException && e.msg.contains('Invalid'))));
    expect(() => BP(' '), throwsA(predicate((e) => e is BpException && e.msg.contains('Invalid'))));

    expect(
        () => BP('100'), throwsA(predicate((e) => e is BpException && e.msg.contains('Invalid'))));
    expect(() => BP('100.01'),
        throwsA(predicate((e) => e is BpException && e.msg.contains('Invalid'))));
    expect(
        () => BP('3lbp'), throwsA(predicate((e) => e is BpException && e.msg.contains('Invalid'))));

    expect(() => BP('0 bp'),
        throwsA(predicate((e) => e is BpException && e.msg.contains('must be more than 1bp'))));

    expect(
        () => BP('0.3 bp'),
        throwsA(
            predicate((e) => e is BpException && e.msg.contains('contains a fraction of 1bp'))));
    expect(
        () => BP('10.6 bp'),
        throwsA(
            predicate((e) => e is BpException && e.msg.contains('contains a fraction of 1bp'))));
    expect(
        () => BP('1.6568 kbp'),
        throwsA(
            predicate((e) => e is BpException && e.msg.contains('contains a fraction of 1bp'))));
  });

  test('To optimal string', () {
    expect(BP('1000bp').toOptimalString(), '1 Kbp');
    expect(BP('3000000bp').toOptimalString(), '3 Mbp');
    expect(BP('1540kbp').toOptimalString(), '1.54 Mbp');
  });
}
