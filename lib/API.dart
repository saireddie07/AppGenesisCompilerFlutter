import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000';

  Future<List<dynamic>> getAllQuestions() async {
    final response = await http.get(Uri.parse('$baseUrl/question/'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load questions');
    }
  }

  Future<dynamic> createQuestion(Map<String, dynamic> questionData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/question/create/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(questionData),
    );
    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create question');
    }
  }

  Future<dynamic> getQuestion(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/question/$id/'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load question');
    }
  }

  Future<dynamic> updateQuestion(int id, Map<String, dynamic> questionData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/question/$id/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(questionData),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update question');
    }
  }

  Future<void> deleteQuestion(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/question/$id/'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete question');
    }
  }
}