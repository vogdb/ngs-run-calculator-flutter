import 'package:flutter/material.dart';

import './em.dart';
import './sample_list.dart' show SelectedSamplesNotifier;
import './seq_platform.dart' show SelectedSeqPlatformNotifier;
import '../common/calculate.dart';
import '../models/sample.dart' show Sample;
import '../models/seq_platform.dart' show SeqPlatformParams;

int _cumulativeSum(Iterable<int> array) {
  return array.isEmpty ? 0 : array.reduce((v, e) => v + e);
}

class SampleLoadBar extends StatelessWidget {
  const SampleLoadBar({Key? key}) : super(key: key);

  Color _calcBorderColor(Iterable<int> samplesPercents) {
    var color = Colors.green;
    if (samplesPercents.isNotEmpty) {
      var cumPercent = _cumulativeSum(samplesPercents);
      if (cumPercent >= 99) {
        color = Colors.red;
      } else if (cumPercent >= 80) {
        color = Colors.orange;
      }
    }
    return color;
  }

  Map<Sample, int> _calcSampleWidths(samples, SeqPlatformParams params) {
    var sampleWidths = <Sample, int>{};
    var percentSum = 0;
    for (var sample in samples) {
      if (percentSum >= 100) {
        // if the sum of previous samples percents >= 100 then set the current sample width
        // to 0 because it won't be visible
        sampleWidths[sample] = 0;
      } else {
        var percent = calcSamplePercent(sample, params);
        sampleWidths[sample] = percent + percentSum >= 100 ? 100 - percentSum : percent;
        percentSum += percent;
      }
    }
    return sampleWidths;
  }

  @override
  Widget build(BuildContext context) {
    var selectedSeqPlatform = SelectedSeqPlatformNotifier.of(context);
    var selectedSamples = SelectedSamplesNotifier.of(context);
    var sampleWidths = <Sample, int>{};
    if (selectedSeqPlatform.params != null) {
      sampleWidths = _calcSampleWidths(selectedSamples, selectedSeqPlatform.params!);
    }
    return Column(children: [
      Padding(
          padding: EdgeInsets.symmetric(vertical: em(context, 1.4, 20)),
          child: Text(
            'The calculated load of ${selectedSeqPlatform.params?.yield ?? ''}',
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          )),
      Container(
          height: em(context, 3, 50),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(em(context, 0.3, 5)),
            border: Border.all(
              color: _calcBorderColor(sampleWidths.values),
              width: em(context, 0.2, 3),
            ),
          ),
          child: LayoutBuilder(builder: (BuildContext lbContext, BoxConstraints constraints) {
            return Row(
              children: [
                for (var e in sampleWidths.entries)
                  AnimatedContainer(
                    duration: const Duration(seconds: 2),
                    color: e.key.color,
                    width: 0.01 * e.value * constraints.maxWidth,
                    alignment: Alignment.centerLeft,
                    height: 50,
                  ),
                // this container is a starting point in animation of a new color
                AnimatedContainer(
                  duration: const Duration(seconds: 2),
                  color: Colors.transparent,
                  width: 0,
                  alignment: Alignment.centerLeft,
                  height: 50,
                )
              ],
            );
          }))
    ]);
  }
}
