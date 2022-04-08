import 'package:flutter/material.dart';
import 'package:ngs_run_calculator/widgets/edit_sample.dart';
import 'package:provider/provider.dart';
import '../models/samples.dart';
import '../common/calculate.dart';
import '../models/seq_platform.dart';

class SampleList extends StatefulWidget {
  const SampleList({Key? key}) : super(key: key);

  @override
  State<SampleList> createState() => _SampleListState();
}

class _SampleListState extends State<SampleList> {
  Widget _buildSample(int index, SelectedSamples samples, SeqPlatformParams seqParams) {
    var sample = samples.elementAt(index);
    return ListTile(
      leading: Icon(Icons.circle, color: sample.color),
      title: Text('${sample.num} of ${sample.type!}'),
      subtitle: Text('Output:\u{00A0}${calcSampleLoad(sample, seqParams).toOptimalString()} '
          '(${calcSamplePercent(sample, seqParams)}%), '
          'Coverage:\u{00A0}${sample.isCoverageX ? 'x' : ''}${sample.coverage}'
          '${sample.size != null ? ', Size:\u{00A0}${sample.size}' : ''}'),
      isThreeLine: true,
      horizontalTitleGap: 0,
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            showDialog(
                context: context, builder: (BuildContext context) => EditSample(sample: sample));
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content:
                        Text('Are you sure to delete ${sample.num} samples of ${sample.type}?'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel')),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              samples.remove(sample);
                            });
                            Navigator.of(context).pop();
                          },
                          child: const Text('Confirm'))
                    ],
                  );
                });
          },
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    var seqParams = Provider.of<SelectedSeqPlatform>(context).params;
    if (seqParams == null) {
      return const SizedBox.shrink();
    }

    var samples = Provider.of<SelectedSamples>(context);
    return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [for (var i = 0; i < samples.length; i++) _buildSample(i, samples, seqParams)],
        ));
  }
}
