import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MessageFeedbackScreen extends StatefulWidget {
  @override
  _MessageFeedbackScreenState createState() => _MessageFeedbackScreenState();
}

class _MessageFeedbackScreenState extends State<MessageFeedbackScreen> {
  final TextEditingController _remarksController = TextEditingController();
  final Map<String, double> _ratings = {
    'Timeliness of service': 0.0,
    'Cleanliness of the dining hall, plates, and surroundings': 0.0,
    'Food quality, including rice, snacks, tea, coffee, and breakfast': 0.0,
    'Quantity of food served as per the menu': 0.0,
    'Courtesy of mess staff towards students': 0.0,
    'Staff hygiene (uniforms, gloves, masks)': 0.0,
    'Cooking and serving adherence to the menu': 0.0,
    'Cleanliness of wash basins and wash areas': 0.0,
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.redAccent,
        scaffoldBackgroundColor: Colors.pink[50],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Mess Feedback'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Please provide your feedback for the following concerns:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ..._ratings.keys.map((concern) => _buildRatingRow(concern)).toList(),
              SizedBox(height: 20),
              Text(
                'Additional Remarks (Optional):',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _remarksController,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter any additional remarks...',
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _submitFeedback(context);
                  },
                  child: Text('Submit Feedback'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRatingRow(String concern) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            concern,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 10),
          RatingBar.builder(
            initialRating: _ratings[concern] ?? 0.0,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: 30.0,
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              setState(() {
                _ratings[concern] = rating;
              });
            },
          ),
        ],
      ),
    );
  }

  void _submitFeedback(BuildContext context) {
    bool allRated = _ratings.values.every((rating) => rating > 0);

    if (!allRated) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please provide ratings for all concerns.'),
        ),
      );
      return;
    }

    String remarks = _remarksController.text;
    Map<String, dynamic> feedbackData = {
      'ratings': _ratings,
      'remarks': remarks,
    };

    // Process feedbackData (e.g., save to Firestore or send via API)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Feedback submitted successfully!'),
      ),
    );

    _resetForm();
  }

  void _resetForm() {
    setState(() {
      _ratings.updateAll((key, value) => 0.0);
      _remarksController.clear();
    });
  }
}
