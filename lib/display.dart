import 'package:flutter/material.dart';
import 'dart:convert';
import 'updatestatus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DisplayForm extends StatefulWidget {
  const DisplayForm({super.key});

  @override
  DisplayFormState createState() => DisplayFormState(); // Change here
}

class DisplayFormState extends State<DisplayForm> {
  // Change here
  List<Map<String, dynamic>> formList = [];

  @override
  void initState() {
    super.initState();
    _loadFormData();
  }

  void _loadFormData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Use null safety and ensure we get a List<String> or an empty list
    List<String>? formDataList = prefs.getStringList('formDataList') ?? [];

    // Decode each string in the list to a Map<String, dynamic>
    List<Map<String, dynamic>> decodedList = formDataList.map((data) {
      return json.decode(data) as Map<String, dynamic>;
    }).toList();

    // Update the state with the decoded data
    setState(() {
      formList = decodedList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        elevation: 0,
        title: const Text('Form Submissions'),
      ),
      body: ListView.builder(
        itemCount: formList.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> formData = formList[index];
          return Card(
            child: ListTile(
              title: Text('Full Name: ${formData['name']}'),
              subtitle: Text('Mobile No: ${formData['phone']}'),
              onTap: () async {
                final updatedFormData = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateStatus(formData: formData),
                  ),
                );

                if (updatedFormData != null) {
                  // Update the formList with the updated formData
                  final index = formList.indexOf(formData);
                  setState(() {
                    formList[index] = updatedFormData;
                  });
                }
              },
            ),
          );
        },
      ),
    );
  }
}
