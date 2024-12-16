import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  // TextEditingController to manage input for email, password, and confirm password
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  String? errorMessage; // Variable to hold error message for invalid input or registration

  final FirebaseAuth _auth = FirebaseAuth.instance; // FirebaseAuth instance to manage authentication

  // Function to handle the registration process
  Future<void> registerUser() async {
    setState(() {
      errorMessage = null;
    });

    // Check if the password and confirm password match
    if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        errorMessage = 'Passwords do not match'; // Show error if passwords don't match
      });
      return; // Exit if passwords don't match
    }

    try {
      // Try to create a user with email and password using Firebase Authentication
      await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Show a dialog to confirm successful registration
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Registration is Successful! Now go to the login page and login!'),
                  SizedBox(height: 20),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Button to navigate to the login page
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                        },
                        child: Text('Ok'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      // If there is an error during registration, display the error message
      setState(() {
        errorMessage = e.message; // Set the error message from Firebase exception
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Page'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text('Register Below'),
              SizedBox(height: 20),

              // Email input field
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Enter your Email',
                  hintText: 'example@yahoo.com',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),

              // Password input field
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Enter your Password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),

              // Confirm password input field
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm your Password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),

              // Display error message if there is any
              if (errorMessage != null)
                Text(
                  errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              SizedBox(height: 10),

              // Register button that triggers the registration process
              ElevatedButton(
                onPressed: registerUser,
                child: Text('Register'),
              ),
              SizedBox(height: 10),

              // "Register" image taken from internet
              Image.network(
                'data:image/jpeg;base64,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',
                height: 200,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 30),

              // Button for navigating to LoginPage if the user already has an account
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text('Have an account already? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}