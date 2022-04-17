import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/BP.dart';
import '../models/sample.dart';
import '../common/validators.dart';
import './responsive_layout.dart';

class AddSample extends StatefulWidget {
  const AddSample({Key? key}) : super(key: key);

  @override
  _AddSampleState createState() => _AddSampleState();
}

class _AddSampleState extends State<AddSample> {
  Sample _sample = Sample();
  final _formKey = GlobalKey<FormState>();
  final List<String> _sampleTypeList = [];

  @override
  void initState() {
    super.initState();

    _initSampleTypeList();
  }

  _initSampleTypeList() async {
    String jsonText =
        await DefaultAssetBundle.of(context).loadString('assets/sample-type-list.json');
    setState(() {
      _sampleTypeList.addAll(loadSampleTypeList(jsonText));
    });
  }

  Widget _buildSampleTypeField() {
    return Flexible(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: DropdownButtonFormField(
              isExpanded: true,
              hint: const Text('Sample type'),
              value: _sample.type,
              onChanged: (String? sampleType) {
                setState(() {
                  _sample.type = sampleType;
                });
              },
              validator: (String? sampleType) => sampleType == null ? 'Select a sample type' : null,
              items: _sampleTypeList.map((String sampleType) {
                return DropdownMenuItem(
                  child: Text(sampleType),
                  value: sampleType,
                );
              }).toList(),
            )));
  }

  Widget _buildSampleNumField() {
    return Flexible(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Number of samples',
              ),
              keyboardType: TextInputType.number,
              validator: (String? value) => validatePositiveInt(value),
              onSaved: (String? value) {
                _sample.num = int.parse(value!);
              },
            )));
  }

  Widget _buildBpSizeField(String label) {
    return Flexible(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: label,
              ),
              validator: (String? value) => validateBP(value),
              onSaved: (String? value) {
                _sample.size = BP(value!);
              },
            )));
  }

  Widget _buildCoverageField({bool isCoverageX = true}) {
    _sample.isCoverageX = isCoverageX;
    return Flexible(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Coverage ${isCoverageX ? 'X' : 'num reads'}',
              ),
              keyboardType: TextInputType.number,
              validator: (String? value) => validateCoverage(value),
              onSaved: (String? value) {
                _sample.coverage = int.parse(value!);
              },
            )));
  }

  List<Widget> _buildFieldsOfSampleType(String? sampleType) {
    switch (sampleType) {
      case 'Amplicon-based metagenome':
        return [_buildCoverageField(isCoverageX: false)];
      case 'Pro-/eukaryotic genome':
        return [_buildCoverageField(), _buildBpSizeField('Genome Size')];
      case 'Human exome':
        return [_buildCoverageField(), _buildBpSizeField('Region Size')];
      case 'Targeted panel':
        return [_buildCoverageField(), _buildBpSizeField('Target Size')];
      case 'Pro-/eukaryotic transcriptome':
        return [_buildCoverageField(isCoverageX: false)];
      case 'Shotgun metagenome':
        return [_buildCoverageField(isCoverageX: false)];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final selectedSamples = Provider.of<SelectedSamples>(context, listen: false);
    var fields = [
      _buildSampleTypeField(),
      _buildSampleNumField(),
      ..._buildFieldsOfSampleType(_sample.type),
    ];

    return Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                Text(
                  'Add a new sample',
                  style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.4),
                  textAlign: TextAlign.center,
                ),
                ResponsiveLayout(
                    wide: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: fields,
                    ),
                    narrow: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: fields,
                    )),
                ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      selectedSamples.add(_sample);
                      _formKey.currentState!.reset();
                      setState(() {
                        _sample = Sample();
                      });
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            )));
  }
}
