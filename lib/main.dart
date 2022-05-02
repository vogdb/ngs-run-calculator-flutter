import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import './models/seq_platform.dart';
import './models/sample.dart';
import './widgets/em.dart';
import './widgets/seq_platform.dart';
import './widgets/sample_load_bar.dart';
import './widgets/sample_list.dart';
import './widgets/add_sample.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<SelectedSeqPlatform>(create: (context) => SelectedSeqPlatform()),
          ChangeNotifierProvider<SelectedSamples>(create: (context) => SelectedSamples()),
        ],
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
            )));
  }
}
