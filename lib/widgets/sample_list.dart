import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/calculate.dart';
import '../models/sample.dart';
import '../models/seq_platform.dart';
import './edit_sample.dart';
import './responsive_layout.dart';

class SampleList extends StatelessWidget {
  const SampleList({Key? key}) : super(key: key);

  Widget _buildEditButton(BuildContext context, Sample sample) {
    return IconButton(
      icon: const Icon(Icons.edit),
      onPressed: () {
        showDialog(context: context, builder: (BuildContext context) => EditSample(sample: sample));
      },
    );
  }

  Widget _buildDeleteButton(BuildContext context, Sample sample) {
    var samples = Provider.of<SelectedSamples>(context);
    return IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content:
                      Text('Are you sure to delete ${sample.num} samples of ${sample.type!.name}?'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel')),
                    TextButton(
                        onPressed: () {
                          samples.remove(sample);
                          Navigator.of(context).pop();
                        },
                        child: const Text('Confirm'))
                  ],
                );
              });
        });
  }

  Widget _buildNarrowSample(BuildContext context, Sample sample, SeqPlatformParams seqParams) {
    return ListTile(
      leading: Icon(Icons.circle, color: sample.color),
      title: Text('${sample.num} of ${sample.type!.name}'),
      subtitle: Text('Output:\u{00A0}${calcSampleLoad(sample, seqParams).toOptimalString()} '
          '(${calcSamplePercent(sample, seqParams)}%), '
          'Coverage:\u{00A0}${sample.type!.isCoverageX ? 'x' : ''}${sample.coverage}'
          '${sample.size != null ? ', Size:\u{00A0}${sample.size}' : ''}'),
      isThreeLine: true,
      horizontalTitleGap: 0,
      trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [_buildEditButton(context, sample), _buildDeleteButton(context, sample)]),
    );
  }

  TableRow _buildWideSample(BuildContext context, Sample sample, SeqPlatformParams seqParams) {
    return TableRow(children: [
      Icon(Icons.circle, color: sample.color),
      Text(sample.type!.name),
      Text('${sample.num!}'),
      Text('${sample.type!.isCoverageX ? 'x' : ''}${sample.coverage}'),
      Text(sample.size != null ? '${sample.size}' : ''),
      Text(calcSampleLoad(sample, seqParams).toOptimalString() +
          '(${calcSamplePercent(sample, seqParams)}%)'),
      _buildEditButton(context, sample),
      _buildDeleteButton(context, sample)
    ]);
  }

  @override
  Widget build(BuildContext context) {
    var seqParams = Provider.of<SelectedSeqPlatform>(context).params;
    if (seqParams == null) {
      return SizedBox(
          height: 60,
          child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                'Select a sequencing platform to see the sample list',
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              )));
    }

    var samples = Provider.of<SelectedSamples>(context);
    return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: ResponsiveLayout(
            wide: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: const {
                  0: FlexColumnWidth(5),
                  1: FlexColumnWidth(30),
                  2: FlexColumnWidth(10),
                  3: FlexColumnWidth(10),
                  4: FlexColumnWidth(10),
                  5: FlexColumnWidth(15),
                  6: FlexColumnWidth(10),
                  7: FlexColumnWidth(10),
                },
                children: [
                  const TableRow(children: [
                    Text(''),
                    Text('Type'),
                    Text('Number'),
                    Text('Coverage'),
                    Text('Size'),
                    Text('Output'),
                    Text(''),
                    Text(''),
                  ]),
                  for (var sample in samples) _buildWideSample(context, sample, seqParams)
                ]),
            narrow: Column(
              children: [
                for (var sample in samples) _buildNarrowSample(context, sample, seqParams)
              ],
            )));
  }
}
