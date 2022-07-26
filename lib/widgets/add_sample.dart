import 'package:flutter/material.dart';

import './em.dart';
import './responsive_layout.dart';
import './sample_list.dart';
import '../common/validators.dart';
import '../models/bp.dart';
import '../models/sample.dart';

class AddSample extends StatefulWidget {
  const AddSample({Key? key}) : super(key: key);

  @override
  AddSampleState createState() => AddSampleState();
}

class AddSampleState extends State<AddSample> {
  Sample _sample = Sample();
  final _formKey = GlobalKey<FormState>();

  Future<List<SampleType>> _initSampleTypeList() async {
    String jsonText =
        await DefaultAssetBundle.of(context).loadString('assets/sample-type-list.json');
    return loadSampleTypeList(jsonText);
  }

  Widget _buildSampleTypeField(List<SampleType> sampleTypeList) {
    return Flexible(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: em(context, 0.2, 3)),
            child: DropdownButtonFormField(
              key: const Key('addSampleType'),
              isExpanded: true,
              hint: const Text('Sample type'),
              value: _sample.type,
              onChanged: (SampleType? type) {
                setState(() {
                  _sample.type = type;
                });
              },
              validator: (SampleType? type) => type == null ? 'Select a sample type' : null,
              items: sampleTypeList.map((SampleType type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.name),
                );
              }).toList(),
            )));
  }

  Widget _buildSampleNumField() {
    return Flexible(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: em(context, 0.2, 3)),
            child: TextFormField(
              key: const Key('addSampleNum'),
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

  Widget _buildBpSizeField(SampleType type) {
    return Flexible(
        child: Padding(
            key: const Key('addSampleSize'),
            padding: EdgeInsets.symmetric(horizontal: em(context, 0.2, 3)),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: type.sizeLabel ?? 'BP Size',
                hintText: '100Kbp',
              ),
              validator: (String? value) => validateBP(value),
              onSaved: (String? value) {
                _sample.size = BP(value!);
              },
            )));
  }

  Widget _buildCoverageField(SampleType type) {
    return Flexible(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: em(context, 0.2, 3)),
            child: TextFormField(
              key: const Key('addSampleCoverage'),
              decoration: InputDecoration(
                labelText: 'Coverage ${type.isCoverageX ? 'X' : 'num reads'}',
              ),
              keyboardType: TextInputType.number,
              validator: (String? value) => validateCoverage(value),
              onSaved: (String? value) {
                _sample.coverage = int.parse(value!);
              },
            )));
  }

  List<Widget> _buildFieldsOfSampleType(SampleType? type) {
    if (type == null) {
      return <Widget>[];
    } else {
      var fields = <Widget>[_buildCoverageField(type)];
      if (_sample.type!.isCoverageX) {
        fields.add(_buildBpSizeField(type));
      }
      return fields;
    }
  }

  List<Widget> _buildAddFields(List<SampleType> sampleTypeList) {
    return [
      _buildSampleTypeField(sampleTypeList),
      _buildSampleNumField(),
      ..._buildFieldsOfSampleType(_sample.type),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: em(context, 2, 30)),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  'Add a new sample',
                  style: Theme.of(context).textTheme.headline5,
                  textAlign: TextAlign.center,
                ),
                FutureBuilder<List<SampleType>>(
                    future: _initSampleTypeList(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(child: Text('Couldn\'t load sample types!'));
                      } else if (snapshot.hasData) {
                        var fields = _buildAddFields(snapshot.data!);
                        return ResponsiveLayout(
                            wide: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: fields,
                            ),
                            narrow: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: fields,
                            ));
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
                Padding(
                    padding: EdgeInsets.only(top: em(context, 1.4, 20)),
                    child: ElevatedButton(
                      key: const Key('addSample'),
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          SelectedSamplesNotifier.of(context, listen: false).add(_sample);
                          _formKey.currentState!.reset();
                          setState(() {
                            _sample = Sample();
                          });
                        }
                      },
                      child: const Text('Add'),
                    )),
              ],
            )));
  }
}
