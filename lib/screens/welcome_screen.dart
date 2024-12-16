import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFC0CB), // Rose color theme
      appBar: AppBar(
        backgroundColor: Color(0xFFFFC0CB), // Rose color theme
        elevation: 0,
      ),
      body: SingleChildScrollView(  // Make the content scrollable
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Main Heading (Bold RGUKT)
                Text(
                  'RGUKT',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),

                // Image
                Image.asset(
                  'assets/logo.png', // Replace with your image file
                  width: 300,
                  height: 310,
                ),
                SizedBox(height: 20),

                // Subtitle
                Text(
                  'Raise your issues freely',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 40),

                // Student Button
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Student Login
                    Navigator.pushNamed(context, '/login', arguments: 'Student');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Red color for button
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  ),
                  child: Text(
                    'Student',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),

                // Representative Button
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Representative Login
                    Navigator.pushNamed(context, '/login', arguments: 'Representative');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Red color for button
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  ),
                  child: Text(
                    'Representative',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),

                // Authority Button
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Authority Login
                    Navigator.pushNamed(context, '/login', arguments: 'Authority');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Red color for button
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  ),
                  child: Text(
                    'Authority',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
