import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:highlight/languages/dart.dart';
import 'package:highlight/languages/python.dart';
import 'package:highlight/languages/java.dart';
import 'package:highlight/languages/javascript.dart';
import 'package:highlight/languages/sql.dart';
import 'package:http/http.dart' as http;

class CodeCompilerScreen extends StatefulWidget {
  @override
  _CodeCompilerScreenState createState() => _CodeCompilerScreenState();
}

class _CodeCompilerScreenState extends State<CodeCompilerScreen> {
  final List<String> languages = [
    'Python',
    'Java',
    'JavaScript',
    'SQLite',
    'C',
    'C#',
    'R',
  ];

  String selectedLanguage = 'Python';
  String _outputText = 'Your code output will appear here...';
  String _errorText = '';

  final controller = CodeController(
    text: '// Your code here\n',
    language: python,
  );

  @override
  void initState() {
    super.initState();
    _updateLanguage(selectedLanguage);
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
      case 'SQLite':
        controller.language = sql;
        break;
    // Add more cases for other languages as needed
      default:
        controller.language = python;
    }
    controller.text = '// Your ${lang} code here\n';
  }

  Future<void> _runCode() async {
    String code = controller.text;
    String language = selectedLanguage.toLowerCase();

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
          _errorText = '';
        });
      }
    } catch (e) {
      setState(() {
        _outputText = 'Error: $e';
        _errorText = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildLanguageSelector(),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: _buildCodeEditor(),
                ),
                Container(
                  width: 1,
                  color: Colors.blueGrey[700],
                ),
                Expanded(
                  flex: 1,
                  child: _buildOutputArea(),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildRunButton(),
    );
  }

  Widget _buildLanguageSelector() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.blueGrey[700],
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedLanguage,
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                selectedLanguage = newValue;
                _updateLanguage(newValue);
              });
            }
          },
          items: languages.map<DropdownMenuItem<String>>((String value) {
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
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: CodeTheme(
        data: CodeThemeData(styles: monokaiSublimeTheme),
        child: SingleChildScrollView(
          child: CodeField(
            controller: controller,
            textStyle: TextStyle(fontFamily: 'monospace', fontSize: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildOutputArea() {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blueGrey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Output',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 8),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _outputText,
                        style: TextStyle(color: Colors.white),
                      ),
                      if (_errorText.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRunButton() {
    return FloatingActionButton.extended(
      onPressed: _runCode,
      icon: Icon(Icons.play_arrow),
      label: Text('Run Code'),
      backgroundColor: Colors.green,
    );
  }
}