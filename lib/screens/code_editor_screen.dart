import 'package:flutter/material.dart';
import '../controllers/code_editor_controller.dart';
import '../widgets/language_selector.dart';
import '../widgets/run_button.dart';
import '../widgets/output_display.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:highlight/languages/dart.dart' as dart;
import 'package:highlight/languages/python.dart' as python;
import 'package:highlight/languages/javascript.dart' as javascript;

class CodeEditorScreen extends StatefulWidget {
  @override
  _CodeEditorScreenState createState() => _CodeEditorScreenState();
}

class _CodeEditorScreenState extends State<CodeEditorScreen> {
  final CodeEditorController _controller = CodeEditorController();
  late CodeController _codeController;

  @override
  void initState() {
    super.initState();
    _codeController = CodeController(
      text: '// Your code here',
      language: dart.dart,
    );
  }

  void _updateLanguage(String language) {
    setState(() {
      _controller.setLanguage(language);
      switch (language) {
        case 'dart':
          _codeController.language = dart.dart;
          break;
        case 'python':
          _codeController.language = python.python;
          break;
        case 'javascript':
          _codeController.language = javascript.javascript;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Code Editor', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueGrey[800],
        elevation: 0,
      ),
      body: Container(
        color: Colors.blueGrey[50],
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blueGrey[800],
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: LanguageSelector(
                onLanguageChanged: _updateLanguage,
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blueGrey[900],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 0,
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SingleChildScrollView(  // Add this
                    child: CodeTheme(
                      data: CodeThemeData(styles: monokaiSublimeTheme),
                      child: CodeField(
                        controller: _codeController,
                        textStyle: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: RunButton(
                onPressed: () => _controller.runCode(_codeController.text),
              ),
            ),
            Container(
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: OutputDisplay(output: _controller.output),
            ),
          ],
        ),
      ),
    );
  }
}