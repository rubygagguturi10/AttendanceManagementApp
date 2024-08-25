import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class TodayAttendanceScreen extends StatefulWidget {
  const TodayAttendanceScreen({super.key});

  @override
  _TodayAttendanceScreenState createState() => _TodayAttendanceScreenState();
}

class _TodayAttendanceScreenState extends State<TodayAttendanceScreen> {
  String _attendanceStatus = 'Not Marked';
  Color _statusColor = Colors.grey; // Default color if attendance is not marked
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _fetchAttendanceStatus();
  }

  Future<void> _fetchAttendanceStatus() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String userId = user.uid;
      String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

      try {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('attendance')
            .doc(userId)
            .collection('dates')
            .doc(today)
            .get();

        if (snapshot.exists) {
          String status = snapshot.get('status');
          setState(() {
            _attendanceStatus = status;
            _statusColor = (status == 'Present') ? Colors.green : Colors.red;
          });
        } else {
          setState(() {
            _attendanceStatus = 'Not Marked';
            _statusColor = Colors.grey;
          });
        }
      } catch (e) {
        setState(() {
          _attendanceStatus = 'Error fetching data';
          _statusColor = Colors.grey;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Today\'s Attendance: $_attendanceStatus',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: _statusColor, // Apply color based on attendance status
        ),
      ),
    );
  }
}
