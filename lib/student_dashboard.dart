import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StudentDashboard extends StatefulWidget {
  final String rollNo;

  const StudentDashboard({super.key, required this.rollNo});

  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  Map<String, bool> attendanceMap = {};
  String name = '';
  String division = '';
  String status = '';

  @override
  void initState() {
    super.initState();
    _loadStudentData();
  }

  void _loadStudentData() async {
    try {
      // Query Firestore to get the student's document based on rollNo
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('rollNo', isEqualTo: widget.rollNo)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        var userDoc = userSnapshot.docs.first;

        // Get student details
        setState(() {
          name = userDoc.get('name');
          division = userDoc.get('div');
          status = userDoc.get('status');
        });

        // Now get the attendance collection for this student
        QuerySnapshot attendanceSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userDoc.id)
            .collection('attendance')
            .get();

        // Populate the attendanceMap with the retrieved data
        Map<String, bool> loadedAttendance = {};
        for (var doc in attendanceSnapshot.docs) {
          loadedAttendance[doc.id] = doc['status'];
        }

        setState(() {
          attendanceMap = loadedAttendance;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Roll number not found.'),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load data: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance History'),
        backgroundColor: Colors.purple,
        // Removed the download button
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: Image.asset(
              'assets/attendance.gif',
              height: 200, // Adjust size as needed
              width: 500,
            ),
          ),
          // Display student details
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name: $name',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Roll No: ${widget.rollNo}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Division: $division',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Status: $status',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Display attendance records
        ],
      ),
    );
  }
}
