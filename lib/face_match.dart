import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';


class MyFaceMatch extends StatefulWidget {
  const MyFaceMatch({super.key});

  @override
  MyFaceMatchState createState() => MyFaceMatchState(); // Made public
}

class MyFaceMatchState extends State<MyFaceMatch> {
  File? imgFile;
  final ImagePicker imgPicker = ImagePicker();
  Map<String, dynamic>? firstPersonDetails;

  // Implemented build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        elevation: 0,
        title: const Text(
          'Face Match',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            displayImage(),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                showOptionsDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
              ),
              child: const Text("Select Image"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (imgFile != null) {
                  final lastName =
                      imgFile!.path.split('/').last.split('.').first;
                  searchAndDisplayDetails(lastName);
                } else {
                  developer.log("No image selected!", name: 'MyFaceMatchState');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
              ),
              child: const Text("Search and Display Details"),
            ),
            const SizedBox(height: 10),
            if (firstPersonDetails != null)
              ElevatedButton(
                onPressed: () {
                  final firstName = firstPersonDetails!['name'];
                  final List<dynamic> charges =
                      firstPersonDetails!['charges'] ?? [];
                  final bookDate = firstPersonDetails!['book_date_formatted'];
                  final gender = firstPersonDetails!['details'][0][1];
                  final race = firstPersonDetails!['details'][1][1];
                  final age = firstPersonDetails!['details'][2][1];

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(firstName),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (charges.isNotEmpty)
                              const Text(
                                'Charges:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            if (charges.isEmpty)
                              const Text(
                                'No charges found.',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            for (var charge in charges) Text('- $charge'),
                            const SizedBox(height: 10),
                            Text('Gender: $gender'),
                            Text('Race: $race'),
                            Text('$age'),
                            const SizedBox(height: 10),
                            Text('Book Date: $bookDate'),
                          ],
                        ),
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                ),
                child: const Text("Show Details"),
              ),
            if (firstPersonDetails == null)
              const Text(
                'No records found!',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> searchAndDisplayDetails(String lastName) async {
    final url = Uri.parse(
        'https://jailbase-jailbase.p.rapidapi.com/search/?source_id=fl-suwa&last_name=$lastName');
    final headers = {
      'X-RapidAPI-Key': 'your_api_key',
      'X-RapidAPI-Host': 'jailbase-jailbase.p.rapidapi.com'
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final records = data['records'];
      if (records != null && records.isNotEmpty) {
        if (!mounted) return; // Ensure the widget is still mounted
        setState(() {
          firstPersonDetails = records[0];
        });
      } else {
        if (!mounted) return;
        setState(() {
          firstPersonDetails = null;
        });
      }
    } else {
      developer.log('Error: ${response.statusCode}', name: 'MyFaceMatchState');
    }
  }

  Future<void> showOptionsDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Options"),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                GestureDetector(
                  child: const Text("Capture Image From Camera"),
                  onTap: () {
                    openCamera();
                  },
                ),
                const Padding(padding: EdgeInsets.all(10)),
                GestureDetector(
                  child: const Text("Take Image From Gallery"),
                  onTap: () {
                    openGallery();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void openCamera() async {
    var imgCamera = await imgPicker.pickImage(source: ImageSource.camera);
    if (imgCamera != null) {
      setState(() {
        imgFile = File(imgCamera.path);
      });
    }
    if (mounted) {
      Navigator.of(context).pop(); // Safe to use BuildContext here
    }
  }

  void openGallery() async {
    var imgGallery = await imgPicker.pickImage(source: ImageSource.gallery);
    if (imgGallery != null) {
      setState(() {
        imgFile = File(imgGallery.path);
      });
    }
    if (mounted) {
      Navigator.of(context).pop(); // Safe to use BuildContext here
    }
  }

  Widget displayImage() {
    if (imgFile == null) {
      return const Text("No Image Selected!");
    } else {
      return Image.file(imgFile!, width: 350, height: 350);
    }
  }
}
