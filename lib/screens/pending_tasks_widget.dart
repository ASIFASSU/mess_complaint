import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class PendingTasksWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: FirebaseService().getPendingTasks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No pending tasks');
        } else {
          return Card(
            child: Text(
              '${snapshot.data!.length} Pending tasks',
              style: TextStyle(fontSize: 18),
            ),
          );
        }
      },
    );
  }
}
