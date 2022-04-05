import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/BP.dart';
import '../models/samples.dart';
import './validators.dart';

class AddSample extends StatefulWidget {
  const AddSample({Key? key}) : super(key: key);

  @override
  _AddSampleState createState() => _AddSampleState();
}

class _AddSampleState extends State<AddSample> {
  Sample _sample = Sample();
  final _formKey = GlobalKey<FormState>();
  final List<SampleType> _sampleTypeList = [];

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
    return DropdownButtonFormField(
      isExpanded: true,
      hint: const Text('Sample type'),
      value: _sample.type,
      onChanged: (String? sampleType) {
        setState(() {
          _sample.type = sampleType;
        });
      },
      validator: (String? sampleType) => sampleType == null ? 'Select a sample type' : null,
      items: _sampleTypeList.map((SampleType sampleType) {
        return DropdownMenuItem(
          child: Text(sampleType.name),
          value: sampleType.id,
        );
      }).toList(),
    );
  }

  Widget _buildSampleNumField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Number of samples',
      ),
      keyboardType: TextInputType.number,
      validator: (String? value) => validatePositiveInt(value),
      onSaved: (String? value) {
        _sample.num = int.parse(value!);
      },
      // onSaved: (String? value){},
    );
  }

  Widget _buildBpSizeField(String label) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
      ),
      validator: (String? value) => validateBP(value),
      onSaved: (String? value) {
        _sample.size = BP(value!);
      },
    );
  }

  Widget _buildCoverageXField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Coverage X',
      ),
      keyboardType: TextInputType.number,
      validator: (String? value) => validateCoverage(value),
      onSaved: (String? value) {
        _sample.coverageX = int.parse(value!);
      },
    );
  }

  Widget _buildCoverageNumReadsField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Coverage num reads',
      ),
      keyboardType: TextInputType.number,
      validator: (String? value) => validateCoverage(value),
      onSaved: (String? value) {
        _sample.coverageNumReads = int.parse(value!);
      },
    );
  }

  List<Widget> _buildFieldsOfSampleType(String? sampleType) {
    switch (sampleType) {
      case 'AmpliconMetagenome':
        return [_buildCoverageNumReadsField()];
      case 'ProEukaryoticGenome':
        return [_buildBpSizeField('Genome Size'), _buildCoverageXField()];
      case 'HumanExome':
        return [_buildBpSizeField('Region Size'), _buildCoverageXField()];
      case 'TargetedPanel':
        return [_buildBpSizeField('Target Size'), _buildCoverageXField()];
      case 'ProEukaryoticTranscriptome':
        return [_buildCoverageNumReadsField()];
      case 'ShotgunMetagenome':
        return [_buildCoverageNumReadsField()];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final selectedSamples = Provider.of<SelectedSamples>(context, listen: false);
    return Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Text(
                'Add a new sample',
                style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.4),
                textAlign: TextAlign.center,
              ),
            ),
            _buildSampleTypeField(),
            _buildSampleNumField(),
            ..._buildFieldsOfSampleType(_sample.type),
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
        ));
  }
}
