import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_basics/credentialsview.dart';
import 'package:flutter_basics/credentialsadd.dart';

class Credentials extends StatefulWidget {
  final int id;

  Credentials({required this.id});

  @override
  _CredentialsState createState() => _CredentialsState();
}

class _CredentialsState extends State<Credentials> {
  List<dynamic> credentialsList = [];
  bool isLoading = true;
  String errorMessage = '';

  Future<void> fetchCredentials() async {
    final username = 'admin';
    final password = 'admin123';
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));

    try {
      http.Response response = await http.get(
        Uri.parse("https://karsaazebs.com/BMS/api/v1.php?table=credentials&action=list&q=(user_id~equals~${widget.id})"),
        headers: {
          'Authorization': basicAuth,
        },
      );

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        if (decodedData['success'] == true && decodedData['data'] is List) {
          setState(() {
            credentialsList = decodedData['data'];
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = 'Unexpected data format';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Error: ${response.statusCode}';
          isLoading = false;
        });
        print('Error fetching data: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: ${e.toString()}';
        isLoading = false;
      });
      print('Error: ${e.toString()}');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCredentials();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Credentials'),
        backgroundColor: const Color(0xFF0078A8),
        foregroundColor: const Color(0xFFFFFFFF),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF003B73), Color(0xFF0078A8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: isLoading
            ? Center(child: CircularProgressIndicator(color: Colors.white)) // White loader
            : ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          itemCount: credentialsList.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              // Add New Button at the top with alignment and previous size
              return Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        // Navigate to the CredentialsAdd page and await the result
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CredentialsAdd(userId: widget.id),
                          ),
                        );
                        // If the result is true, refresh the credentials list
                        if (result == true) {
                          fetchCredentials();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0078A8),
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: Text('Add New', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            } else {
              final credential = credentialsList[index - 1];
              return Card(
                color: Colors.white.withOpacity(0.9),
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        credential['username'] ?? 'No Username',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003B73),
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        'Remarks: ${credential['remarks'] ?? 'No Remarks'}',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CredentialsView(
                                    username: credential['username'] ?? '',
                                    email: credential['email'] ?? '',
                                    password: credential['password'] ?? '',
                                    phone: credential['phone'] ?? '',
                                    address: credential['address'] ?? '',
                                    active: credential['active'] ?? '0',
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF0078A8),
                              foregroundColor: Colors.white,
                            ),
                            child: Text('Edit'),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CredentialsView(
                                    username: credential['username'] ?? '',
                                    email: credential['email'] ?? '',
                                    password: credential['password'] ?? '',
                                    phone: credential['phone'] ?? '',
                                    address: credential['address'] ?? '',
                                    active: credential['active'] ?? '0',
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF0078A8),
                              foregroundColor: Colors.white,
                            ),
                            child: Text('View'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
