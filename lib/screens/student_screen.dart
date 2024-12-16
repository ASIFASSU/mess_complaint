import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'lodge_complaint_screen.dart';
import '/services/sentiment_service.dart';
import '/services/duplicate_issue_service.dart';

class StudentScreen extends StatefulWidget {
  @override
  _StudentScreenState createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
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
          _username = doc['username'] ?? 'User';
        });
      }
    } catch (e) {
      setState(() {
        _username = 'User';
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

  // Fetch trending complaints (marked as trending)
  Stream<QuerySnapshot> getTrendingComplaints() {
    return _firestore
        .collection('complaints')
        .where('trending', isEqualTo: true)
        .orderBy('votes', descending: true)
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

  // Build list of trending issues
  Widget _buildTrendingIssues() {
    return StreamBuilder<QuerySnapshot>(
      stream: getTrendingComplaints(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error loading trending issues.'));
        }

        final trendingIssues = snapshot.data!.docs;

        if (trendingIssues.isEmpty) {
          return Center(child: Text('No trending issues right now.'));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: trendingIssues.length,
          itemBuilder: (context, index) {
            final issue = trendingIssues[index];
            final title = issue['title'];
            final votes = issue['votes'];

            return ListTile(
              title: Text(title),
              subtitle: Text('Votes: $votes'),
            );
          },
        );
      },
    );
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

            return Card(
              margin: EdgeInsets.all(8.0),
              child: ListTile(
                contentPadding: EdgeInsets.all(16.0),
                title: Text(title),
                subtitle: Text(description),
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
          Expanded(child: _buildTrendingIssues()),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'All Complaints',
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
            MaterialPageRoute(builder: (context) => GenerateComplaintScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
