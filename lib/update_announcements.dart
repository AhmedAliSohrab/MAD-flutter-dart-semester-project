import 'dart:convert' show json;
import 'package:flutter/material.dart';
import "package:shared_preferences/shared_preferences.dart"
    show SharedPreferences;

class UpdateAnnouncements extends StatefulWidget {
  const UpdateAnnouncements({super.key});

  @override
  update_announcements_state createState() => update_announcements_state();
}

// ignore: camel_case_types
class update_announcements_state extends State<UpdateAnnouncements> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  void _postAnnouncement() async {
    String title = _titleController.text;
    String content = _contentController.text;

    // Create the announcement object
    Map<String, dynamic> announcement = {
      'title': title,
      'content': content,
      'timestamp': DateTime.now().toString(),
    };

    // Save the announcement to local storage

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> announcements = prefs.getStringList('announcements') ?? [];
    announcements.add(json.encode(announcement));
    await prefs.setStringList('announcements', announcements);

    // Clear the text fields
    _titleController.clear();
    _contentController.clear();

    // Show a success message
    showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Announcement posted successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        elevation: 0,
        title: const Text('Post Announcement'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Title:',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Enter the title',
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Content:',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _contentController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Enter the content',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _postAnnouncement,
              child: const Text('Post Announcement'),
            ),
          ],
        ),
      ),
    );
  }
}
