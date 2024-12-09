import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter_basics/encrypt.dart';
import 'package:flutter_basics/aes.dart';


class SubscriptionAdd extends StatefulWidget {
  final int userId;

  SubscriptionAdd({required this.userId});

  @override
  _SubscriptionAddState createState() => _SubscriptionAddState();
}

class _SubscriptionAddState extends State<SubscriptionAdd> {


  final obj_encryption = encryption();
  final aesEncryption = AESEncryption();


  final _formKey = GlobalKey<FormState>();
  final TextEditingController _serviceNameController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  bool isLoading = false;
  String errorMessage = '';
  bool _activeisChecked = false;
  int active = 0;
  bool _renewalisChecked = false;
  int renewal = 0;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _loadEncryptionKeys();
  }

  Future<void> _loadEncryptionKeys() async {
    try {
      await obj_encryption.loadKeys();
      print('Keys loaded successfully');
    } catch (e) {
      print('Error loading keys: $e');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        // Format the date to 'yyyy-MM-dd'
        _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
        print(_dateController.text);
      });
    }
  }

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

      //final encryptedServiceName = obj_encryption.encrypt(_serviceNameController.text);
      //final encryptedUrl = obj_encryption.encrypt(_urlController.text);
      //final encryptedUsername = obj_encryption.encrypt(_usernameController.text);
      //final encryptedPassword = obj_encryption.encrypt(_passwordController.text);
      String encryptedServiceName = aesEncryption.encrypt(_serviceNameController.text);
      String encryptedUsername = aesEncryption.encrypt(_usernameController.text);
      String encryptedPassword = aesEncryption.encrypt(_passwordController.text);
      String encryptedUrl = aesEncryption.encrypt(_urlController.text);



      final response = await http.post(
        Uri.parse("https://karsaazebs.com/BMS/api/v1.php?table=subscription&action=insert"),
        headers: {
          'Authorization': basicAuth,
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'user_id': widget.userId.toString(),
          'service_name': encryptedServiceName,
          // 'service_name': _serviceNameController.text,
          //'url': _urlController.text,
          'url': encryptedUrl,
          //'username': _usernameController.text,
          'username': encryptedUsername,
          //'password': _passwordController.text,
          'password': encryptedPassword,
          'expiry_date':_dateController.text,
          'other_description': _remarksController.text,
          'active': active.toString(),
          'auto_renewal': renewal.toString()
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
        errorMessage = 'Error: ${e.toString()} gjirjg';
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
        title: Text('Add Subscription'),
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
                          // Service Name Field
                          TextFormField(
                            controller: _serviceNameController,
                            style: TextStyle(color: Color(0xFF003B73)),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.cleaning_services),
                              labelText: 'Service Name',
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a service name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.0),

                          // URL Field
                          TextFormField(
                            controller: _urlController,
                            style: TextStyle(color: Color(0xFF003B73)),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.link),
                              labelText: 'URL',
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a URL';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.0),

                          // Username Field
                          TextFormField(
                            controller: _usernameController,
                            style: TextStyle(color: Color(0xFF003B73)),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              labelText: 'Username',
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a username';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.0),

                          // Password Field
                          TextFormField(
                            controller: _passwordController,
                            style: TextStyle(color: Color(0xFF003B73)),
                            obscureText: !_isPasswordVisible, // Control visibility
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.password), // Password icon
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Color(0xFF0078A8)),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF0078A8)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF003B73)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              // Add suffixIcon for toggle visibility
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible; // Toggle visibility
                                  });
                                },
                                child: Icon(
                                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                  //color: Color(0xFF0078A8),
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: 16.0),

                          // Date Picker Field
                          TextFormField(
                            controller: _dateController,
                            style: TextStyle(color: Color(0xFF003B73)),
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Date',
                              labelStyle: TextStyle(color: Color(0xFF0078A8)),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF0078A8)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF003B73)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon: Icon(Icons.calendar_today),
                            ),
                            onTap: () => _selectDate(context),
                          ),
                          SizedBox(height: 16.0),

                          // Remarks Field
                          TextFormField(
                            controller: _remarksController,
                            style: TextStyle(color: Color(0xFF003B73)),
                            decoration: InputDecoration(
                              labelText: 'Description',
                              labelStyle: TextStyle(color: Color(0xFF0078A8)),
                              prefixIcon: Icon(Icons.description),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF0078A8)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF003B73)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: CheckboxListTile(
                                    checkColor: Color(0xFFFFFFFF),
                                    activeColor:  Color(0xFF0078A8),
                                    title: Text(
                                      "Active",
                                      style: TextStyle(fontSize: 14), // Adjust font size if needed
                                    ),
                                    value: _activeisChecked,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _activeisChecked = value ?? false; // Toggle the state
                                        active = _activeisChecked ? 1 : 0;
                                      });
                                    },
                                    controlAffinity: ListTileControlAffinity.trailing, // Position the checkbox
                                    //contentPadding: EdgeInsets.zero, // Reduce spacing
                                  ),
                                ),
                                Flexible(
                                  child: CheckboxListTile(
                                    checkColor: Color(0xFFFFFFFF),
                                    activeColor:  Color(0xFF0078A8),
                                    title: Text(
                                      "Auto Renewal",
                                      style: TextStyle(fontSize: 14), // Adjust font size if needed
                                    ),
                                    value: _renewalisChecked,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _renewalisChecked = value ?? false; // Toggle the state
                                        renewal = _renewalisChecked ? 1 : 0;
                                      });
                                    },
                                    controlAffinity: ListTileControlAffinity.trailing, // Position the checkbox
                                    contentPadding: EdgeInsets.zero, // Reduce spacing
                                  ),
                                ),
                              ],
                            ),
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
}
