import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Subscriptionview extends StatelessWidget {
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

  Subscriptionview({
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
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subscription Details'),
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
                      // Service Name
                      Container(
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
                                controller: TextEditingController(text: service_name),
                                style: const TextStyle(color: Color(0xFF003B73)),
                                decoration: const InputDecoration(
                                  labelText: 'Service Name',
                                  labelStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                  prefixIcon: Icon(Icons.settings),
                                ),
                                maxLines: null,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.copy, color: Color(0xFF0078A8)),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: service_name));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Service Name copied to clipboard"),
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
                      ),
                      // URL
                      Container(
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
                                controller: TextEditingController(text: url),
                                style: TextStyle(color: Color(0xFF003B73)),
                                decoration: InputDecoration(
                                  labelText: 'URL',
                                  labelStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                  prefixIcon: Icon(Icons.link),
                                ),
                                maxLines: null,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.copy, color: Color(0xFF0078A8)),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: url));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("URL copied to clipboard"),
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
                      ),
                      // Username
                      Container(
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
                                controller: TextEditingController(text: username),
                                style: TextStyle(color: Color(0xFF003B73)),
                                decoration: InputDecoration(
                                  labelText: 'Username',
                                  labelStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                  prefixIcon: Icon(Icons.person),
                                ),
                                maxLines: null,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.copy, color: Color(0xFF0078A8)),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: username));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Username copied to clipboard"),
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
                      ),
                      // Password
                      Container(
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
                                controller: TextEditingController(text: password),
                                style: TextStyle(color: Color(0xFF003B73)),
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                  prefixIcon: Icon(Icons.password),
                                ),
                                maxLines: null,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.copy, color: Color(0xFF0078A8)),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: password));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Password copied to clipboard"),
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
                      ),
                      // Expiry Date
                      Container(
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
                                controller: TextEditingController(text: expiry_date),
                                style: TextStyle(color: Color(0xFF003B73)),
                                decoration: InputDecoration(
                                  labelText: 'Expiry Date',
                                  labelStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                  prefixIcon: Icon(Icons.calendar_today),
                                ),
                                maxLines: null,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.copy, color: Color(0xFF0078A8)),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: expiry_date));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Expiry Date copied to clipboard"),
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
                      ),
                      // Description
                      Container(
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
                                controller: TextEditingController(text: other_description),
                                style: TextStyle(color: Color(0xFF003B73)),
                                decoration: InputDecoration(
                                  labelText: 'Description',
                                  labelStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                  prefixIcon: Icon(Icons.description),
                                ),
                                maxLines: null,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.copy, color: Color(0xFF0078A8)),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: other_description));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Description copied to clipboard"),
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
                      ),
                      // Active and Auto Renewal
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
                          Row(
                            children: [
                              Text("Auto Renewal", style: TextStyle(color: Color(0xFF003B73))),
                              Checkbox(
                                value: auto_renewal == '1',
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
}
