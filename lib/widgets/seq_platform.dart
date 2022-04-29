import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/seq_platform.dart';
import './responsive_layout.dart';

class SelectSeqPlatform extends StatelessWidget {
  const SelectSeqPlatform({Key? key}) : super(key: key);

  Future<List<SeqPlatform>> _initSeqPlatformList(BuildContext context) async {
    return DefaultAssetBundle.of(context)
        .loadString('assets/seq-platform-list.json')
        .then((jsonText) => loadSeqPlatformList(jsonText));
  }

  List<Widget> _buildSelectFields(BuildContext context, List<SeqPlatform> seqPlatformList) {
    var selectedSeqPlatform = Provider.of<SelectedSeqPlatform>(context);
    return [
      Flexible(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: DropdownButton(
                isExpanded: true,
                hint: const Text('Sequencing Platform'),
                value: selectedSeqPlatform.platform,
                onChanged: (SeqPlatform? platform) {
                  selectedSeqPlatform.platform = platform;
                },
                items: seqPlatformList.map((SeqPlatform platform) {
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
                value: selectedSeqPlatform.mode,
                onChanged: (SeqPlatformMode? mode) {
                  selectedSeqPlatform.mode = mode;
                },
                items: selectedSeqPlatform.platform?.modes.map((SeqPlatformMode mode) {
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
                value: selectedSeqPlatform.params,
                onChanged: (SeqPlatformParams? params) {
                  selectedSeqPlatform.params = params;
                },
                items: selectedSeqPlatform.mode?.params.map((SeqPlatformParams params) {
                  return DropdownMenuItem(
                    child: Text(params.len.toString() + 'x' + params.end.toString()),
                    value: params,
                  );
                }).toList(),
              ))),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(
        'Select a sequencing platform and its parameters',
        style: Theme.of(context).textTheme.headline5,
        textAlign: TextAlign.center,
      ),
      FutureBuilder<List<SeqPlatform>>(
          future: _initSeqPlatformList(context),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Couldn\'t load sequencing platforms!'));
            } else if (snapshot.hasData) {
              return ResponsiveLayout(
                  wide: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: _buildSelectFields(context, snapshot.data!),
                  ),
                  narrow: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildSelectFields(context, snapshot.data!)));
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    ]);
  }
}
