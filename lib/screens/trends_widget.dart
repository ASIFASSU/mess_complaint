import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class TrendsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: FirebaseService().getComplaintTrends(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No data available');
        } else {
          return Card(
            child: Column(
              children: snapshot.data!.map((trend) {
                return ListTile(title: Text('Trend: ${trend['trend_name']}'));
              }).toList(),
            ),
          );
        }
      },
    );
  }
}
