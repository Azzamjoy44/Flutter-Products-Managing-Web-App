import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'products.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController(); // Controller for email input
  final TextEditingController passwordController = TextEditingController(); // Controller for password input
  String? errorMessage; // Variable to store the error message (if any)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: SingleChildScrollView( // Wraps the whole body in a scrollable view
        child: Column(
          children: [
            Text('Please login'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[

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
                  SizedBox(height: 5),

                  // Display error message if there is one
                  if (errorMessage != null)
                    Text(
                      errorMessage!,
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  SizedBox(height: 10),

                  // Login button
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        errorMessage = null; // Clear any previous error message
                      });
                      try {
                        // Firebase Authentication to log the user in
                        await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                            email: emailController.text, // Get email from controller
                            password: passwordController.text); // Get password from controller

                        // On successful login, navigate to the ProductPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductPage()),
                        );
                      } on FirebaseAuthException catch (e) {
                        // Catch Firebase authentication exceptions
                        setState(() {
                          // Set the error message when the login fails
                          errorMessage = e.message;
                        });
                      }
                    },
                    child: Text('Login'),
                  ),
                  SizedBox(height: 10),

                  // "Login" image taken from internet
                  Image.network(
                    'data:image/jpeg;base64,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',
                    height: 200, // Adjust the fit to ensure the image fits properly
                    //width: 250,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 40),

                  //Register button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()), // Navigate to the RegisterPage
                      );
                    },
                    child: Text('Don\'t have an account? Register now'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
