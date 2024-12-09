import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//import 'package:flutter_basics/encrypt.dart';

class CredentialsAdd extends StatefulWidget {
  final int userId;

  CredentialsAdd({required this.userId});

  @override
  _CredentialsAddState createState() => _CredentialsAddState();
}

class _CredentialsAddState extends State<CredentialsAdd> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  bool isLoading = false;
  String errorMessage = '';

  Future<void> submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    final username = 'admin';
    final password = 'admin123';
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));

    try {
      final response = await http.post(
        Uri.parse("https://karsaazebs.com/BMS/api/v1.php?table=credentials&action=insert"),
        headers: {
          'Authorization': basicAuth,
          'Content-Type': 'application/x-www-form-urlencoded', // Update Content-Type
        },
        body: {
          'user_id': widget.userId.toString(),
          'username': _usernameController.text,
          'password': _passwordController.text,
          'remarks': _remarksController.text,
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          Navigator.pop(context, true); // Return to the previous screen and refresh the list
        } else {
          setState(() {
            errorMessage = responseData['message'] ?? 'An error occurred';
          });
        }
      } else {
        setState(() {
          errorMessage = 'Server error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Credential'),
        backgroundColor: const Color(0xFF0078A8),
        foregroundColor: const Color(0xFFFFFFFF),
      ),
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF003B73), Color(0xFF0078A8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Form Card
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Card(
                  color: Colors.white.withOpacity(0.9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Username Field
                          _buildTextField(
                            controller: _usernameController,
                            label: 'Username',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a username';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.0),

                          // Password Field
                          _buildTextField(
                            controller: _passwordController,
                            label: 'Password',
                            isObscure: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.0),

                          // Remarks Field
                          _buildTextField(
                            controller: _remarksController,
                            label: 'Remarks',
                          ),
                          SizedBox(height: 16.0),

                          // Error Message Display
                          if (errorMessage.isNotEmpty)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  errorMessage,
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ),

                          // Submit Button
                          Center(
                            child: ElevatedButton(
                              onPressed: isLoading ? null : submitForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF0078A8),
                                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              ),
                              child: isLoading
                                  ? CircularProgressIndicator(color: Colors.white)
                                  : Text('Submit', style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool isObscure = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: Color(0xFF003B73)),
      obscureText: isObscure,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Color(0xFF0078A8)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF0078A8)),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF003B73)),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: validator,
    );
  }
}
