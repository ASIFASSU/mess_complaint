import 'package:flutter/material.dart';

class MessRepresentativeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mess Representative Dashboard'),
      ),
      body: Center(
        child: Text(
          'Welcome, Mess Representative!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
