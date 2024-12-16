import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mess_management/screens/login_screen.dart'; // Import the Login screen

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _usernameController = TextEditingController();
  final _idController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorMessage = '';
  String? _selectedMessNumber;

  Future<void> _signup() async {
    try {
      if (_usernameController.text.isEmpty ||
          _idController.text.isEmpty ||
          _emailController.text.isEmpty ||
          _passwordController.text.isEmpty ||
          _selectedMessNumber == null) {
        setState(() {
          _errorMessage = 'Please fill in all fields.';
        });
        return;
      }

      // Create a new user
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Navigate back to the login screen after signup
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
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
              // Signup Image
              Image.asset(
                'assets/signup.png', // Make sure to add an image in the assets folder
                width: 310,
                height: 187,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 20),

              // Welcome Text
              Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Black color for title
                ),
              ),
              SizedBox(height: 20),

              // Username Field
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Enter your username',
                  labelStyle: TextStyle(color: Color(0xFFE91E63)), // Rose color
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE91E63)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE91E63)),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // ID Number Field
              TextField(
                controller: _idController,
                decoration: InputDecoration(
                  labelText: 'Enter your ID Number',
                  labelStyle: TextStyle(color: Color(0xFFE91E63)), // Rose color
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE91E63)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE91E63)),
                  ),
                ),
                keyboardType: TextInputType.number,
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
              SizedBox(height: 20),

              // Mess Selection Grid View
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: 8,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedMessNumber = (index + 1).toString();
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: _selectedMessNumber == (index + 1).toString()
                            ? Color(0xFFE91E63) // Highlight selected mess
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Color(0xFFE91E63),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Mess No. ${index + 1}',
                          style: TextStyle(
                            color: _selectedMessNumber == (index + 1).toString()
                                ? Colors.white
                                : Color(0xFFE91E63),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),

              // Sign Up Button
              ElevatedButton(
                onPressed: _signup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE91E63), // Rose color
                ),
                child: Text(
                  'Register',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 20),

              // Error Message
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ),

              // Login Option
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()), // Navigate to LoginScreen
                  );
                },
                child: Text(
                  'Already a user? Login',
                  style: TextStyle(color: Color(0xFFE91E63)), // Rose color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
