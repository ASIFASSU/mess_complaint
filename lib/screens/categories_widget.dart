import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class CategoriesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: FirebaseService().getCategoriesOverview(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No categories available');
        } else {
          return Card(
            child: Column(
              children: snapshot.data!.map((category) {
                return ListTile(
                  title: Text('${category['category_name']}'),
                  subtitle: Text('${category['complaints_count']} complaints'),
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }
}