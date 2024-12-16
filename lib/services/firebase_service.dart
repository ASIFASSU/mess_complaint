import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> getTotalComplaints() async {
    var snapshot = await _firestore.collection('complaints').get();
    return snapshot.size;
  }

  Future<List<Map<String, dynamic>>> getComplaintTrends() async {
    var snapshot = await _firestore.collection('complaint_trends').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<List<Map<String, dynamic>>> getCategoriesOverview() async {
    var snapshot = await _firestore.collection('categories').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<List<Map<String, dynamic>>> getHighPriorityComplaints() async {
    var snapshot = await _firestore.collection('high_priority_complaints').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<List<Map<String, dynamic>>> getPendingTasks() async {
    var snapshot = await _firestore.collection('pending_tasks').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
