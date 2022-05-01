import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/BP.dart';
import '../common/validators.dart';
import '../models/sample.dart';
import './responsive_layout.dart';

class EditSample extends StatelessWidget {
  final Sample sample;
  final _formKey = GlobalKey<FormState>();

  EditSample({required this.sample, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var selectedSamples = Provider.of<SelectedSamples>(context, listen: false);

    Widget _buildSampleNumField() {
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: TextFormField(
            key: const Key('editSampleNum'),
            decoration: const InputDecoration(labelText: 'Number of samples'),
            initialValue: '${sample.num}',
            keyboardType: TextInputType.number,
            validator: (String? value) => validatePositiveInt(value),
            onSaved: (String? value) {
              sample.num = int.parse(value!);
            },
          ));
    }

    Widget _buildSampleCoverageField() {
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: TextFormField(
            key: const Key('editSampleCoverage'),
            decoration: InputDecoration(
              labelText: 'Coverage ${sample.type!.isCoverageX ? 'X' : 'num reads'}',
            ),
            initialValue: '${sample.coverage}',
            keyboardType: TextInputType.number,
            validator: (String? value) => validateCoverage(value),
            onSaved: (String? value) {
              sample.coverage = int.parse(value!);
            },
          ));
    }

    Widget _buildSampleSizeField() {
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: TextFormField(
            key: const Key('editSampleSize'),
            decoration: const InputDecoration(labelText: 'Size'),
            initialValue: '${sample.size}',
            validator: (String? value) => validateBP(value),
            onSaved: (String? value) {
              sample.size = BP(value!);
            },
          ));
    }

    return Dialog(
        child: Form(
      key: _formKey,
      child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(
              'Edit a sample of ${sample.type}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline5,
            ),
            ResponsiveLayout(
                wide: SingleChildScrollView(
                    child: Row(children: [
                  Flexible(child: _buildSampleNumField()),
                  Flexible(child: _buildSampleCoverageField()),
                  if (sample.size != null) Flexible(child: _buildSampleSizeField())
                ])),
                narrow: Column(
                  children: [
                    _buildSampleNumField(),
                    _buildSampleCoverageField(),
                    if (sample.size != null) _buildSampleSizeField()
                  ],
                )),
            Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    key: const Key('editSample'),
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        selectedSamples.update();
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Save'),
                  )
                ])),
          ])),
    ));
  }
}
