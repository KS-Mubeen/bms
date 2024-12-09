import 'package:flutter/material.dart';
//import 'package:flutter_basics/bankdetailsedit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_basics/bankdetailsview.dart';
import 'package:flutter_basics/bankdetailsadd.dart';
import 'package:flutter_basics/aes.dart';

class Bankdetails extends StatefulWidget {
  final int id;

  Bankdetails({required this.id});

  @override
  _BankdetailsState createState() => _BankdetailsState();
}

class _BankdetailsState extends State<Bankdetails> {
  List<dynamic> bankDetails = [];
  bool isLoading = true;
  String errorMessage = '';
  final aesEncryption = AESEncryption();


  Future<void> fetchBankDetails() async {
    final username = 'admin';
    final password = 'admin123';
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));

    try {
      http.Response response = await http.get(
        Uri.parse("https://karsaazebs.com/BMS/api/v1.php?table=bank_details&action=list&q=(user_id~equals~${widget.id})"),
        headers: {
          'Authorization': basicAuth,
        },
      );

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        if (decodedData['success'] == true && decodedData['data'] is List) {
          setState(() {
            bankDetails = decodedData['data'];
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

  Future<void> deleteItem(int id) async {
    final username = 'admin';
    final password = 'admin123';
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));

    try {
      final response = await http.delete(
        Uri.parse(
            "https://karsaazebs.com/BMS/api/v1.php?table=subscription&action=delete&editid1=$id"),
        headers: {
          'Authorization': basicAuth,
        },
      );

      if (response.statusCode == 200) {
        print('Item deleted successfully');
        fetchBankDetails();
      } else {
        print('Failed to delete item: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBankDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bank Details List'),
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
          itemCount: bankDetails.length + 1,
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
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BankDetailsAdd(userId: widget.id),
                          ),
                        );
                        if (result == true) {
                          fetchBankDetails(); // Refresh the subscription list
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
              final bankDetail = bankDetails[index - 1];
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
                        aesEncryption.decrypt(bankDetail['bank_name'].toString()),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003B73),
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        'Account Holder: ${aesEncryption.decrypt(bankDetail['account_holder_name'].toString())}',
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
                                  builder: (context) => BankdetailsView(
                                    bankName: bankDetail['bank_name'] ?? 'No Bank Name',
                                    accountHolder: bankDetail['account_holder_name'] ?? 'No Account Holder',
                                    accountNumber: bankDetail['account_number']?.toString() ?? 'No Account Number',
                                    ifsc: bankDetail['ifsc']?.toString() ?? 'No IFSC',
                                    branch: bankDetail['branch']?.toString() ?? 'No Branch',
                                    contactNumber: bankDetail['contact_number']?.toString() ?? 'No Contact Number',
                                    active: bankDetail['active'] ?? 'No Active Status',
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
                                  builder: (context) => BankdetailsView(
                                    bankName: bankDetail['bank_name'] ?? 'No Bank Name',
                                    accountHolder: bankDetail['account_holder_name'] ?? 'No Account Holder',
                                    accountNumber: bankDetail['account_number']?.toString() ?? 'No Account Number',
                                    ifsc: bankDetail['ifsc']?.toString() ?? 'No IFSC',
                                    branch: bankDetail['branch']?.toString() ?? 'No Branch',
                                    contactNumber: bankDetail['contact_number']?.toString() ?? 'No Contact Number',
                                    active: bankDetail['active'] ?? 'No Active Status',
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
