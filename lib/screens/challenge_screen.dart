import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:highlight/languages/python.dart';
import 'package:highlight/languages/java.dart';
import 'package:highlight/languages/javascript.dart';
import 'package:highlight/languages/cpp.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChallengeScreen extends StatefulWidget {
  final String title;
  final String description;
  final String difficulty;

  ChallengeScreen({
    required this.title,
    required this.description,
    required this.difficulty,
  });

  @override
  _ChallengeScreenState createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  final controller = CodeController(
    text: '# Your code here\n',
    language: python,
  );

  String _outputText = '';
  String _errorText = '';
  bool _isRunning = false;
  String _selectedLanguage = 'Python';

  final List<String> _languages = ['Python', 'Java', 'JavaScript', 'C++'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: _buildChallengeDescription(),
          ),
          VerticalDivider(color: Colors.blueGrey[700], width: 1),
          Expanded(
            flex: 1,
            child: _buildCompilerSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeDescription() {
    return Container(
      color: Colors.blueGrey[800],
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          _buildDifficultyChip(widget.difficulty),
          SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.description,
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Example:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Input: [1, 2, 3, 4, 5]\nOutput: 15',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompilerSection() {
    return Container(
      color: Colors.grey[900],
      child: Column(
        children: [
          _buildLanguageDropdown(),
          Expanded(
            child: _buildCodeEditor(),
          ),
          _buildOutputArea(),
          _buildRunButton(),
        ],
      ),
    );
  }

  Widget _buildLanguageDropdown() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.blueGrey[700],
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedLanguage,
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedLanguage = newValue;
                _updateLanguage(newValue);
              });
            }
          },
          items: _languages.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: TextStyle(color: Colors.white)),
            );
          }).toList(),
          dropdownColor: Colors.blueGrey[600],
          icon: Icon(Icons.code, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildCodeEditor() {
    return CodeTheme(
      data: CodeThemeData(styles: monokaiSublimeTheme),
      child: SingleChildScrollView(
        child: CodeField(
          controller: controller,
          textStyle: TextStyle(fontFamily: 'monospace', fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildOutputArea() {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: 150),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Output:',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              _outputText,
              style: TextStyle(color: Colors.white70),
            ),
            if (_errorText.isNotEmpty) ...[
              SizedBox(height: 8),
              Text(
                'Error:',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                _errorText,
                style: TextStyle(color: Colors.redAccent),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRunButton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: _isRunning ? null : _runCode,
        child: Text(_isRunning ? 'Running...' : 'Run Code'),
        style: ElevatedButton.styleFrom(
          backgroundColor: _isRunning ? Colors.grey : Colors.green,
          padding: EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildDifficultyChip(String difficulty) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getDifficultyColor(difficulty),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        difficulty,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  void _updateLanguage(String lang) {
    switch (lang) {
      case 'Python':
        controller.language = python;
        break;
      case 'Java':
        controller.language = java;
        break;
      case 'JavaScript':
        controller.language = javascript;
        break;
      case 'C++':
        controller.language = cpp;
        break;
      default:
        controller.language = python;
    }
    controller.text = '// Your ${lang} code here\n';
  }

  Future<void> _runCode() async {
    setState(() {
      _isRunning = true;
      _outputText = '';
      _errorText = '';
    });

    String code = controller.text;
    String language = _selectedLanguage.toLowerCase();

    try {
      var response = await http.post(
        Uri.parse('http://127.0.0.1:8000/execute/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'code': code, 'language': language}),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          _outputText = data['output'];
          _errorText = data['error'];
        });
      } else {
        setState(() {
          _outputText = 'Error: ${response.statusCode} - ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _outputText = 'Error: $e';
      });
    } finally {
      setState(() {
        _isRunning = false;
      });
    }
  }
}