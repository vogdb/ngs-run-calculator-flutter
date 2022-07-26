import 'package:flutter/material.dart';

import './models/sample.dart' show SelectedSamples;
import './models/seq_platform.dart';
import './widgets/add_sample.dart';
import './widgets/em.dart';
import './widgets/sample_list.dart';
import './widgets/sample_load_bar.dart';
import './widgets/seq_platform.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //SelectedSamplesNotifier must be at the root because it is used in `showDialog`.
    //Somehow `useRootNavigator: false` didn't help.
    return SelectedSamplesNotifier(
        notifier: SelectedSamples(
          listKey: GlobalKey<AnimatedListState>(),
          removedItemBuilder: (sample, context, animation) {
            return SizeTransition(
                sizeFactor: animation,
                child: SampleItem(
                  sample: sample,
                  isRemoved: true,
                ));
          },
        ),
        child: SelectedSeqPlatformNotifier(
            notifier: SelectedSeqPlatform(),
            child: MaterialApp(
                title: 'NGS Run Calculator',
                theme: ThemeData(brightness: Brightness.dark, primaryColor: Colors.blueGrey),
                home: Scaffold(
                  appBar: AppBar(title: const Text('NGS Run Calculator')),
                  // Cant use ListView due to https://github.com/flutter/flutter/issues/88762
                  body: SingleChildScrollView(
                    padding: EdgeInsets.all(em(context, 1, 16)),
                    child: Column(
                      children: const <Widget>[
                        SelectSeqPlatform(),
                        SampleLoadBar(),
                        SampleList(),
                        AddSample(),
                      ],
                    ),
                  ),
                ))));
    // ))));
  }
}
