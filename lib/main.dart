import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import './models/seq_platform.dart';
import './models/sample.dart';
import './widgets/seq_platform.dart';
import './widgets/sample_load_bar.dart';
import './widgets/sample_list.dart';
import './widgets/add_sample.dart';
import 'models/BP.dart';

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
            body: ListView(
              padding: const EdgeInsets.all(20),
              children: const <Widget>[
                SelectSeqPlatform(),
                SampleLoadBar(),
                SampleList(),
                AddSample(),
              ],
            ),
          ),
        ));
  }
}
