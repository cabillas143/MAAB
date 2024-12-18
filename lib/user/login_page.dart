import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redcross_mp/user/dashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers for email and password input fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // State variables
  bool _isPasswordVisible = false;
  String? _errorMessage;

  /// Handles user login
  Future<void> _login() async {
    // Validate input fields
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = "Email and Password cannot be empty.";
      });
      return;
    }

    try {
      // Sign in with Firebase Authentication
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = userCredential.user;

      // Check if email is verified
      if (user != null && !user.emailVerified) {
        await FirebaseAuth.instance.signOut();
        setState(() {
          _errorMessage = "Please verify your email before logging in.";
        });
        return;
      }

      // Update last login timestamp in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .update({'lastLogin': FieldValue.serverTimestamp()});

      // Navigate to Dashboard and pass the user's email
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardPage(email: user?.email ?? ''),
        ),
      );
    } on FirebaseAuthException catch (e) {
      // Handle Firebase Authentication exceptions
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e) {
      // Handle unexpected errors
      setState(() {
        _errorMessage = "An unexpected error occurred. Please try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: _buildLoginForm(),
      ),
    );
  }

  /// Builds the login form widget
  Widget _buildLoginForm() {
    return Column(
      children: [
        _buildHeader(),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildEmailField(),
              const SizedBox(height: 15),
              _buildPasswordField(),
              if (_errorMessage != null) _buildErrorMessage(),
              const SizedBox(height: 20),
              _buildLoginButton(),
              const SizedBox(height: 10),
              _buildSignupRedirect(),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds the header with a logo and welcome text
  Widget _buildHeader() {
    return Stack(
      children: [
        Container(
          height: 200,
          decoration: const BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo1.png', height: 80),
                const Text(
                  "Welcome Back",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Log in to your account",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the email input field
  Widget _buildEmailField() {
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.email),
        labelText: "Email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  /// Builds the password input field
  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock),
        labelText: "Password",
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  /// Displays error messages if any
  Widget _buildErrorMessage() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        _errorMessage!,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }

  /// Builds the login button
  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _login,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        "Login",
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  /// Builds the "Signup" redirection link
  Widget _buildSignupRedirect() {
    return Center(
      child: RichText(
        text: TextSpan(
          text: "Don't have an account? ",
          style: const TextStyle(color: Colors.black),
          children: [
            TextSpan(
              text: "Signup",
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pushNamed(context, '/signup');
                },
            ),
          ],
        ),
      ),
    );
  }
}
