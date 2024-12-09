import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BankdetailsView extends StatelessWidget {
  final String bankName;
  final String accountHolder;
  final String accountNumber;
  final String ifsc;
  final String branch;
  final String contactNumber;
  final String active;

  BankdetailsView({
    required this.bankName,
    required this.accountHolder,
    required this.accountNumber,
    required this.ifsc,
    required this.branch,
    required this.contactNumber,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bank Details'),
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
                          label: 'Bank Name', text: bankName),
                      _buildCopyableTextField(context,
                          label: 'Account Holder', text: accountHolder),
                      _buildCopyableTextField(context,
                          label: 'Account Number', text: accountNumber),
                      _buildCopyableTextField(context, label: 'IFSC', text: ifsc),
                      _buildCopyableTextField(context, label: 'Branch', text: branch),
                      _buildCopyableTextField(context,
                          label: 'Contact Number', text: contactNumber),
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
