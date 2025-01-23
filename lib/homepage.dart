import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_basics/subscriptionlist.dart';
import 'package:flutter_basics/credentials.dart';
import 'package:flutter_basics/bankdetails.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final String username;
  final int id;

  //const HomePage(this.username, this.id, {Key? key}) : super(key: key);
  const HomePage(this.username, this.id);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List subscriptions = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    apicall(); // Call the API when the page loads
  }

  Future<void> apicall() async {
    final username = 'admin';
    final password = 'admin123';
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));

    try {
      final url =
          "https://karsaazebs.com/BMS/api/v1.php?table=subscription&action=list&q=(user_id~equals~${widget.id})(favourite~equals~1)";
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': basicAuth,
        },
      );

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        if (decodedData['success'] == true && decodedData['data'] is List) {
          setState(() {
            subscriptions = decodedData['data'];
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Homepage'),
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
          // Centered Content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Welcome, ${widget.username}',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Choose The Module',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                // Subscription Button
                _buildModuleButton('Subscription', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SubscriptionList(id: widget.id)),
                  );
                }),
                const SizedBox(height: 15),
                // Bank Details Button
                _buildModuleButton('Bank Details', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Bankdetails(id: widget.id)),
                  );
                }),
                const SizedBox(height: 15),
                // Credentials Button
                _buildModuleButton('Credentials', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Credentials(id: widget.id)),
                  );
                }),
                const SizedBox(height: 20),
                isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.white))
                    : subscriptions.isEmpty
                    ? const Text(
                  'No subscriptions found.',
                  style: TextStyle(color: Colors.white),
                )
                    : Expanded(
                  child: ListView.builder(
                    itemCount: subscriptions.length,
                    itemBuilder: (context, index) {
                      final subscription = subscriptions[index];
                      return Card(
                        color: Colors.white.withOpacity(0.9),
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            subscription['service_name'] ?? 'No Service Name',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF003B73),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleButton(String label, VoidCallback onPressed) {
    return FractionallySizedBox(
      widthFactor: 0.8,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0078A8),
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
