import 'package:crimereportingapp/form.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SOSPage extends StatelessWidget {
  const SOSPage({super.key});

  // Emergency hotline numbers in Pakistan
  static const emergencyHotlines = {
    'Edhi Ambulance Helpline': '115',
    'Chhipa Ambulance Helpline': '1020',
    'Aman Ambulance Helpline': '1021',
    'Rescue helpline': '1122',
    'Police Madadgar Helpline': '15',
    'Rangers Helpline': '1101',
    'Fire Brigade Helpline': '16',
    'Pakistan Medical Assistance Helpline': '1166',
  };

  Future<void> _callEmergencyHotline(String hotlineNumber) async {
    final Uri phoneNumberUri = Uri(scheme: 'tel', path: hotlineNumber);
    try {
      if (await canLaunchUrl(phoneNumberUri)) {
        await launchUrl(phoneNumberUri);
      } else {
        logger.i('Unable to launch phone call');
      }
    } catch (e) {
      logger.i('Error launching phone call: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        elevation: 0,
        title: const Text('SOS'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: emergencyHotlines.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemBuilder: (BuildContext context, int index) {
          final entry = emergencyHotlines.entries.elementAt(index);
          return ListTile(
            title: Text(
              entry.key,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              entry.value,
              style: const TextStyle(fontSize: 16.0),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.phone),
              onPressed: () => _callEmergencyHotline(entry.value),
            ),
          );
        },
      ),
    );
  }
}
