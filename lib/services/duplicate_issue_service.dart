import 'package:cloud_firestore/cloud_firestore.dart';

class DuplicateIssueService {
  static Future<void> analyzeDuplicate(String complaintId) async {
    try {
      final complaintDoc = await FirebaseFirestore.instance
          .collection('complaints')
          .doc(complaintId)
          .get();
      final description = complaintDoc['description'];

      // Logic for duplicate issue analysis (e.g., comparing with existing complaints)
      final querySnapshot = await FirebaseFirestore.instance
          .collection('complaints')
          .where('description', isEqualTo: description)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Mark the complaint as duplicate without voting
        await FirebaseFirestore.instance
            .collection('complaints')
            .doc(complaintId)
            .update({'duplicate': true});

        print("Duplicate issue detected. Marked as duplicate.");
      }
    } catch (e) {
      print("Duplicate Issue Analysis Failed: $e");
    }
  }
}
