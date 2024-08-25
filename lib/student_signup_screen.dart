import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'mainpage.dart'; // Import your mainpage.dart file

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rollNoController = TextEditingController();

  String selectedDepartment = 'CSE'; // Default department
  String selectedDivision = 'A'; // Default division
  String classIdentifier = '';

  List<String> departments = [
    'CSE',
    'Artificial Intelligence',
    'ECE',
    'EEE',
    'Civil',
    'Mechanical',
    'Cyber Security',
    'Data Science',
  ];

  List<String> divisions = ['A', 'B', 'C'];

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    super.initState();
    _updateClassIdentifier();
  }

  void _updateClassIdentifier() {
    setState(() {
      classIdentifier = '$selectedDepartment$selectedDivision';
    });
  }

  Future<void> signUp() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      // Storing user data in Firestore
      await users.doc(userCredential.user!.uid).set({
        'name': nameController.text,
        'email': emailController.text,
        'rollNo': rollNoController.text,
        'department': selectedDepartment,
        'division': selectedDivision,
        'classIdentifier': classIdentifier,
      });

      Fluttertoast.showToast(
        msg: "Signup successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      // Navigate to mainpage.dart after successful signup
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to sign up: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Signup'),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/student.gif', // Update the path if needed
                  height: 100,
                  width: 300,
                ),
                const SizedBox(height: 20),
                // Title
                const Text(
                  'Create an Account',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Name TextField
                _buildTextField(
                  controller: nameController,
                  labelText: 'Name',
                  icon: Icons.person,
                ),
                const SizedBox(height: 10),

                // Email TextField
                _buildTextField(
                  controller: emailController,
                  labelText: 'Email',
                  icon: Icons.email,
                ),
                const SizedBox(height: 10),
                // Roll Number TextField
                _buildTextField(
                  controller: rollNoController,
                  labelText: 'Roll Number',
                  icon: Icons.confirmation_number,
                ),
                // Password TextField
                const SizedBox(height: 10),
                _buildTextField(
                  controller: passwordController,
                  labelText: 'Password',
                  obscureText: true,
                  icon: Icons.lock,
                ),
                const SizedBox(height: 30),

                // Dropdowns for Department and Division
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildDropdown(
                      label: 'Department',
                      value: selectedDepartment,
                      items: departments,
                      onChanged: (newValue) {
                        setState(() {
                          selectedDepartment = newValue!;
                          _updateClassIdentifier();
                        });
                      },
                    ),
                    _buildDropdown(
                      label: 'Division',
                      value: selectedDivision,
                      items: divisions,
                      onChanged: (newValue) {
                        setState(() {
                          selectedDivision = newValue!;
                          _updateClassIdentifier();
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Signup Button
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: MaterialButton(
                    color: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), // Change to make rectangular
                    ),
                    onPressed: () {
                      if (nameController.text.isEmpty ||
                          emailController.text.isEmpty ||
                          passwordController.text.isEmpty ||
                          rollNoController.text.isEmpty) {
                        Fluttertoast.showToast(
                          msg: "Please fill all fields",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                        return;
                      }
                      signUp();
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    bool obscureText = false,
    required IconData icon,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(icon, color: Colors.purple),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.purple),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.purple),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      children: [
        Text('$label: '),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
            color: Colors.purple,
            border: Border.all(color: Colors.purple),
            borderRadius: BorderRadius.circular(5), // Change to make rectangular
          ),
          child: DropdownButton<String>(
            dropdownColor: Colors.purple,
            isDense: true,
            iconEnabledColor: Colors.white,
            underline: SizedBox(),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
            value: value,
          ),
        ),
      ],
    );
  }
}
