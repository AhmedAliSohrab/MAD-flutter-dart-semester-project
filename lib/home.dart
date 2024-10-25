import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  final String name;
  final String urlImage;

  const UserPage({
    super.key,
    required this.name,
    required this.urlImage,
  });

  @override
  Widget build(BuildContext context) {
    // Prevent the user from going back
    ModalRoute.of(context)!.addScopedWillPopCallback(() async {
      return false; // Returning false will stop the back navigation
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text(
            'Welcome, $name'), // Display a welcome message with the user's name
        centerTitle: true,
      ),
      body: Image.network(
        urlImage,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}
