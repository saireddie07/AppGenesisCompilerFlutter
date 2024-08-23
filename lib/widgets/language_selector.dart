import 'package:flutter/material.dart';

class LanguageSelector extends StatefulWidget {
  final Function(String) onLanguageChanged;

  LanguageSelector({required this.onLanguageChanged});

  @override
  _LanguageSelectorState createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  String _selectedLanguage = 'dart';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade100, Colors.blue.shade200],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: _selectedLanguage,
          icon: Icon(Icons.code, color: Colors.blue.shade700),
          elevation: 16,
          style: TextStyle(color: Colors.blue.shade700),
          onChanged: (String? newValue) {
            setState(() {
              _selectedLanguage = newValue!;
            });
            widget.onLanguageChanged(newValue!);
          },
          items: <String>['dart', 'python', 'javascript']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  Icon(
                    getLanguageIcon(value),
                    color: Colors.blue.shade700,
                    size: 24,
                  ),
                  SizedBox(width: 8),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  IconData getLanguageIcon(String language) {
    switch (language) {
      case 'dart':
        return Icons.space_dashboard;
      case 'python':
        return Icons.integration_instructions;
      case 'javascript':
        return Icons.javascript;
      default:
        return Icons.code;
    }
  }
}