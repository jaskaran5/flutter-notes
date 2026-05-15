import 'package:flutter/material.dart';
import 'package:social_login/firebase_service.dart';

class FirebaseAnalytics extends StatefulWidget {
  const FirebaseAnalytics({super.key});

  @override
  State<FirebaseAnalytics> createState() => _FirebaseAnalyticsState();
}

class _FirebaseAnalyticsState extends State<FirebaseAnalytics> {
  final fireBaseService = FireBaseService();

  var selectedIndex = 0;

  var bottomTabBars = ['Home', 'person', 'chat'];

  List<Widget> bodyOfTabs = const [
    Text(
      'Home page',
      style: TextStyle(fontSize: 30, color: Colors.orangeAccent),
    ),
    Text(
      'Profile page',
      style: TextStyle(fontSize: 30, color: Colors.orangeAccent),
    ),
    Text(
      'Chat page',
      style: TextStyle(fontSize: 30, color: Colors.orangeAccent),
    ),
  ];

  @override
  void initState() {
    super.initState();
    fireBaseService.initializeFirebaseAnalytics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: Center(
        child: bodyOfTabs.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.deepOrange,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 20,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: 20,
            ),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat,
              size: 20,
            ),
            label: 'Chat',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
            fireBaseService.setLogForAnalytics(
                pageName: bottomTabBars[index], index: index);
          });
        },
      ),
    );
  }
}
