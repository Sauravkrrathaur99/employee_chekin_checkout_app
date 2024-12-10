import 'package:flutter/material.dart';
import 'dart:async'; // For Timer class
import 'package:intl/intl.dart'; // For date formatting


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 1; // Default to Home page

  final List<Widget> _screens = [
    HistoryPage(), // History screen
    HomePageContent(), // Home screen
    UserPage(), // User screen
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'User',
          ),
        ],
      ),
    );
  }
}

class HomePageContent extends StatefulWidget {
  @override
  _HomePageContentState createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  int _start = 3600; // 1 hour countdown (in seconds)

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  // Timer function to update the countdown every second
  void _startTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (_start > 0) {
        setState(() {
          _start--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  // Format the countdown time as HH:mm:ss
  String get _formattedTime {
    int hours = _start ~/ 3600;
    int minutes = (_start % 3600) ~/ 60;
    int seconds = _start % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // Get the current date and day
  String get _formattedDate {
    final now = DateTime.now();
    return DateFormat('EEEE, MMM dd, yyyy').format(now); // Day of the week, Month day, Year
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            // Upper section (blue background) wrapped in SafeArea
            SafeArea(
              child: Container(
                color: Color(0xFF0F1C3E), // Dark blue background
                padding: EdgeInsets.all(16.0),
                height: MediaQuery.of(context).size.height * 0.30, // 30% of the screen height
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome, Saurav Kumar Rathaur, Glad to have you here',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center, // Center-align the text
                    ),
                    SizedBox(height: 20), // Add some space between the text and image
                    // Image centered below the text
                    Center(
                      child: Image.asset(
                        'assets/image_checkincheckout_home.png', // Replace with your image path
                        width: 250, // Width of the image (you can adjust as needed)
                        height: 250, // Height of the image (you can adjust as needed)
                        fit: BoxFit.contain, // Makes sure the image fits within the specified dimensions
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Lower section (white background) taking the remaining height
            Expanded(
              child: Container(
                color: Colors.white, // White background
                padding: EdgeInsets.all(16.0),
                child: GridView.count(
                  crossAxisCount: 2, // 2 boxes in each row
                  crossAxisSpacing: 16.0, // Space between boxes horizontally
                  mainAxisSpacing: 16.0, // Space between boxes vertically
                  children: [
                    _buildInfoBox(
                      'assets/set_location_attendance.png', // Image path for the first box
                      'Set Location WFH', // Text below the image
                    ),
                    _buildInfoBox(
                      'assets/set_location_attendance.png', // Replace with actual image path
                      'Another Action', // Text for the second box
                    ),
                    _buildInfoBox(
                      'assets/set_location_attendance.png', // Replace with actual image path
                      'Another Action', // Text for the third box
                    ),
                    _buildInfoBox(
                      'assets/set_location_attendance.png', // Replace with actual image path
                      'Another Action', // Text for the fourth box
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        // Cylindrical shape at the junction of the two sections
        Positioned(
          top: MediaQuery.of(context).size.height * 0.34 - 22, // Position it at the junction (adjusted to 30% height)
          left: (MediaQuery.of(context).size.width - 500) / 2, // Center it horizontally by subtracting half the width of the cylinder
          child: Container(
            width: 500, // Width of the cylindrical shape
            height: 80, // Increased height for accommodating the date and time
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25), // Rounded corners for cylindrical effect
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 5,
                  offset: Offset(0, 2), // Shadow to give it a floating effect
                ),
              ],
            ),
            child: Row(
              children: [
                // Left Section for the date display
                Expanded(
                  child: Container(
                    // color: Colors.blue[100], // Background color for the left section
                    child: Center(
                      child: Text(
                        _formattedDate, // Display the current date and day
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                // Center Section for the timer icon
                Expanded(
                  child: Container(
                    // color: Colors.green[100], // Background color for the center section
                    child: Center(
                      child: Icon(
                        Icons.timer, // Timer icon
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                // Right Section for the timer display
                Expanded(
                  child: Container(
                    // color: Colors.orange[100], // Background color for the right section
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Work Time: ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _formattedTime, // Display the timer
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Widget to create the transparent box with image and text below it
  Widget _buildInfoBox(String imagePath, String text) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7), // Transparent background with some opacity
        borderRadius: BorderRadius.circular(12), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4), // Shadow position
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath, // Display the image from the given path
            width: 150, // Adjust the size of the image as needed
            height: 150, // Adjust the size of the image as needed
            fit: BoxFit.cover, // Ensure the image fits properly
          ),
          SizedBox(height: 8),
          Text(
            text, // Text displayed below the image
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// History Page
class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('History Page', style: TextStyle(fontSize: 24)));
  }
}

// User Page
class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('User Page', style: TextStyle(fontSize: 24)));
  }
}