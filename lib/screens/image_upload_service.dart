import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class ImageUploadService {
  static Future<void> uploadImageToDatabase(File image, String complaintId) async {
    try {
      // Upload the image to Firebase Storage
      final storageRef = FirebaseStorage.instance.ref().child('complaints/$complaintId/image');
      await storageRef.putFile(image);
    } catch (e) {
      print('Error uploading image: $e');
    }
  }
}
