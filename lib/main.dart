import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login_screen.dart';
import 'screens/student_dashboard.dart';
import 'screens/representative_dashboard.dart';
import 'screens/authority_screen.dart';
import 'screens/welcome_screen.dart'; // Import Welcome Screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MessComplaintApp());
}

class MessComplaintApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mess Complaint App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/welcome': (context) => WelcomeScreen(),
        '/login': (context) => LoginScreen(),
        '/student-dashboard': (context) => StudentDashboard(),
        '/representative-dashboard': (context) => RepresentativeDashboard(),
        '/authority-screen': (context) => AuthorityDashboard(),
      },
      initialRoute: '/welcome', // Set Welcome Screen as the initial route
    );
  }
}
