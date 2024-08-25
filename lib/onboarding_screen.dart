import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'student_login_screen.dart';
import 'super_admin_login_screen.dart';
import 'faculty_login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  String _selectedRole = 'Select Role';

  void _navigateToRoleScreen(String role) {
    Widget screen;
    switch (role) {
      case 'Super Admin':
        screen = const SuperAdminLoginScreen();
        break;
      case 'Faculty':
        screen = const FacultyLoginScreen();
        break;
      case 'Student':
        screen = const StudentLoginScreen();
        break;
      default:
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: Colors.purple, // Background color of the dropdown
                  borderRadius: BorderRadius.circular(8), // Rectangular border
                ),
                child: DropdownButton<String>(
                  value: _selectedRole,
                  items: <String>['Select Role', 'Super Admin', 'Faculty', 'Student']
                      .map((String role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Row(
                        children: [
                          if (role == 'Select Role')
                            Icon(Icons.person, color: Colors.white), // Profile icon for Select Role
                          SizedBox(width: 8), // Space between icon and text
                          Text(role, style: TextStyle(color: Colors.white)), // Text color
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newRole) {
                    setState(() {
                      _selectedRole = newRole!;
                      if (_selectedRole != 'Select Role') {
                        _navigateToRoleScreen(_selectedRole);
                      }
                    });
                  },
                  hint: Row(
                    children: [
                      if (_selectedRole == 'Select Role')
                        Icon(Icons.person, color: Colors.white), // Profile icon in hint
                      SizedBox(width: 8), // Space between icon and hint text
                      Text('Select Role', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  dropdownColor: Colors.purple, // Dropdown menu background color
                  underline: SizedBox(), // Hides the underline
                  icon: Icon(Icons.arrow_drop_down, color: Colors.white), // Dropdown icon color
                ),
              ),
            ),
          ),
        ],
      ),
      body: IntroductionScreen(
        pages: [
          PageViewModel(
            titleWidget: const Text(""),
            bodyWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Easy Registration and SignIn",
                  style: TextStyle(
                    color: Colors.purple,
                    fontSize: 24, // Increase the font size
                    fontWeight: FontWeight.bold, // Make the text bold
                  ),
                ),
                SizedBox(height: 30,),
                Image.asset(
                  "assets/login.gif",
                  width: 300,
                  height: 300,
                  fit: BoxFit.fill,
                ),
                SizedBox(height: 50,),
                const Text(
                  "This is an attendance app for university students",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          PageViewModel(
            titleWidget: const Text(""),
            bodyWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Filter Through Depts.",
                  style: TextStyle(
                    color: Colors.purple,
                    fontSize: 24, // Increase the font size
                    fontWeight: FontWeight.bold, // Make the text bold
                  ),
                ),
                SizedBox(height: 30,),
                Image.asset(
                  "assets/document.gif",
                  width: 300,
                  height: 300,
                  fit: BoxFit.fill,
                ),
                SizedBox(height: 50,),
                const Text(
                  "This is an attendance app for university students",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          PageViewModel(
            titleWidget: const Text(""),
            bodyWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Mark Your Attendance",
                  style: TextStyle(
                    color: Colors.purple,
                    fontSize: 24, // Increase the font size
                    fontWeight: FontWeight.bold, // Make the text bold
                  ),
                ),

                SizedBox(height: 30.0,),
                Image.asset(
                  "assets/verified.gif",
                  width: 300,
                  height: 300,
                  fit: BoxFit.fill,
                ),
                SizedBox(height: 50.0,),
                const Text(
                  "This is an attendance app for university students",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
        onDone: () {
          // Handle action when onboarding is done if needed
        },
        showBackButton: false,
        showNextButton: false,
        showSkipButton: true,
        skip: const Text("Skip"),
        showDoneButton: true,
        done: const Text("Done"),
      ),
    );
  }
}
