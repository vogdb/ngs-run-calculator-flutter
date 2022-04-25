import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/sample.dart';
import '../models/seq_platform.dart';
import '../common/calculate.dart';

int _cumulativeSum(Iterable<int> array) {
  return array.isEmpty ? 0 : array.reduce((v, e) => v + e);
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
      var cumPercent = _cumulativeSum(samplesPercents);
      if (cumPercent >= 99) {
        color = Colors.red;
      } else if (cumPercent >= 80) {
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
          child: Text('The calculated load of ${selectedSeqPlatform.params?.yield ?? ''}',
              style: Theme.of(context).textTheme.headline5,)),
      SizedBox(
          height: 50,
          child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: _calcBorderColor(samplesLoads.values), width: 3),
              ),
              position: DecorationPosition.foreground,
              child: Stack(children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var e in samplesLoads.entries) _buildSingleColor(e.value, e.key),
                    // the unloaded loadbar part
                    _buildSingleColor(100 - _cumulativeSum(samplesLoads.values), Colors.transparent)
                  ],
                ),
              ])))
    ]);
  }
}
