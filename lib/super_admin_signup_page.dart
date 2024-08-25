import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart'; // Import eva_icons_flutter package

class SuperAdminSignupScreen extends StatelessWidget {
  const SuperAdminSignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Super Admin Signup')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hey, enter your details to create your account',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            _buildTextField(
              icon: Icons.person,
              hintText: 'Enter your name',
            ),
            _buildTextField(
              icon: Icons.email,
              hintText: 'Enter your Email',
            ),
            _buildTextField(
              icon: Icons.phone,
              hintText: 'Enter your Phone Number',
              keyboardType: TextInputType.phone,
            ),
            _buildTextField(
              icon: Icons.lock,
              hintText: 'Create Password',
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle signup logic here
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.purple,
              ),
              child: const Text('Sign Up', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Handle Google signup
                    },
                    icon: const Icon(
                      EvaIcons.google, // Default Google icon from Eva Icons
                      color: Colors.white,
                    ),
                    label: const Text('Google', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Background color
                      minimumSize: const Size(double.infinity, 40), // Reduced button size
                    ),
                  ),
                ),
                const SizedBox(width: 10), // Space between buttons
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Handle Facebook signup
                    },
                    icon: const Icon(
                      EvaIcons.facebook, // Default Facebook icon from Eva Icons
                      color: Colors.white,
                    ),
                    label: const Text('Facebook', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Background color
                      minimumSize: const Size(double.infinity, 40), // Reduced button size
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context); // Navigate back to login screen
                },
                child: const Text(
                  'Already have an account? ',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Navigate back to login screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple, // Button color
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required IconData icon,
    required String hintText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
