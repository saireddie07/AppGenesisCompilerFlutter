import 'package:flutter/material.dart';

class LoggedInView extends StatefulWidget {
  final Function onLogout;

  LoggedInView({required this.onLogout});

  @override
  _LoggedInViewState createState() => _LoggedInViewState();
}

class _LoggedInViewState extends State<LoggedInView> {
  String userName = 'John Doe';
  String userCollege = 'Example University';
  String userEmail = 'johndoe@example.com';
  int challengesSolved = 42;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _collegeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = userName;
    _collegeController.text = userCollege;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            ),
            SizedBox(height: 24),
            _buildEditableField('Name', _nameController, (value) {
              setState(() => userName = value);
            }),
            SizedBox(height: 16),
            _buildEditableField('College', _collegeController, (value) {
              setState(() => userCollege = value);
            }),
            SizedBox(height: 24),
            Card(
              color: Colors.blue.shade100,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(Icons.email, size: 28, color: Colors.blue.shade700),
                    SizedBox(height: 8),
                    Text(
                      userEmail,
                      style: TextStyle(fontSize: 16, color: Colors.blue.shade700),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            _buildChallengesSolvedCard(),
            SizedBox(height: 32),
            ElevatedButton.icon(
              icon: Icon(Icons.logout),
              label: Text('Log Out'),
              onPressed: () => widget.onLogout(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller, Function(String) onSaved) {
    return TextFormField(
      controller: controller,
      style: TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () async {
            final result = await showDialog(
              context: context,
              builder: (context) => _buildEditDialog(label, controller.text),
            );
            if (result != null) {
              controller.text = result;
              onSaved(result);
            }
          },
        ),
      ),
      readOnly: true,
    );
  }

  Widget _buildChallengesSolvedCard() {
    return Card(
      elevation: 4,
      color: Colors.green.shade100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(Icons.emoji_events, size: 48, color: Colors.green.shade700),
            SizedBox(height: 8),
            Text(
              'Challenges Solved',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green.shade700),
            ),
            SizedBox(height: 8),
            Text(
              '$challengesSolved',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.green.shade900),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditDialog(String label, String initialValue) {
    TextEditingController dialogController = TextEditingController(text: initialValue);
    return AlertDialog(
      title: Text('Edit $label'),
      content: TextField(
        controller: dialogController,
        decoration: InputDecoration(labelText: label),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text('Save'),
          onPressed: () => Navigator.of(context).pop(dialogController.text),
        ),
      ],
    );
  }
}