import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CodeEditorController extends ChangeNotifier {
  String _language = 'dart';
  String _output = '';

  String get output => _output;

  void setLanguage(String language) {
    _language = language;
    notifyListeners();
  }

  Future<void> runCode(String code) async {
    // This is a placeholder. You'll need to replace this with an actual API call.
    final response = await http.post(
      Uri.parse('https://api.example.com/execute'),
      body: json.encode({
        'language': _language,
        'code': code,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      _output = json.decode(response.body)['output'];
    } else {
      _output = 'Error: ${response.statusCode}';
    }
    notifyListeners();
  }
}