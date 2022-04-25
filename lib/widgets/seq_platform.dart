import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/seq_platform.dart';
import './responsive_layout.dart';

class SelectSeqPlatform extends StatefulWidget {
  const SelectSeqPlatform({Key? key}) : super(key: key);

  @override
  _SelectSeqPlatformState createState() => _SelectSeqPlatformState();
}

class _SelectSeqPlatformState extends State<SelectSeqPlatform> {
  final List<SeqPlatform> _seqPlatformList = [];
  late final SelectedSeqPlatform _selectedSeqPlatform;

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedSeqPlatform = Provider.of<SelectedSeqPlatform>(context, listen: false);
    });
    _initSeqPlatformList();
  }

  _initSeqPlatformList() async {
    String jsonText =
        await DefaultAssetBundle.of(context).loadString('assets/seq-platform-list.json');
    setState(() {
      _seqPlatformList.addAll(loadSeqPlatformList(jsonText));
    });
  }

  @override
  Widget build(BuildContext context) {
    var fields = [
      Flexible(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: DropdownButton(
                isExpanded: true,
                hint: const Text('Sequencing Platform'),
                value: _selectedSeqPlatform.platform,
                onChanged: (SeqPlatform? platform) {
                  setState(() {
                    _selectedSeqPlatform.platform = platform;
                  });
                },
                items: _seqPlatformList.map((SeqPlatform platform) {
                  return DropdownMenuItem(
                    child: Text(platform.name),
                    value: platform,
                  );
                }).toList(),
              ))),
      Flexible(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: DropdownButton(
                isExpanded: true,
                hint: const Text('Mode'),
                value: _selectedSeqPlatform.mode,
                onChanged: (SeqPlatformMode? mode) {
                  setState(() {
                    _selectedSeqPlatform.mode = mode;
                  });
                },
                items: _selectedSeqPlatform.platform?.modes.map((SeqPlatformMode mode) {
                  return DropdownMenuItem(
                    child: Text(mode.name),
                    value: mode,
                  );
                }).toList(),
              ))),
      Flexible(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: DropdownButton(
                isExpanded: true,
                hint: const Text('Read Params'),
                value: _selectedSeqPlatform.params,
                onChanged: (SeqPlatformParams? params) {
                  setState(() {
                    _selectedSeqPlatform.params = params;
                  });
                },
                items: _selectedSeqPlatform.mode?.params.map((SeqPlatformParams params) {
                  return DropdownMenuItem(
                    child: Text(params.len.toString() + 'x' + params.end.toString()),
                    value: params,
                  );
                }).toList(),
              ))),
    ];

    return Column(children: [
      Text(
        'Select a sequencing platform and its parameters',
        style: Theme.of(context).textTheme.headline5,
        textAlign: TextAlign.center,
      ),
      ResponsiveLayout(
          wide: Row(
            mainAxisSize: MainAxisSize.min,
            children: fields,
          ),
          narrow: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: fields))
    ]);
  }
}
