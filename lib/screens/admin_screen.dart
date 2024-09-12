import 'package:flutter/material.dart';
import '../API.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final ApiService _apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _topicController = TextEditingController();
  final _shortDescriptionController = TextEditingController();
  final _longDescriptionController = TextEditingController();
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();
  String _selectedLevel = 'E';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
              ),
              TextFormField(
                controller: _topicController,
                decoration: InputDecoration(labelText: 'Topic'),
                validator: (value) => value!.isEmpty ? 'Please enter a topic' : null,
              ),
              TextFormField(
                controller: _shortDescriptionController,
                decoration: InputDecoration(labelText: 'Short Description'),
                validator: (value) => value!.isEmpty ? 'Please enter a short description' : null,
              ),
              TextFormField(
                controller: _longDescriptionController,
                decoration: InputDecoration(labelText: 'Long Description'),
                validator: (value) => value!.isEmpty ? 'Please enter a long description' : null,
              ),
              DropdownButtonFormField<String>(
                value: _selectedLevel,
                items: ['E', 'M', 'H'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value == 'E' ? 'Easy' : value == 'M' ? 'Medium' : 'Hard'),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLevel = newValue!;
                  });
                },
                decoration: InputDecoration(labelText: 'Level'),
              ),
              TextFormField(
                controller: _questionController,
                decoration: InputDecoration(labelText: 'Question'),
                validator: (value) => value!.isEmpty ? 'Please enter a question' : null,
              ),
              TextFormField(
                controller: _answerController,
                decoration: InputDecoration(labelText: 'Answer'),
                validator: (value) => value!.isEmpty ? 'Please enter an answer' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitQuestion,
                child: Text('Add Question'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitQuestion() async {
    if (_formKey.currentState!.validate()) {
      try {
        final questionData = {
          "title": _titleController.text,
          "topic": _topicController.text,
          "short_description": _shortDescriptionController.text,
          "long_description": _longDescriptionController.text,
          "level": _selectedLevel,
          "question": _questionController.text,
          "answer": {"result": _answerController.text},
        };

        final result = await _apiService.createQuestion(questionData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Question added successfully')),
        );
        _clearForm();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add question: $e')),
        );
      }
    }
  }

  void _clearForm() {
    _titleController.clear();
    _topicController.clear();
    _shortDescriptionController.clear();
    _longDescriptionController.clear();
    _questionController.clear();
    _answerController.clear();
    setState(() {
      _selectedLevel = 'E';
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _topicController.dispose();
    _shortDescriptionController.dispose();
    _longDescriptionController.dispose();
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }
}