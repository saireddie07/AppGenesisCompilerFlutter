import 'package:flutter/material.dart';
import '../views/profile_logged_out_view.dart';
import '../views/profile_logged_in_view.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoggedIn = false;

  void _handleLogin() {
    setState(() => isLoggedIn = true);
  }

  void _handleLogout() {
    setState(() => isLoggedIn = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blueGrey[900]!, Colors.blueGrey[800]!],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: isLoggedIn
              ? LoggedInView(onLogout: _handleLogout)
              : LoggedOutView(onLogin: _handleLogin),
        ),
      ),
    );
  }
}