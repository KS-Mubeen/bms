import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_basics/encrypt.dart'; // Import your encryption class
import 'package:flutter_basics/aes.dart';

class Subscriptionedit extends StatefulWidget {
  final String username;
  final String id;
  final String service_name;
  final String url;
  final String password;
  final String auto_renewal;
  final String next_renewal_date;
  final String expiry_date;
  final String other_description;
  final String active;

  Subscriptionedit({
    required this.username,
    required this.id,
    required this.service_name,
    required this.url,
    required this.password,
    required this.auto_renewal,
    required this.next_renewal_date,
    required this.expiry_date,
    required this.other_description,
    required this.active,
    Key? key,
  }) : super(key: key);

  @override
  _SubscriptioneditState createState() => _SubscriptioneditState();
}

class _SubscriptioneditState extends State<Subscriptionedit> {
  final obj_encryption = encryption();
  final aesEncryption = AESEncryption();

  late TextEditingController _serviceNameController;
  late TextEditingController _urlController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _dateController;
  late TextEditingController _descriptionController;
  late TextEditingController _activeController;
  late TextEditingController _autorenewalController;

  final ValueNotifier<bool> isActive = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isAutoRenewal = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _serviceNameController = TextEditingController(text: widget.service_name);
    _urlController = TextEditingController(text: widget.url);
    _usernameController = TextEditingController(text: widget.username);
    _passwordController = TextEditingController(text: widget.password);
    _dateController = TextEditingController(text: widget.expiry_date);
    _descriptionController = TextEditingController(text: widget.other_description);
    _activeController = TextEditingController(text: widget.active);
    _autorenewalController = TextEditingController(text: widget.auto_renewal);

    isActive.value = widget.active == '1';
    isAutoRenewal.value = widget.auto_renewal == '1';

    // Load the keys asynchronously when the widget is initialized
    obj_encryption.loadKeys();
  }

  Future<void> submitUpdate(BuildContext context) async {
    isLoading.value = true;

    try {
      // Encrypt sensitive data using RSA encryption
      String encryptedUsername = aesEncryption.encrypt(_usernameController.text);
      String encryptedPassword = aesEncryption.encrypt(_passwordController.text);
      String encryptedServiceName = aesEncryption.encrypt(_serviceNameController.text);
      String encryptedUrl = aesEncryption.encrypt(_urlController.text);
      //String encryptedUsername = obj_encryption.encrypt(_usernameController.text);
      //String encryptedPassword = obj_encryption.encrypt(_passwordController.text);
      //String encryptedServiceName = obj_encryption.encrypt(_serviceNameController.text);
      //String encryptedUrl = obj_encryption.encrypt(_urlController.text);


      // Basic Authentication
      final String username = 'admin';
      final String password = 'admin123';
      String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));

      final response = await http.post(
        Uri.parse(
          "https://karsaazebs.com/BMS/api/v1.php?table=subscription&action=update&editid1=${widget.id}",
        ),
        headers: {
          'Authorization': basicAuth,
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'service_name': encryptedServiceName,
          'url': encryptedUrl,
          'username': encryptedUsername,
          'password': encryptedPassword,
          'expiry_date': _dateController.text,
          'other_description': _descriptionController.text,
          'active': _activeController.text,
          'auto_renewal': _autorenewalController.text,
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          Navigator.pop(context, true); // Pass `true` to indicate a successful update
        } else {
          _showErrorDialog(context, responseData['message'] ?? 'An error occurred');
        }
      } else {
        _showErrorDialog(context, 'Server error: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorDialog(context, 'Error: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Details'),
        backgroundColor: const Color(0xFF0078A8),
        foregroundColor: const Color(0xFFFFFFFF),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF003B73), Color(0xFF0078A8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
              child: Card(
                color: Colors.white.withOpacity(0.9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField(
                        label: 'Service Name',
                        controller: _serviceNameController,
                        icon: Icons.settings,
                      ),
                      _buildTextField(
                        label: 'URL',
                        controller: _urlController,
                        icon: Icons.link,
                      ),
                      _buildTextField(
                        label: 'Username',
                        controller: _usernameController,
                        icon: Icons.person,
                      ),
                      _buildTextField(
                        label: 'Password',
                        controller: _passwordController,
                        icon: Icons.password,
                      ),
                      _buildTextField(
                        label: 'Expiry Date',
                        controller: _dateController,
                        icon: Icons.calendar_today,
                        readOnly: true,
                        onTap: () => _selectDate(context),
                      ),
                      _buildTextField(
                        label: 'Description',
                        controller: _descriptionController,
                        icon: Icons.description,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text(
                                "Active",
                                style: TextStyle(color: Color(0xFF003B73)),
                              ),
                              ValueListenableBuilder<bool>(
                                valueListenable: isActive,
                                builder: (context, value, child) {
                                  return Checkbox(
                                    value: value,
                                    onChanged: (bool? newValue) {
                                      isActive.value = newValue ?? false;
                                      _activeController.text =
                                      isActive.value ? '1' : '0';
                                    },
                                    activeColor: const Color(0xFF0078A8),
                                  );
                                },
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                "Auto Renewal",
                                style: TextStyle(color: Color(0xFF003B73)),
                              ),
                              ValueListenableBuilder<bool>(
                                valueListenable: isAutoRenewal,
                                builder: (context, value, child) {
                                  return Checkbox(
                                    value: value,
                                    onChanged: (bool? newValue) {
                                      isAutoRenewal.value = newValue ?? false;
                                      _autorenewalController.text =
                                      isAutoRenewal.value ? '1' : '0';
                                    },
                                    activeColor: const Color(0xFF0078A8),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      ValueListenableBuilder<bool>(
                        valueListenable: isLoading,
                        builder: (context, loading, child) {
                          return Center(
                            child: loading
                                ? const CircularProgressIndicator()
                                : ElevatedButton(
                              onPressed: () => submitUpdate(context),
                              child: const Text('Save'),
                            ),
                          );
                        },
                      ),
                    ],
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
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFF0078A8), width: 1.0),
        ),
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        style: const TextStyle(color: Color(0xFF003B73)),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _dateController.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }
}

