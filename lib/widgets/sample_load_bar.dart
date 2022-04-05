import 'package:flutter/material.dart';
import 'package:ngs_run_calculator/models/samples.dart';
import 'package:provider/provider.dart';

import '../models/BP.dart';
import '../models/seq_platform.dart';

BP calcSampleLoad(Sample sample, SeqPlatformParams seqParams) {
  int loadBP;
  if (sample.coverageNumReads != null) {
    loadBP = sample.num! * sample.coverageNumReads! * seqParams.len * seqParams.end;
  } else if (sample.coverageX != null && sample.size != null) {
    loadBP = sample.size!.valueBP * sample.num! * sample.coverageX!;
  } else {
    throw Exception('Sample load calculation error. Null coverages. Sample: $sample');
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

class SampleLoadBar extends StatelessWidget {
  const SampleLoadBar({Key? key}) : super(key: key);

  Widget _buildSingleColor(int percent, Color color) {
    return Expanded(
      flex: percent.round(),
      child: Container(color: color),
    );
  }

  Color _calcBorderColor(Iterable<int> samplesPercents) {
    var color = Colors.green;
    if (samplesPercents.isNotEmpty) {
      var allSamplesPercent = samplesPercents.reduce((v, e) => v + e);
      if (allSamplesPercent >= 99) {
        color = Colors.red;
      } else if (allSamplesPercent >= 80) {
        color = Colors.orange;
      }
    }
    return color;
  }

  @override
  Widget build(BuildContext context) {
    var selectedSeqPlatform = Provider.of<SelectedSeqPlatform>(context);
    var selectedSamples = Provider.of<SelectedSamples>(context);
    var samplesLoads = <Color, int>{};
    if (selectedSeqPlatform.params != null) {
      samplesLoads.addAll({
        for (var s in selectedSamples) s.color: calcSamplePercent(s, selectedSeqPlatform.params!)
      });
    }
    return Column(children: [
      Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          child: Text('The calculated load',
              style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.4))),
      SizedBox(
          height: 50,
          child: DecoratedBox(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: _calcBorderColor(samplesLoads.values).withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 3,
                )
              ]),
              position: DecorationPosition.background,
              child: Stack(children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [for (var e in samplesLoads.entries) _buildSingleColor(e.value, e.key)],
                ),
                Align(
                    alignment: Alignment.center,
                    child: Text(
                      selectedSeqPlatform.params?.yield.toString() ?? '',
                      style: const TextStyle(color: Colors.black),
                    ))
              ])))
    ]);
  }
}
