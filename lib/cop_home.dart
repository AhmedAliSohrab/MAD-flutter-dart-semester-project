import 'package:flutter/material.dart';
import 'widget/navigation_drawer_widget.dart';

class CopHome extends StatefulWidget {
  final String userType; // User type variable
  final String userName; // Username variable

  const CopHome({super.key, required this.userType, required this.userName});

  @override
  State<CopHome> createState() => _CopHomeState();
}

class _CopHomeState extends State<CopHome> {
  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        // Prevent the user from going back to the login page
        return false;
      },
      child: Scaffold(
        drawer: const NavigationDrawerWidget(),
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          elevation: 0,
        ),
        body: Builder(
          builder: (context) => Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16.0),
                const SizedBox(height: 24.0),
                Text(
                  'User Type: ${widget.userType}', // Display User Type
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  'User Name: ${widget.userName}', // Display User Name
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
