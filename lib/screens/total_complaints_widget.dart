import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class TotalComplaintsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: FirebaseService().getTotalComplaints(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error fetching complaints');
        } else {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '${snapshot.data} Complaints',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          );
        }
      },
    );
  }
}
