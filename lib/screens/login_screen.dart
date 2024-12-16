import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mess_management/screens/student_dashboard.dart';
import 'package:mess_management/screens/representative_dashboard.dart';
import 'package:mess_management/screens/authority_screen.dart';
import 'package:mess_management/screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorMessage = '';

  Future<void> _login() async {
    try {
      if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
        setState(() {
          _errorMessage = 'Email and password cannot be empty.';
        });
        return;
      }

      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (userCredential.user != null) {
        final email = userCredential.user?.email;

        if (email != null) {
          if (email == 'asifshaik7093@gmail.com') {
            Navigator.pushReplacementNamed(context, '/authority-screen');
          } else if (email == 'abdul@gmail.com') {
            Navigator.pushReplacementNamed(context, '/representative-dashboard');
          } else {
            Navigator.pushReplacementNamed(context, '/student-dashboard');
          }
        } else {
          setState(() {
            _errorMessage = 'Email not found.';
          });
        }
      } else {
        setState(() {
          _errorMessage = 'User not found or invalid credentials.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Invalid credentials. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8BBD0), // Rose color background
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Image Section with padding
              Container(
                width: 310,
                height: 187,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/login.png'), // Add your image here
                    fit: BoxFit.cover,
                  ),
                ),
                margin: EdgeInsets.only(bottom: 30), // Margin for spacing
              ),

              // Welcome Text
              Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Black color for welcome text
                ),
              ),
              SizedBox(height: 10),

              // Subtitle Text
              Text(
                'Please enter your credentials',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black, // Black color for subtitle text
                ),
              ),
              SizedBox(height: 20),

              // Email Field
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Enter your email',
                  labelStyle: TextStyle(color: Color(0xFFE91E63)), // Rose color
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE91E63)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE91E63)),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),

              // Password Field
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Enter your password',
                  labelStyle: TextStyle(color: Color(0xFFE91E63)), // Rose color
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE91E63)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE91E63)),
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 10),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Add your password recovery functionality here
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(color: Color(0xFFE91E63)), // Rose color
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Sign In Button
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE91E63), // Rose color
                ),
                child: Text(
                  'Sign In',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 20),

              // Sign Up Option
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupScreen()), // Navigate to SignupScreen
                  );
                },
                child: Text(
                  'Not a member? Sign up',
                  style: TextStyle(color: Color(0xFFE91E63)), // Rose color
                ),
              ),

              // Error Message
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
