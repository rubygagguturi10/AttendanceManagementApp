import 'package:atds/add.dart';
import 'package:atds/faculty_login_screen.dart';
import 'package:atds/mainpage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FacultyDashboard extends StatefulWidget {
  const FacultyDashboard({super.key});

  @override
  _FacultyDashboardState createState() => _FacultyDashboardState();
}

class _FacultyDashboardState extends State<FacultyDashboard> {
  int _selectedIndex = 0;
  bool _isDrawerOpen = false;
  String? _facultyEmail; // To store the email of the logged-in faculty

  @override
  void initState() {
    super.initState();
    _getCurrentUserEmail(); // Fetch the logged-in faculty's email
  }

  void _getCurrentUserEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _facultyEmail = user.email; // Store the logged-in email
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleDrawer() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      const ProfileInformationScreen(),

      // Add Student Screen with GIF
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add GIF above the Add button
            Image.asset(
              'assets/add.gif', // Your GIF file path
              height:400, // Adjust size accordingly
              width: 400,
            ),
             // Space between GIF and button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddStudentScreen()),
                );
              },
              label: const Text('ADD', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                backgroundColor: Colors.purple,
              ),
            ),
          ],
        ),
      ),

      // Mark Attendance Screen with GIF
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add GIF above the Mark button
            Image.asset(
              'assets/check-green.gif', // Your GIF file path
              height: 150, // Adjust size accordingly
              width: 150,
            ),
            const SizedBox(height: 20), // Space between GIF and button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MainPage()),
                );
              },
              label: const Text('MARK', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                backgroundColor: Colors.purple,
              ),
            ),
          ],
        ),
      ),
  const NotificationsScreen(),
    ];

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Faculty Dashboard'),
            backgroundColor: Colors.purple,
            leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: _toggleDrawer,
            ),
          ),
          body: _widgetOptions.elementAt(_selectedIndex),
        ),
        if (_isDrawerOpen)
          GestureDetector(
            onTap: _toggleDrawer,
            child: Container(
              color: Colors.purple.withOpacity(0.6), // Semi-transparent background
            ),
          ),
        if (_isDrawerOpen)
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            child: Drawer(
              elevation: 16.0,
              child: Column(
                children: <Widget>[
                  DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Colors.purple,
                    ),
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage('assets/giphy.webp'), // Static profile photo
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _facultyEmail ?? 'Loading...', // Display faculty email
                          style: const TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(Icons.person),
                          title: const Text('Profile'),
                          onTap: () {
                            _onItemTapped(0);
                            _toggleDrawer(); // Close the drawer
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.add),
                          title: const Text('Add Student'),
                          onTap: () {
                            _onItemTapped(1);
                            _toggleDrawer(); // Close the drawer
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.check),
                          title: const Text('Mark Attendance'),
                          onTap: () {
                            _onItemTapped(2);
                            _toggleDrawer(); // Close the drawer
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.notifications),
                          title: const Text('Notifications'),
                          onTap: () {
                            _onItemTapped(3);
                            _toggleDrawer(); // Close the drawer
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.exit_to_app),
                          title: const Text('Logout'),
                          onTap: () {
                            FirebaseAuth.instance.signOut();
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class ProfileInformationScreen extends StatefulWidget {
  const ProfileInformationScreen({super.key});

  @override
  _ProfileInformationScreenState createState() =>
      _ProfileInformationScreenState();
}

class _ProfileInformationScreenState extends State<ProfileInformationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchProfileInformation();
  }

  Future<void> _fetchProfileInformation() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userProfile = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      setState(() {
        _nameController.text = userProfile.get('name');
        _emailController.text = userProfile.get('email');
        _contactController.text = userProfile.get('contact');
      });
    }
  }

  Future<void> _updateProfileInformation() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'name': _nameController.text,
        'email': _emailController.text,
        'contact': _contactController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/giphy.webp'), // Static profile photo
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.purple),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.purple),
              ),
            ),
            readOnly: true,
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _contactController,
            decoration: InputDecoration(
              labelText: 'Contact',
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.purple),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: _updateProfileInformation,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                backgroundColor: Colors.purple,
              ),
              child: const Text(
                'Update Profile',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for notifications
    final notifications = [
      'Low attendance alert: Your class attendance is below 75%',
      'Upcoming meeting: Faculty meeting on 25th August',
      'Assignment deadline: Submit the project by 10th August',
    ];

    return Column(
      children: [
        // Add GIF before the notifications list
        Center(
          child: Image.asset(
            'assets/bell.gif', // Your GIF file path
            height: 150, // Adjust size accordingly
            width: 150,
          ),
        ),
        const SizedBox(height: 20), // Add spacing between GIF and list
        Expanded(
          child: ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.notification_important),
                title: Text(notifications[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}


void main() {
  runApp(MaterialApp(
    home: FacultyDashboard(),
    routes: {
      '/login': (context) => FacultyLoginScreen(), // Replace with your login screen widget
    },
  ));
}
