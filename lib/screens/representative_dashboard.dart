import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/services/sentiment_service.dart';
import '/services/duplicate_issue_service.dart';
import 'lodge_complaint_rep.dart';

class RepresentativeDashboard extends StatefulWidget {
  @override
  _RepresentativeDashboardState createState() =>
      _RepresentativeDashboardState();
}

class RepresentativeDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Representative Dashboard')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('complaints').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading complaints'));
          }

          final complaints = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: complaints.length,
            itemBuilder: (context, index) {
              final complaint = complaints[index];
              final title = complaint['title'];
              final description = complaint['description'];

              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  title: Text(title),
                  subtitle: Text(description),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GenerateComplaintScreen(), // Representative
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}


class _RepresentativeDashboardState extends State<RepresentativeDashboard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _username = '';

  @override
  void initState() {
    super.initState();
    _fetchUsername();
  }

  // Fetch the username of the logged-in user
  Future<void> _fetchUsername() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        setState(() {
          _username = doc['username'] ?? 'Representative';
        });
      }
    } catch (e) {
      setState(() {
        _username = 'Representative';
      });
    }
  }

  // Fetch all complaints from Firestore
  Stream<QuerySnapshot> getComplaints() {
    return _firestore
        .collection('complaints')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Handle voting for a complaint
  Future<void> _voteComplaint(BuildContext context, String complaintId, int currentVotes) async {
    try {
      await _firestore.collection('complaints').doc(complaintId).update({
        'votes': currentVotes + 1,
      });

      // Call sentiment analysis and duplicate issue detection
      SentimentService.analyzeSentiment(complaintId);
      DuplicateIssueService.analyzeDuplicate(complaintId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Voted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to vote. Please try again.')),
      );
    }
  }

  // Build the list of all complaints
  Widget _buildComplaintList() {
    return StreamBuilder<QuerySnapshot>(
      stream: getComplaints(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong!'));
        }

        final complaints = snapshot.data!.docs;

        return ListView.builder(
          itemCount: complaints.length,
          itemBuilder: (context, index) {
            final complaint = complaints[index];
            final complaintId = complaint.id;
            final title = complaint['title'];
            final description = complaint['description'];
            final votes = complaint['votes'];

            // Get the image URL if it exists
            final data = complaint.data() as Map<String, dynamic>;

            final imageUrl = data.containsKey('image') ? data['image'] : null;
            final storageRef = FirebaseStorage.instance.ref(imageUrl);

            return Card(
              margin: EdgeInsets.all(8.0),
              child: ListTile(
                contentPadding: EdgeInsets.all(16.0),
                title: Text(title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(description),
                    SizedBox(height: 4),
                    Text('Votes: $votes', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                trailing: imageUrl != null
                    ? Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover)
                    : null,
                onTap: () {
                  // Navigate to complaint details screen
                  Navigator.pushNamed(context, '/complaint-details', arguments: complaintId);
                },
                leading: IconButton(
                  icon: Icon(Icons.thumb_up),
                  onPressed: () => _voteComplaint(context, complaintId, votes),
                ),
                isThreeLine: true,
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello, $_username!'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Trending Issues',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: _buildComplaintList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GenerateComplaintScreen( )),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
