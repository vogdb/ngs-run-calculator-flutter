import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/seq_platform.dart';
import './em.dart';
import './responsive_layout.dart';

class SeqPlatformField extends StatelessWidget {
  final List<SeqPlatform> seqPlatformList;

  const SeqPlatformField({Key? key, required this.seqPlatformList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var selectedSeqPlatform = Provider.of<SelectedSeqPlatform>(context);
    return Flexible(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: em(context, 0.2, 3)),
            child: DropdownButton(
              key: const Key('selectSeqPlatform'),
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
            )));
  }
}

class SeqPlatformModeField extends StatelessWidget {
  const SeqPlatformModeField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var selectedSeqPlatform = Provider.of<SelectedSeqPlatform>(context);
    return Flexible(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: em(context, 0.2, 3)),
            child: DropdownButton(
              key: const Key('selectSeqPlatformMode'),
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
            )));
  }
}

class SeqPlatformParamsField extends StatelessWidget {
  const SeqPlatformParamsField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var selectedSeqPlatform = Provider.of<SelectedSeqPlatform>(context);
    return Flexible(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: em(context, 0.2, 3)),
            child: DropdownButton(
              key: const Key('selectSeqPlatformParams'),
              isExpanded: true,
              hint: const Text('Read Params'),
              value: selectedSeqPlatform.params,
              onChanged: (SeqPlatformParams? params) {
                selectedSeqPlatform.params = params;
              },
              items: selectedSeqPlatform.mode?.params.map((SeqPlatformParams params) {
                return DropdownMenuItem(
                  child: Text(params.toString()),
                  value: params,
                );
              }).toList(),
            )));
  }
}

class SelectSeqPlatform extends StatelessWidget {
  const SelectSeqPlatform({Key? key}) : super(key: key);

  Future<List<SeqPlatform>> _initSeqPlatformList(BuildContext context) async {
    String jsonText =
        await DefaultAssetBundle.of(context).loadString('assets/seq-platform-list.json');
    return loadSeqPlatformList(jsonText);
  }

  List<Widget> _buildFields(BuildContext context, List<SeqPlatform> seqPlatformList) {
    return [
      SeqPlatformField(seqPlatformList: seqPlatformList),
      const SeqPlatformModeField(),
      const SeqPlatformParamsField()
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
                    children: _buildFields(context, snapshot.data!),
                  ),
                  narrow: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildFields(context, snapshot.data!)));
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    ]);
  }
}
