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
    'Quality and expiry of items in store inspections',
    'Standards of raw materials used (ISI/AGMARK/FPO/FSSAI)',
    'Insufficient staff or adequacy of food at counters',
    'Menu discrepancies or insufficient cooking quantities',
    'Lack of regular meetings and updates from mess supervisors',
    'Taste and quality of food',
    'Hygiene in kitchens, dining areas, and stores',
    'Cleanliness of utensils and serving tools',
    'Adherence to the menu and service timings',
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
      appBar: AppBar(title: Text('Generate Complaint')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Use a SingleChildScrollView for the dropdown to avoid overflow
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DropdownButton<String>(
                hint: Text('Select Issue Title'),
                value: _selectedTitle,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedTitle = newValue;
                  });
                },
                items: _complaintTitles.map<DropdownMenuItem<String>>((String title) {
                  return DropdownMenuItem<String>(
                    value: title,
                    child: Text(title),
                  );
                }).toList(),
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
              child: Text('Select Image'),
            ),
            if (_image != null) ...[
              SizedBox(height: 10),
              Image.file(_image!, width: 100, height: 100, fit: BoxFit.cover),
            ],
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _submitComplaint(context),
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
