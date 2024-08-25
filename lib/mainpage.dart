import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'makepdf.dart'; // Ensure this import is correct

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String selectedDepartment = 'CSE';
  String selectedDivision = 'A';
  String classIdentifier = '';
  String selectedFilter = 'ALL';

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

  List<Map<String, dynamic>> studentList = [];
  Map<String, String> studentStatusMap = {}; // Tracks student status as Present/Absent

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

  // Function to update attendance status
  void _updateAttendanceStatus(String rollNo, String status) {
    setState(() {
      studentStatusMap[rollNo] = status;
    });
  }

  // Function to submit attendance and update Firestore
  Future<void> _submitAttendance() async {
    final batch = FirebaseFirestore.instance.batch();

    for (final student in studentList) {
      final rollNo = student['rollNo'];
      final status = studentStatusMap[rollNo] ?? 'Absent';

      final query = await FirebaseFirestore.instance
          .collection('users')
          .where('rollNo', isEqualTo: rollNo)
          .where('div', isEqualTo: classIdentifier)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        final docRef = query.docs.first.reference;
        batch.update(docRef, {
          'status': status,
          'div': classIdentifier, // Update the status field
        });
      }
    }

    await batch.commit();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Attendance submitted successfully!')),
    );
  }

  // Function to delete a student
  Future<void> _deleteStudent(String rollNo) async {
    final query = await FirebaseFirestore.instance
        .collection('users')
        .where('rollNo', isEqualTo: rollNo)
        .where('div', isEqualTo: classIdentifier)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      final docRef = query.docs.first.reference;
      await docRef.delete();
      setState(() {
        studentList.removeWhere((student) => student['rollNo'] == rollNo);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Student deleted successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance
        .collection('users')
        .where('div', isEqualTo: classIdentifier)
        .snapshots();

    return SafeArea(
        child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
        onPressed: () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Reportt(
            list: studentList,
            clas: classIdentifier,
          ),
        ),
      );
    },
    child: const Icon(Icons.send),
    ),
    appBar: AppBar(
    title: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    const Text(
    'Attendance Page',
    style: TextStyle(fontSize: 15),
    ),
    Expanded(
    child: Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
    Flexible(
    child: Container(
    decoration: BoxDecoration(
    border: Border.all(color: Colors.white),
    borderRadius: BorderRadius.circular(20),
    ),
    child: DropdownButton<String>(
    dropdownColor: Colors.white,
    isDense: true,
    iconEnabledColor: Colors.black,
    isExpanded: true,
    items: departments.map((String department) {
    return DropdownMenuItem<String>(
    value: department,
    child: Text(
    department,
    style: const TextStyle(
    color: Colors.black,
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
    style: const TextStyle(color: Colors.black),
    ),
    ),
    ),
    const SizedBox(width: 10),
    Flexible(
    child: Container(
    decoration: BoxDecoration(
    border: Border.all(color: Colors.white),
    borderRadius: BorderRadius.circular(20),
    ),
    child: DropdownButton<String>(
    dropdownColor: Colors.white,
    isDense: true,
    iconEnabledColor: Colors.black,
    isExpanded: true,
    items: divisions.map((String division) {
    return DropdownMenuItem<String>(
    value: division,
    child: Text(
    division,
    style: const TextStyle(
    color: Colors.black,
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
    style: const TextStyle(color: Colors.black),
    ),
    ),
    ),
    ],
    ),
    ),
    ],
    ),
    ),
    body: Column(
    children: [
    Container(
    color: Colors.white,
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
    _buildFilterButton('ALL'),
    _buildFilterButton('Present'),
    _buildFilterButton('Absent'),
    ],
    ),
    ),
    Expanded(
    child: StreamBuilder(
    stream: usersStream,
    builder: (BuildContext context,
    AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.hasError) {
    return const Center(child: Text("Something is wrong"));
    }
    if (snapshot.connectionState == ConnectionState.waiting) {
    return const Center(child: CircularProgressIndicator());
    }

    studentList = snapshot.data!.docs.map((doc) {
    final rollNo = doc['rollNo'];
    if (!studentStatusMap.containsKey(rollNo)) {
    studentStatusMap[rollNo] = 'Present'; // Default to Present
    }
    return {
    'name': doc['name'],
    'rollNo': rollNo,
    'status': studentStatusMap[rollNo],
    };
    }).toList();

    List<Map<String, dynamic>> filteredList = studentList;
    if (selectedFilter == 'Present') {
    filteredList = studentList
        .where((student) => student['status'] == 'Present')
        .toList();
    } else if (selectedFilter == 'Absent') {
    filteredList = studentList
        .where((student) => student['status'] == 'Absent')
        .toList();
    }

    return ListView.builder(
    itemCount: filteredList.length,
    itemBuilder: (context, index) {
    final student = filteredList[index];
    return ListTile(
    title: Text(student['name']),
    subtitle: Text(student['rollNo']),
    trailing: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
    Radio<String>(
    value: 'Present',
    groupValue: student['status'],
    onChanged: (value) {
    _updateAttendanceStatus(student['rollNo'], value!);
    },
    ),
    const Text('Present', style: TextStyle(color: Colors.black)),
    Radio<String>(
    value: 'Absent',
    groupValue: student['status'],
    onChanged: (value) {
    _updateAttendanceStatus(student['rollNo'], value!);
    },
    ),
    const Text('Absent', style: TextStyle(color: Colors.black)),
    IconButton(
    icon: const Icon(Icons.delete, color: Colors.red),
    onPressed: () async {
    final rollNo = student['rollNo'];

    // Show confirmation dialog before deleting
    bool? confirmDelete = await showDialog<bool>(
    context: context,
    builder: (context) {
    return AlertDialog(
    title: const Text('Confirm Delete'),
    content: const Text('Are you sure you want to delete this student?'),
    actions: [
    TextButton(
    onPressed: () {
    Navigator.of(context).pop(false); // Cancel deletion
    },
    child: const Text('Cancel'),
    ),
    TextButton(
    onPressed: () {
    Navigator.of(context).pop(true); // Confirm deletion
    },
    child: const Text('Delete'),
    ),
    ],
    );
    },
    );

    if (confirmDelete ?? false) {
    await _deleteStudent(rollNo);
    }
    },
    ),
    ],
    ),
    );
    },
    );
    },
    ),
    ),
    // Submit button
      // Submit button
      Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: ElevatedButton(
          onPressed: () async {
            await _submitAttendance();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple, // Background color
            // Text color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'Submit Attendance',
            style: TextStyle(
              color: Colors.white,
                fontSize: 16),
          ),
        ),
      ),
    ],
    ),
        ),
    );
  }

  Widget _buildFilterButton(String filter) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedFilter = filter;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedFilter == filter ? Colors.purple : Colors.grey[300], // Background color// Text color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        filter,
        style: const TextStyle(fontSize: 16,
        color: Colors.white),
      ),
    );
  }
}

