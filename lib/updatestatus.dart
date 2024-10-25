import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateStatus extends StatefulWidget {
  final Map<String, dynamic> formData;

  const UpdateStatus({super.key, required this.formData});

  @override
  UpdateStatusState createState() => UpdateStatusState();
}

class UpdateStatusState extends State<UpdateStatus> {
  late double _progressValue;
  late TextEditingController _statusController;

  @override
  void initState() {
    super.initState();
    _progressValue = widget.formData['progressValue'] ?? 0.0;
    _statusController = TextEditingController(text: widget.formData['status']);
  }

  @override
  void dispose() {
    _statusController.dispose();
    super.dispose();
  }

  void _updateProgress(double value) {
    setState(() {
      _progressValue = value;
    });
  }

  Future<void> _updateFormData() async {
    final prefs = await SharedPreferences.getInstance();
    final formDataList = prefs.getStringList('formDataList') ?? [];
    final decodedList = formDataList.map((data) {
      return json.decode(data) as Map<String, dynamic>;
    }).toList();

    final index = decodedList.indexWhere(
      (formData) => formData['phone'] == widget.formData['phone'],
    );

    if (index != -1) {
      decodedList[index]['progressValue'] = _progressValue;
      decodedList[index]['status'] = _statusController.text;

      final encodedList = decodedList.map((formData) {
        return json.encode(formData);
      }).toList();

      await prefs.setStringList('formDataList', encodedList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        elevation: 0,
        title: const Text('Update Status'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Full Name: ${widget.formData['name']}'),
            Text('Mobile No: ${widget.formData['phone']}'),
            Text('Date of Birth: ${widget.formData['dob']}'),
            Text('Address: ${widget.formData['address']}'),
            Text('Aadhar: ${widget.formData['aadhar']}'),
            Text('Occupation: ${widget.formData['occupation']}'),
            Text('Nationality: ${widget.formData['nationality']}'),
            Text('Offender Name: ${widget.formData['offenderName']}'),
            Text('Start Date: ${widget.formData['startDate']}'),
            Text('End Date: ${widget.formData['endDate']}'),
            Text('Offence Type: ${widget.formData['offenceType']}'),
            Text('Offence Place: ${widget.formData['offencePlace']}'),
            Text('Details: ${widget.formData['details']}'),
            Text('Suspect Gender: ${widget.formData['suspectGender']}'),
            Text('Suspect Age: ${widget.formData['suspectAge']}'),
            Text('Suspect Build: ${widget.formData['suspectBuild']}'),
            Text('Suspect Height: ${widget.formData['suspectHeight']}'),
            Text('Suspect Complexion: ${widget.formData['suspectComplexion']}'),
            Text(
                'Suspect Deformities: ${widget.formData['suspectDeformities']}'),
            Text('Suspect Dialect: ${widget.formData['suspectDialect']}'),
            Text('Suspect Marks: ${widget.formData['suspectMarks']}'),
            const SizedBox(height: 16.0),
            const Text(
              'Update Status:',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: _statusController,
              decoration: const InputDecoration(hintText: 'Enter status'),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Progress Value:',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            Slider(
              value: _progressValue,
              min: 0.0,
              max: 1.0,
              onChanged: _updateProgress,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await _updateFormData(); // Call the async method
                if (mounted) {
                  // Check if the widget is still mounted
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context,
                      widget.formData); // Use Navigator only if mounted
                }
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
