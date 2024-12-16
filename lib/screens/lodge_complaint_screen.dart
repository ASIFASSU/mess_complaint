import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'image_upload_service.dart'; // Import your upload service

class GenerateComplaintScreen extends StatefulWidget {
  @override
  _GenerateComplaintScreenState createState() =>
      _GenerateComplaintScreenState();
}

class _GenerateComplaintScreenState extends State<GenerateComplaintScreen> {
  final _descriptionController = TextEditingController();
  String? _selectedTitle;
  File? _image;

  final List<String> _complaintTitles = [
    'Timeliness of service',
    'Cleanliness of the dining hall, plates, and surroundings',
    'Food quality, including rice, snacks, tea, coffee, and breakfast',
    'Quantity of food served as per the menu',
    'Courtesy of mess staff towards students',
    'Staff hygiene (uniforms, gloves, masks)',
    'Cooking and serving adherence to the menu',
    'Cleanliness of wash basins and wash areas',
    'Other (Specify below)'
  ];

  Future<void> _submitComplaint(BuildContext context) async {
    final description = _descriptionController.text;

    if (_selectedTitle == null || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a title and provide a description')),
      );
      return;
    }

    try {
      // Create a unique ID for the complaint
      final complaintId = FirebaseDatabase.instance.ref().child('complaints').push().key;

      // Save complaint details to Realtime Database
      final complaintData = {
        'title': _selectedTitle,
        'description': description,
        'votes': 0,
        'timestamp': DateTime.now().toIso8601String(),
      };
      final databaseRef = FirebaseDatabase.instance.ref('complaints/$complaintId');
      await databaseRef.set(complaintData);

      // Upload image if selected
      if (_image != null) {
        await ImageUploadService.uploadImageToDatabase(_image!, complaintId!);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Complaint generated successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate complaint. Try again.')),
      );
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate Complaint'),
        backgroundColor: Colors.redAccent, // Rose red color
      ),
      body: Container(
        color: Colors.red[50], // Light rose red background
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Use a GridView to display complaint titles
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Display titles in 2 columns
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _complaintTitles.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTitle = _complaintTitles[index];
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _selectedTitle == _complaintTitles[index]
                            ? Colors.redAccent
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.redAccent),
                      ),
                      child: Center(
                        child: Text(
                          _complaintTitles[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _selectedTitle == _complaintTitles[index]
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_selectedTitle == 'Other (Specify below)')
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Please specify the title'),
              ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent, // Red color for the button
              ),
              child: Text('Select Image'),
            ),
            if (_image != null) ...[
              SizedBox(height: 10),
              Image.file(_image!, width: 100, height: 100, fit: BoxFit.cover),
            ],
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _submitComplaint(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent, // Red color for the button
              ),
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
