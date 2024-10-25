import 'package:crimereportingapp/form.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Import the Fluttertoast package
import 'package:date_time_picker/date_time_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  String startDate = "";
  String endDate = "";
  String dob = "";
  int _activeStepIndex = 0;

  // TextEditingController instances
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController nationality = TextEditingController();
  TextEditingController occupation = TextEditingController();
  TextEditingController cnic = TextEditingController();
  TextEditingController offenderName = TextEditingController();
  TextEditingController offenceType = TextEditingController();
  TextEditingController offencePlace = TextEditingController();
  TextEditingController details = TextEditingController();
  TextEditingController suspectAge = TextEditingController();
  TextEditingController suspectBuild = TextEditingController();
  TextEditingController suspectComplexion = TextEditingController();
  TextEditingController suspectDeformities = TextEditingController();
  TextEditingController suspectDialect = TextEditingController();
  TextEditingController suspectGender = TextEditingController();
  TextEditingController suspectHeight = TextEditingController();
  TextEditingController suspectMarks = TextEditingController();

  Future<void> _saveFormData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> formDataList = prefs.getStringList('formDataList') ?? [];

    Map<String, dynamic> formData = {
      'id': UniqueKey().toString(),
      'name': name.text,
      'phone': phone.text,
      'dob': dob,
      'address': address.text,
      'CNIC': cnic.text,
      'occupation': occupation.text,
      'nationality': nationality.text,
      'offenderName': offenderName.text,
      'startDate': startDate,
      'endDate': endDate,
      'offenceType': offenceType.text,
      'offencePlace': offencePlace.text,
      'details': details.text,
      'suspectGender': suspectGender.text,
      'suspectAge': suspectAge.text,
      'suspectBuild': suspectBuild.text,
      'suspectHeight': suspectHeight.text,
      'suspectComplexion': suspectComplexion.text,
      'suspectDeformities': suspectDeformities.text,
      'suspectDialect': suspectDialect.text,
      'suspectMarks': suspectMarks.text,
      'status': "Registered",
      'progressValue': 0.2,
    };

    formDataList.add(json.encode(formData));
    await prefs.setStringList('formDataList', formDataList);
    logger.i(formDataList);
  }

  List<Step> stepList() => [
        Step(
          state: _activeStepIndex <= 0 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 0,
          title: const Text('Personal Information'),
          content: Column(
            children: [
              TextField(
                controller: name,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Full Name',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: phone,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Mobile No',
                ),
              ),
              DateTimePicker(
                initialValue: '',
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                dateLabelText: 'Date of Birth',
                onChanged: (val) => dob = val,
                validator: (val) {
                  dob = val!;
                  return null;
                },
                onSaved: (val) => dob = val!,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: address,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Full Address',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: cnic,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'CNIC number',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: occupation,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Occupation',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: nationality,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nationality',
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        Step(
          state: _activeStepIndex <= 1 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 1,
          title: const Text('Details of Incident/Offence'),
          content: Column(
            children: [
              TextField(
                controller: offenderName,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name offender',
                ),
              ),
              const SizedBox(height: 10),
              DateTimePicker(
                initialValue: '',
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                dateLabelText: 'Occurence of offence from',
                onChanged: (val) => startDate = val,
                validator: (val) {
                  startDate = val!;
                  return null;
                },
                onSaved: (val) => startDate = val!,
              ),
              const SizedBox(height: 10),
              DateTimePicker(
                initialValue: '',
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                dateLabelText: 'Occurence of offence until',
                onChanged: (val) => endDate = val,
                validator: (val) {
                  endDate = val!;
                  return null;
                },
                onSaved: (val) => endDate = val!,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: offenceType,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Type of offence',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: offencePlace,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Place of offence',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: details,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Complete detail of the event',
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        Step(
          state: _activeStepIndex <= 2 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 2,
          title: const Text('Details of Suspect'),
          content: Column(
            children: [
              const SizedBox(height: 10),
              TextField(
                controller: suspectGender,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Sex',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: suspectAge,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Age of suspect',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: suspectBuild,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Build of suspect',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: suspectHeight,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Height of suspect',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: suspectComplexion,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Complexion of suspect',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: suspectDeformities,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Deformities of suspect',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: suspectDialect,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Dialect of suspect',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: suspectMarks,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Distinct marks of suspect',
                ),
              ),
            ],
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Form Wizard")),
      body: Stepper(
        currentStep: _activeStepIndex,
        onStepContinue: () {
          if (_activeStepIndex < stepList().length - 1) {
            setState(() {
              _activeStepIndex += 1;
            });
          } else {
            _saveFormData();

            Fluttertoast.showToast(
              msg: "Form submitted successfully!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          }
        },
        onStepCancel: () {
          if (_activeStepIndex > 0) {
            setState(() {
              _activeStepIndex -= 1;
            });
          }
        },
        steps: stepList(),
      ),
    );
  }
}
