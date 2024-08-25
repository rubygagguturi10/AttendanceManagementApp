import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'mainpage.dart'; // Import your mainpage.dart file

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController rolln = TextEditingController();

  CollectionReference ref = FirebaseFirestore.instance.collection('users');

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a Student'),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView( // Wrap the body with SingleChildScrollView
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    'assets/pg.webp', // Your GIF file path
                    height: 150, // Adjust size accordingly
                    width: 150,
                  ),
                ),
                const SizedBox(height: 20),
                // Title
                const Text(
                  'Add a Student',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Name TextField
                Container(
                  width: MediaQuery.of(context).size.width * 0.8, // Adjust width
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.purple, width: 2), // Purple border
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: name,
                    decoration: const InputDecoration(
                      hintText: 'Name',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Roll Number TextField
                Container(
                  width: MediaQuery.of(context).size.width * 0.8, // Adjust width
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.purple, width: 2), // Purple border
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: rolln,
                    decoration: const InputDecoration(
                      hintText: 'Roll Number',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Dropdowns
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        const Text('Department: '),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.3), // Purple transparent background
                            border: Border.all(color: Colors.purple), // Purple border
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DropdownButton<String>(
                            dropdownColor: Colors.purple, // Purple background for dropdown
                            isDense: true,
                            iconEnabledColor: Colors.white, // White icon color
                            underline: SizedBox(), // Remove underline
                            items: departments.map((String department) {
                              return DropdownMenuItem<String>(
                                value: department,
                                child: Text(
                                  department,
                                  style: const TextStyle(
                                    color: Colors.white, // White text color
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selectedDepartment = newValue!;
                                _updateClassIdentifier();
                              });
                            },
                            value: selectedDepartment,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('Division: '),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.3), // Purple transparent background
                            border: Border.all(color: Colors.purple), // Purple border
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DropdownButton<String>(
                            dropdownColor: Colors.purple, // Purple background for dropdown
                            isDense: true,
                            iconEnabledColor: Colors.white, // White icon color
                            underline: SizedBox(), // Remove underline
                            items: divisions.map((String division) {
                              return DropdownMenuItem<String>(
                                value: division,
                                child: Text(
                                  division,
                                  style: const TextStyle(
                                    color: Colors.white, // White text color
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selectedDivision = newValue!;
                                _updateClassIdentifier();
                              });
                            },
                            value: selectedDivision,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Add Button
                Container(
                  width: MediaQuery.of(context).size.width * 0.8, // Match the width of TextFields
                  child: MaterialButton(
                    color: Colors.purple, // Purple background color
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () {
                      ref.add({
                        'name': name.text,
                        'div': classIdentifier, // Store class identifier
                        'rollNo': rolln.text, // Ensure consistency with Firestore field
                      }).then((value) {
                        Fluttertoast.showToast(
                          msg: "Student added successfully",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                        // Clear text fields after adding
                        name.clear();
                        rolln.clear();
                        // Optionally reset dropdowns
                        setState(() {
                          selectedDepartment = 'CSE';
                          selectedDivision = 'A';
                          _updateClassIdentifier();
                        });
                        // Navigate to mainpage.dart after adding
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const MainPage()),
                        );
                      }).catchError((error) {
                        Fluttertoast.showToast(
                          msg: "Failed to add student: $error",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      });
                    },
                    child: const Text(
                      'ADD',
                      style: TextStyle(
                        color: Colors.white, // White text color
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

}
