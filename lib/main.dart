import 'package:flutter/material.dart';
import 'dart:async'; // For Timer class
import 'dart:developer' as developer;
import 'package:intl/intl.dart'; // For date formatting
import 'login.dart'; // Import the login page
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 1; // Default to Home page

  final List<Widget> _screens = [
    const HistoryPage(), // History screen
    const HomePageContent(), // Home screen
    const UserPage(), // User screen
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _screens[_currentIndex], // Display the selected screen within SafeArea
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
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
  const HomePageContent({super.key});

  @override
  _HomePageContentState createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  int _start = 3600; // 1 hour countdown (in seconds)
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  ConnectivityResult _connectionStatus = ConnectivityResult.none; // Declare connection status
  String _wifiStatus = "Unknown Connectivity Status"; // To hold the connectivity status message

  @override
  void initState() {
    super.initState();
    _startTimer();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    if (result.isNotEmpty) {
      setState(() {
        _connectionStatus = result.first;  // Get the first result from the list
      });
    }

  }

  void _startTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start > 0) {
        setState(() {
          _start--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  String get _formattedTime {
    int hours = _start ~/ 3600;
    int minutes = (_start % 3600) ~/ 60;
    int seconds = _start % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get _formattedDate {
    final now = DateTime.now();
    return DateFormat('EEEE, MMM dd, yyyy').format(now);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Upper Section (Blue background)
            Container(
              color: const Color(0xFF0F1C3E),
              height: screenHeight * 0.3, // 30% of screen height
              width: screenWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  const Text(
                    'Welcome, Saurav Kumar Rathaur',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  Image.asset(
                    'assets/image_checkincheckout_home.png',
                    width: screenWidth * 0.5,
                    height: screenHeight * 0.2,
                    fit: BoxFit.contain,
                  ),
                  const Spacer(),
                ],
              ),
            ),
            // Cylindrical Shape above the junction using Transform
            Transform.translate(
              offset: const Offset(0, -10), // Move up by 10 units
              child: Container(
                width: screenWidth * 0.9,
                padding: const EdgeInsets.symmetric(vertical: 15),
                margin: const EdgeInsets.only(top: 1), // Keep original margin
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      _formattedDate,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const Icon(Icons.timer, color: Colors.blue),
                    Text(
                      'Work Time: $_formattedTime',
                      style: const TextStyle(color: Colors.orange, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            // Connectivity Status
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.network_check, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      _getConnectionStatusText(),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            // Lower Section (Grid with Info Boxes)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: screenWidth > 600 ? 4 : 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: List.generate(
                  4,
                      (index) => _buildInfoBox(
                    'assets/set_location_attendance.png',
                    'Action ${index + 1}',
                    screenWidth,
                    screenHeight,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  String _getConnectionStatusText() {
    // Replace this with the actual logic if needed, or assume these two MAC addresses as static values
    String? macAddress = _getMacAddress(); // If needed, replace with actual MAC retrieval logic

    switch (_connectionStatus) {
      case ConnectivityResult.mobile:
        return 'Please Be In Your Corporate Network';

      case ConnectivityResult.wifi:
      // Check the MAC address and return corresponding message
        if (macAddress == '00-F4-8D-3E-25-58') {
          return 'Connected via MishiTech';
        } else if (macAddress == '28-16-AD-57-A1-02') {
          return 'Connected via Onelogica';
        } else {
          return 'Please Be In Your Corporate Network';
        }

      case ConnectivityResult.none:
        return 'No Internet Connection, connect to your corporate network';

      default:
        return 'Unknown Connectivity Status';
    }
  }

// Placeholder method to simulate retrieving the MAC address.
// In a real implementation, this should return the actual MAC address of the connected Wi-Fi network.
  String? _getMacAddress() {
    // You can return one of the two MAC addresses for testing:
    return '00-F4-8D-3E-25-58'; // or '28-16-AD-57-A1-02' for testing
  }

  Widget _buildInfoBox(String imagePath, String text, double width, double height) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            width: width * 0.2,
            height: height * 0.1,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// Dummy pages
class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: Center(child: Text('History Page')));
  }
}

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: Center(child: Text('User Page')));
  }
}
