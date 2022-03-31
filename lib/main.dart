import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import './models/selected_seq_platform.dart';
import './widgets/select_seq_platform.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<SelectedSeqPlatform>(
              create: (context) => SelectedSeqPlatform()),
        ],
        child: MaterialApp(
          title: 'NGS Run Calculator',
          theme: ThemeData(
              brightness: Brightness.dark, primaryColor: Colors.blueGrey),
          home: Scaffold(
            appBar: AppBar(title: const Text('NGS Run Calculator')),
            body: ListView(
              padding: const EdgeInsets.all(20),
              children: const <Widget>[
                SelectSeqPlatform(),
              ],
            ),
          ),
        ));
  }
}
