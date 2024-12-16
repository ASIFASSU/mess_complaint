import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login.dart';
import 'screens/student_dashboard.dart';
import 'screens/representative_dashboard.dart';
import 'providers/user_provider.dart';
import 'services/firebase_service.dart';
import 'utils/constants.dart';
import 'firebase_core/firebase_core.dart'; // Import Firebase

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()), // State Management
        Provider(create: (_) => FirebaseService()),            // Firebase Service
      ],
      child: MaterialApp(
        title: 'Mess Complaint App',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginScreen(),
          '/student_dashboard': (context) => StudentDashboard(),
          '/representative_dashboard': (context) => RepresentativeDashboard(),
          // Add other screens as needed...
        },
      ),
    );
  }
}
