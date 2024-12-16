import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/services/sentiment_service.dart';
import 'lodge_complaint_screen.dart';
import 'mess_feedback_screen.dart'; // Import your mess feedback screen
import 'menu_screen.dart'; // Import your menu screen

class StudentDashboard extends StatefulWidget {
  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _username = '';
  int _selectedIndex = 0; // Track selected index for bottom navigation

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

  // Handle voting for a complaint
  Future<void> _voteComplaint(BuildContext context, String complaintId, int currentVotes) async {
    try {
      // Use Firestore transactions to ensure atomic updates
      await _firestore.runTransaction((transaction) async {
        final complaintRef = _firestore.collection('complaints').doc(complaintId);
        final snapshot = await transaction.get(complaintRef);

        if (!snapshot.exists) return;

        final newVotes = (snapshot['votes'] ?? 0) + 1;
        transaction.update(complaintRef, {'votes': newVotes});
      });

      // Call sentiment analysis and duplicate issue detection
      SentimentService.analyzeSentiment(complaintId);


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
            final votes = complaint['votes'] ?? 0;
            final status = complaint['status'] ?? 'Acknowledged';

            // Get the image URL if it exists
            final data = complaint.data() as Map<String, dynamic>;
            final imageUrl = data.containsKey('image') ? data['image'] : null;

            return Card(
              margin: EdgeInsets.all(16.0),
              elevation: 8,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    title: Text(
                      title,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(description, style: TextStyle(fontSize: 16)),
                        SizedBox(height: 8),
                        Text('Status: $status',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: status == 'Resolved'
                                    ? Colors.green
                                    : (status == 'In Progress'
                                    ? Colors.orange
                                    : Colors.blue))),
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
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: ElevatedButton.icon(
                      onPressed: () => _voteComplaint(context, complaintId, votes),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.red, // Text color
                      ),
                      icon: Icon(Icons.how_to_vote), // Raised hand icon for upvote
                      label: Text('Up Vote'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Bottom navigation bar change handler
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to respective screens based on the index
    switch (index) {
      case 0: // Home - Dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => StudentDashboard()),
        );
        break;
      case 1: // Complaint Generation
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GenerateComplaintScreen()),
        );
        break;
      case 2: // Mess Feedback
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MessageFeedbackScreen()), // Assuming you have MessFeedbackScreen
        );
        break;
      case 3: // Menu
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MenuScreen()), // Assuming you have MenuScreen
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent, // Rose color for AppBar
        title: Text(
          'Hello, $_username!',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Handle notification icon press
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.red[50], // Light red background color for body
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Trending Issues',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(child: _buildComplaintList()),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.red, // Set selected icon color to red
        unselectedItemColor: Colors.grey, // Set unselected icon color to grey
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report),
            label: 'Complaint',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feedback),
            label: 'Mess Feedback',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menu',
          ),
        ],
      ),
    );
  }
}
