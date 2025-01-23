import 'package:flutter/material.dart';
import 'package:flutter_basics/homepage.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'secure_storage.dart';
//import 'package:crypto/crypto.dart';
import 'masterkey.dart';
//import 'aes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}


class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();


  void login(BuildContext context, String username, String password) async {
    try {
      Response response = await post(
        Uri.parse('https://karsaazebs.com/BMS/api/login.php'),
        body: {
          'user_name': username,
          'password': password,
        },
      );

      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 1) {
        String username = jsonResponse['username'];
        int id = int.parse(jsonResponse['id']);


        String aesKey = await SecureStorage().readSecureData(username);


        if (aesKey.isEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MasterKeyPage(username)),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage(username, id)),
          );
        }

        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => HomePage(username, id)),
        // );
      } else {
        print('Failed');
        final snackBar = SnackBar(
          content: Text('Login failed. Please try again.'),
          action: SnackBarAction(
            label: 'Retry',
            onPressed: () {
              // Handle retry logic here if needed
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
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
            // Centered Login Form
            Center(
              child: FractionallySizedBox(
                widthFactor: 0.9,
                child: Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Title
                        const Text(
                          'Welcome Back',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF003B73),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Username Field
                        FractionallySizedBox(
                          widthFactor: 0.9,
                          child: TextField(
                            controller: username,
                            style: const TextStyle(color: Color(0xFF003B73)),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFF1F5F8),
                              prefixIcon: const Icon(Icons.person, color: Color(0xFF0078A8)),
                              hintText: "Enter Username",
                              hintStyle: const TextStyle(color: Color(0xFF8A9BAE)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Password Field
                        FractionallySizedBox(
                          widthFactor: 0.9,
                          child: TextField(
                            controller: password,
                            style: const TextStyle(color: Color(0xFF003B73)),
                            obscureText: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFF1F5F8),
                              prefixIcon: const Icon(Icons.lock, color: Color(0xFF0078A8)),
                              hintText: "Enter Password",
                              hintStyle: const TextStyle(color: Color(0xFF8A9BAE)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Login Button
                        FractionallySizedBox(
                          widthFactor: 0.6,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0078A8),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              //print(SecureStorage().readSecureData("aeskey"));
                              login(context, username.text.trim(), password.text.trim());
                              // if(SecureStorage().readSecureData("aeskey") == ""){
                              //   Navigator.push(
                              //     context,
                              //     MaterialPageRoute(builder: (context) => MasterKeyPage()),
                              //   );
                              // }
                              // else if(SecureStorage().readSecureData("aeskey") != ""){
                              //   login(context, username.text.trim(), password.text.trim());
                              // }
                              // //SecureStorage().writeSecureData("id", "123");
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
