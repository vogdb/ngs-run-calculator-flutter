import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/BP.dart';
import '../common/validators.dart';
import '../models/sample.dart';

class EditSample extends StatefulWidget {
  final Sample sample;

  const EditSample({required this.sample, Key? key}) : super(key: key);

  @override
  _EditSampleState createState() => _EditSampleState();
}

class _EditSampleState extends State<EditSample> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var sample = widget.sample;
    var selectedSamples = Provider.of<SelectedSamples>(context, listen: false);

    return AlertDialog(
      content: Form(
        key: _formKey,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Edit a sample of ${sample.type}',
                textAlign: TextAlign.center,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Number of samples'),
                initialValue: '${sample.num}',
                keyboardType: TextInputType.number,
                validator: (String? value) => validatePositiveInt(value),
                onSaved: (String? value) {
                  setState(() {
                    sample.num = int.parse(value!);
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Coverage ${sample.isCoverageX ? 'X' : 'num reads'}',
                ),
                initialValue: '${sample.coverage}',
                keyboardType: TextInputType.number,
                validator: (String? value) => validateCoverage(value),
                onSaved: (String? value) {
                  setState(() {
                    sample.coverage = int.parse(value!);
                  });
                },
              ),
              if (sample.size != null)
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Size'),
                  initialValue: '${sample.size}',
                  validator: (String? value) => validateBP(value),
                  onSaved: (String? value) {
                    setState(() {
                      sample.size = BP(value!);
                    });
                  },
                ),
              ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _formKey.currentState!.reset();
                    selectedSamples.update();
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Save'),
              ),
            ]),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel')),
      ],
    );
  }
}
