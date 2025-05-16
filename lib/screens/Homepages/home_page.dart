import 'package:flutter/material.dart';
import 'package:my_new_sustain_app/screens/Homepages/Charbot_screen.dart';
import 'package:my_new_sustain_app/screens/Homepages/GreenTips_screen.dart';
import 'package:my_new_sustain_app/screens/Homepages/Profile_Screen.dart';
// import 'package:my_new_sustain_app/screens/Chatbot/chatbot_screen.dart'; // Adjust path as needed

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // You can pass data if needed or keep empty defaults
  final List<Widget> _screens = [
    ChatbotScreen(),
    GreentipsScreen(tipsText: ""), // Pass tipsText as needed
    ProfileScreen(
        selectedTips: []), // Replace with actual selected tips if required
    ChatbotScreen() // Create or import your chatbot screen widget
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green.shade700,
        unselectedItemColor: Colors.grey.shade600,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chatbot',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.eco),
            label: 'Green Tips',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
