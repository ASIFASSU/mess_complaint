import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ComplaintDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Retrieve the complaint ID passed from the previous screen
    final String complaintId = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('Complaint Details'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('complaints').doc(complaintId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong!'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Complaint not found.'));
          }

          final complaint = snapshot.data!;
          final title = complaint['title'];
          final description = complaint['description'];
          final imageUrl = complaint['image'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                Text(description, style: TextStyle(fontSize: 18)),
                SizedBox(height: 16),
                imageUrl.isNotEmpty
                    ? Image.network(imageUrl)
                    : Container(),
              ],
            ),
          );
        },
      ),
    );
  }
}
