import 'package:flutter/material.dart';
import 'package:nielts/screens/profile/screen.dart';
import 'package:nielts/screens/practice/screen.dart';
import 'package:nielts/screens/test/screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: MyBottomNavigationBar(),
    );
  }
}

class MyBottomNavigationBar extends StatefulWidget {
  const MyBottomNavigationBar({super.key});

  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _currentIndex = 0;
  final List<Widget> _tabs = [
    const PracticeScreen(),
    const TestScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: const TextStyle(
          color: Color(0xFF71C309),
        ),
        unselectedLabelStyle: const TextStyle(
          color: Color(0xFF1A1A1A),
        ),
        selectedItemColor: const Color(0xFF71C309),
        unselectedItemColor: const Color(0xFF1A1A1A),
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.abc,
              size: 40,
            ),
            label: "Practice",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.edit_square,
              size: 40,
            ),
            label: "Test",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: 40,
            ),
            label: "Profile",
          ),
        ],
        backgroundColor: const Color(0xFFFFFFFF),
      ),
    );
  }
}
