import 'package:flutter/material.dart';

import './edit_sample.dart';
import './em.dart';
import './responsive_layout.dart';
import './seq_platform.dart';
import '../common/calculate.dart';
import '../models/sample.dart';

class SelectedSamplesNotifier extends InheritedNotifier<SelectedSamples> {
  const SelectedSamplesNotifier(
      {Key? key, required SelectedSamples notifier, required Widget child})
      : super(key: key, notifier: notifier, child: child);

  static SelectedSamples of(BuildContext context, {bool listen = true}) {
    var notifier = (listen
            ? context.dependOnInheritedWidgetOfExactType<SelectedSamplesNotifier>()
            : context.findAncestorWidgetOfExactType<SelectedSamplesNotifier>())
        as SelectedSamplesNotifier;
    return notifier.notifier!;
  }
}

class EditButton extends StatelessWidget {
  final Sample sample;

  const EditButton({Key? key, required this.sample}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.edit),
      tooltip: 'Edit ${sample.type}',
      onPressed: () {
        showDialog(context: context, builder: (BuildContext context) => EditSample(sample: sample));
      },
    );
  }
}

class DeleteButton extends StatelessWidget {
  final Sample sample;

  const DeleteButton({Key? key, required this.sample}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var samples = SelectedSamplesNotifier.of(context, listen: false);
    return IconButton(
        icon: const Icon(Icons.delete),
        tooltip: 'Delete ${sample.type}',
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
}

class NarrowSampleItem extends StatelessWidget {
  final Sample sample;
  final bool isRemoved;

  const NarrowSampleItem({Key? key, required this.sample, this.isRemoved = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var seqParams = SelectedSeqPlatformNotifier.of(context).params;
    if (seqParams == null) {
      return const ListTile();
    }
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
          children: isRemoved ? [] : [EditButton(sample: sample), DeleteButton(sample: sample)]),
    );
  }
}

class WideSampleItem extends StatelessWidget {
  final Sample sample;
  final bool isRemoved;

  const WideSampleItem({Key? key, required this.sample, this.isRemoved = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var seqParams = SelectedSeqPlatformNotifier.of(context).params;
    if (seqParams == null) {
      return const ListTile();
    }
    return Row(children: [
      Expanded(flex: 1, child: Icon(Icons.circle, color: sample.color)),
      Expanded(flex: 3, child: Text('${sample.num} of ${sample.type!.name}')),
      Expanded(
          flex: 3,
          child: Text('\u{00A0}${calcSampleLoad(sample, seqParams).toOptimalString()} '
              '(${calcSamplePercent(sample, seqParams)}%)')),
      Expanded(
          flex: 2, child: Text('\u{00A0}${sample.type!.isCoverageX ? 'x' : ''}${sample.coverage}')),
      Expanded(
          flex: 2,
          child: (sample.size != null) ? Text('\u{00A0}${sample.size}') : const SizedBox.shrink()),
      if (!isRemoved) Expanded(flex: 1, child: EditButton(sample: sample)),
      if (!isRemoved) Expanded(flex: 1, child: DeleteButton(sample: sample)),
    ]);
  }
}

class SampleItem extends StatelessWidget {
  final Sample sample;
  final bool isRemoved;

  const SampleItem({Key? key, required this.sample, this.isRemoved = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        wide: WideSampleItem(
          sample: sample,
          isRemoved: isRemoved,
        ),
        narrow: NarrowSampleItem(
          sample: sample,
          isRemoved: isRemoved,
        ));
  }
}

class SampleList extends StatelessWidget {
  const SampleList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var seqParams = SelectedSeqPlatformNotifier.of(context).params;
    if (seqParams == null) {
      return SizedBox(
          height: em(context, 5, 60),
          child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                'Select a sequencing platform to see the sample list',
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              )));
    }

    var samples = SelectedSamplesNotifier.of(context);
    return Padding(
        key: const Key('sampleList'),
        padding: EdgeInsets.only(top: em(context, 1.4, 20)),
        child: Column(children: [
          if (ResponsiveLayout.isWide(context) && samples.isNotEmpty)
            Row(
              children: const [
                Expanded(flex: 1, child: SizedBox.shrink()),
                Expanded(flex: 3, child: Text('Sample')),
                Expanded(flex: 3, child: Text('Output:')),
                Expanded(flex: 2, child: Text('Coverage:')),
                Expanded(flex: 2, child: Text('Size:')),
                Expanded(flex: 2, child: SizedBox.shrink()),
              ],
            ),
          AnimatedList(
            key: SelectedSamplesNotifier.of(context, listen: false).listKey,
            initialItemCount: samples.length,
            shrinkWrap: true,
            itemBuilder: (context, index, animation) {
              return FadeTransition(
                  opacity: animation, child: SampleItem(sample: samples.elementAt(index)));
            },
          )
        ]));
  }
}
