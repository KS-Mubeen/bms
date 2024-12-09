import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class CredentialsView extends StatelessWidget {
  final String username;
  final String email;
  final String password;
  final String phone;
  final String address;
  final String active;

  CredentialsView({
    required this.username,
    required this.email,
    required this.password,
    required this.phone,
    required this.address,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Credentials'),
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
          // Content
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
                      _buildCopyableTextField(context,
                          label: 'Username', text: username),
                      _buildCopyableTextField(context,
                          label: 'Email', text: email),
                      _buildCopyableTextField(context,
                          label: 'Password', text: password),
                      _buildCopyableTextField(context, label: 'Phone', text: phone),
                      _buildCopyableTextField(context, label: 'Address', text: address),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text("Active", style: TextStyle(color: Color(0xFF003B73))),
                              Checkbox(
                                value: active == '1',
                                onChanged: null,
                                activeColor: Color(0xFF0078A8),
                              ),
                            ],
                          ),
                        ],
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

  Widget _buildCopyableTextField(BuildContext context,
      {required String label, required String text}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFF0078A8), width: 1.0),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              enabled: false,
              controller: TextEditingController(text: text),
              style: TextStyle(color: Color(0xFF003B73)),
              decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
              maxLines: null,
            ),
          ),
          IconButton(
            icon: Icon(Icons.copy, color: Color(0xFF0078A8)),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: text));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("$label copied to clipboard"),
                  backgroundColor: Color(0xFF003B73),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(milliseconds: 1500),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: EdgeInsets.only(bottom: 20.0, left: 16.0, right: 16.0),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
