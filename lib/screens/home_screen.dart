// home_screen.dart

import 'package:flutter/material.dart';
import 'compiler_screen.dart';
import 'practice_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    CodeCompilerScreen(),
    PracticeScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('APP GENESIS', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueGrey[900],
        elevation: 0,
        actions: [
          _buildNavItem('CODE#', 0),
          _buildNavItem('PRACTICE', 1),
          _buildNavItem('SIGN UP/LOGIN', 2),
        ],
      ),
      body: _screens[_selectedIndex],
    );
  }

  Widget _buildNavItem(String title, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextButton(
        onPressed: () => _onItemTapped(index),
        child: Text(
          title,
          style: TextStyle(
            color: _selectedIndex == index ? Colors.white : Colors.white70,
            fontWeight: _selectedIndex == index ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}