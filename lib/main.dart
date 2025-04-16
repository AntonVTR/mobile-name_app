import 'package:flutter/material.dart';

void main() => runApp(NameApp());

class NameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Name Entry App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Roboto',
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      home: NameScreen(),
    );
  }
}

class NameScreen extends StatefulWidget {
  @override
  _NameScreenState createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final TextEditingController _nameController = TextEditingController();
  String? _message;
  bool _isError = false;
  String _greeting = '';
  final RegExp _lettersOnly = RegExp(r'^[a-zA-Z]+$');

  void _handleSave() {
    final input = _nameController.text.trim();

    if (input.isEmpty || !_lettersOnly.hasMatch(input)) {
      _showMessage("Error: Use letters only", isError: true);
    } else {
      setState(() {
        _greeting = "Hello, $input";
      });
      _showMessage("Saved", isError: false);
    }
  }

  void _showMessage(String message, {required bool isError}) {
    setState(() {
      _message = message;
      _isError = isError;
    });

    Future.delayed(Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _message = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Please enter your name',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (_greeting.isNotEmpty) ...[
                SizedBox(height: 16),
                Text(
                  _greeting,
                  style: textTheme.titleLarge?.copyWith(color: Colors.black87),
                ),
              ],
              SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Enter name',
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Save', style: TextStyle(fontSize: 16)),
              ),
              if (_message != null) ...[
                SizedBox(height: 20),
                AnimatedOpacity(
                  duration: Duration(milliseconds: 300),
                  opacity: _message != null ? 1.0 : 0.0,
                  child: Text(
                    _message!,
                    style: TextStyle(
                      fontSize: 16,
                      color: _isError ? Colors.red : Colors.green[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
