import 'package:flutter/material.dart';
import 'secure_storage.dart';
import 'main.dart';
import 'crypto.dart';
import 'aes.dart';

class MasterKeyPage extends StatelessWidget {

  MasterKeyPage(this.username);

  final String username;
  final TextEditingController masterKeyController = TextEditingController();
  final TextEditingController confirmKeyController = TextEditingController();

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
            // Centered Form
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
                          'Set Master Key',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF003B73),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Master Key Field
                        FractionallySizedBox(
                          widthFactor: 0.9,
                          child: TextField(
                            controller: masterKeyController,
                            obscureText: true,
                            style: const TextStyle(color: Color(0xFF003B73)),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFF1F5F8),
                              prefixIcon: const Icon(Icons.key, color: Color(0xFF0078A8)),
                              hintText: "Enter Master Key",
                              hintStyle: const TextStyle(color: Color(0xFF8A9BAE)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Confirm Master Key Field
                        FractionallySizedBox(
                          widthFactor: 0.9,
                          child: TextField(
                            controller: confirmKeyController,
                            obscureText: true,
                            style: const TextStyle(color: Color(0xFF003B73)),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFF1F5F8),
                              prefixIcon: const Icon(Icons.lock, color: Color(0xFF0078A8)),
                              hintText: "Confirm Master Key",
                              hintStyle: const TextStyle(color: Color(0xFF8A9BAE)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Proceed Button
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
                              String masterKey = masterKeyController.text.trim();
                              String confirmKey = confirmKeyController.text.trim();

                              if (masterKey.isEmpty || confirmKey.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please fill in both fields.'),
                                  ),
                                );
                              } else if (masterKey != confirmKey) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Keys do not match.'),
                                  ),
                                );
                              } else {
                                HashingHelper hashingHelper = HashingHelper();
                                String hashedKey = hashingHelper.computeSHA256(confirmKeyController.text);
                                SecureStorage().writeSecureData("username", username);
                                SecureStorage().writeSecureData(username, hashedKey);


                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => MyApp()),
                                );
                              }
                            },
                            child: const Text(
                              'Proceed',
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
