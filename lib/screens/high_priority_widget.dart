
import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class HighPriorityWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: FirebaseService().getHighPriorityComplaints(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No high-priority complaints');
        } else {
          return Card(
            child: Text(
              '${snapshot.data!.length} High-priority complaints',
              style: TextStyle(fontSize: 18),
            ),
          );
        }
      },
    );
  }
}
