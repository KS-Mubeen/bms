import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter_basics/encrypt.dart';
import 'package:flutter_basics/aes.dart';
import 'package:flutter/cupertino.dart';

class BankDetailsAdd extends StatefulWidget {
  final int userId;

  BankDetailsAdd({required this.userId});

  @override
  _SubscriptionAddState createState() => _SubscriptionAddState();
}

class _SubscriptionAddState extends State<BankDetailsAdd> {
  final obj_encryption = encryption();
  final aesEncryption = AESEncryption();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _accountTypeController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _branchNameController = TextEditingController();
  final TextEditingController _branchCodeController = TextEditingController();
  final TextEditingController _accountHolderNameController = TextEditingController();
  final TextEditingController _currencyController = TextEditingController();
  final TextEditingController _balanceController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardCreationDateController = TextEditingController();
  final TextEditingController _cardExpiryDateController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailAddressController = TextEditingController();
  final TextEditingController _accountStatusController = TextEditingController();

  bool isLoading = false;
  String errorMessage = '';


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

  Future<void> _selectCardCreationDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        // Format the date to 'yyyy-MM-dd'
        _cardCreationDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
        print(_cardCreationDateController.text);
        print(aesEncryption.encrypt(_cardCreationDateController.text));
      });
    }
  }

  Future<void> _selectCardExpiryDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        // Format the date to 'yyyy-MM-dd'
        _cardExpiryDateController.text =
            DateFormat('yyyy-MM-dd').format(pickedDate);
        print(_cardExpiryDateController.text);
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
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));

    try {
      final encryptedAccountNumber = aesEncryption.encrypt(_accountNumberController.text);
      final encryptedBankName = aesEncryption.encrypt(_bankNameController.text);
      final encryptedBranchName = aesEncryption.encrypt(_branchNameController.text);
      final encryptedBranchCode = aesEncryption.encrypt(_branchCodeController.text);
      final encryptedAccountHolderName = aesEncryption.encrypt(_accountHolderNameController.text);
      final encryptedBalance = aesEncryption.encrypt(_balanceController.text);
      final encryptedCvv = aesEncryption.encrypt(_cvvController.text);
      final encryptedCardNumber = aesEncryption.encrypt(_cardNumberController.text);
      //final encryptedCardCreationDate = aesEncryption.encrypt(_cardCreationDateController.text);
      //final encryptedCardExpiryDate = aesEncryption.encrypt(_cardExpiryDateController.text);
      final encryptedPhoneNumber = aesEncryption.encrypt(_phoneNumberController.text);
      final encryptedEmail = aesEncryption.encrypt(_bankNameController.text);


      final response = await http.post(
        Uri.parse(
            "https://karsaazebs.com/BMS/api/v1.php?table=bank_details&action=insert"),
        headers: {
          'Authorization': basicAuth,
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'user_id': widget.userId.toString(),
          'account_number': encryptedAccountNumber,
          //'account_type_id':
          'bank_name': encryptedBankName,
          'branch_name': encryptedBranchName,
          'branch_code': encryptedBranchCode,
          'account_holder_name': encryptedAccountHolderName,
          //'currency_id':
          'balance': encryptedBalance,
          'cvv': encryptedCvv,
          'card_number': encryptedCardNumber,
          'card_creation_date': _cardCreationDateController.text,
          'card_expiry-date': _cardExpiryDateController.text,
          'phone_number': encryptedPhoneNumber,
          'email_address': encryptedEmail
          //'account_status_id':
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          Navigator.pop(context,
              true); // Return to the previous screen and refresh the list
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
        title: Text('Add Bank Details'),
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
                          // _accountNumberController
                          TextFormField(
                            controller: _accountNumberController,
                            style: TextStyle(color: Color(0xFF003B73)),
                            keyboardType: TextInputType.numberWithOptions(),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.credit_card),
                              labelText: 'Account Number',
                              labelStyle: TextStyle(color: Color(0xFF0078A8)),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF0078A8)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF003B73)),
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

                          // _accountTypeController
                          TextFormField(
                            controller: _accountTypeController,
                            style: TextStyle(color: Color(0xFF003B73)),
                            decoration: InputDecoration(
                              prefixIcon: Icon(CupertinoIcons.creditcard_fill),
                              labelText: 'Account Type',
                              labelStyle: TextStyle(color: Color(0xFF0078A8)),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF0078A8)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF003B73)),
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

                          // _bankNameController
                          TextFormField(
                            controller: _bankNameController,
                            style: TextStyle(color: Color(0xFF003B73)),
                            decoration: InputDecoration(
                              prefixIcon: Icon(CupertinoIcons.building_2_fill),
                              labelText: 'Bank Name',
                              labelStyle: TextStyle(color: Color(0xFF0078A8)),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF0078A8)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF003B73)),
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

                          // _bankNameController
                          TextFormField(
                            controller: _branchNameController,
                            style: TextStyle(color: Color(0xFF003B73)),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.business),
                              labelText: 'Branch Name',
                              labelStyle: TextStyle(color: Color(0xFF0078A8)),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF0078A8)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF003B73)),
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

                          // _branchCodeController
                          TextFormField(
                            controller: _branchCodeController,
                            style: TextStyle(color: Color(0xFF003B73)),
                            keyboardType: TextInputType.numberWithOptions(),
                            decoration: InputDecoration(
                              prefixIcon: Icon(CupertinoIcons.number),
                              labelText: 'Branch Code',
                              labelStyle: TextStyle(color: Color(0xFF0078A8)),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF0078A8)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF003B73)),
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

                          // _accountHolderNameController
                          TextFormField(
                            controller: _accountHolderNameController,
                            style: TextStyle(color: Color(0xFF003B73)),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              labelText: 'Account Holder Name',
                              labelStyle: TextStyle(color: Color(0xFF0078A8)),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF0078A8)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF003B73)),
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

                          // _currencyController
                          TextFormField(
                            controller: _currencyController,
                            style: TextStyle(color: Color(0xFF003B73)),
                            decoration: InputDecoration(
                              prefixIcon:
                                  Icon(CupertinoIcons.money_dollar_circle_fill),
                              labelText: 'Currency',
                              labelStyle: TextStyle(color: Color(0xFF0078A8)),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF0078A8)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF003B73)),
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

                          // _balanceController
                          TextFormField(
                            controller: _balanceController,
                            style: TextStyle(color: Color(0xFF003B73)),
                            keyboardType: TextInputType.numberWithOptions(),
                            decoration: InputDecoration(
                              prefixIcon: Icon(CupertinoIcons.money_dollar),
                              labelText: 'Balance',
                              labelStyle: TextStyle(color: Color(0xFF0078A8)),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF0078A8)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF003B73)),
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

                          // _cvvController
                          TextFormField(
                            controller: _cvvController,
                            style: TextStyle(color: Color(0xFF003B73)),
                            keyboardType: TextInputType.numberWithOptions(),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.security),
                              labelText: 'CVV',
                              labelStyle: TextStyle(color: Color(0xFF0078A8)),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF0078A8)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF003B73)),
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

                          // _cardNumberController
                          TextFormField(
                            controller: _cardNumberController,
                            style: TextStyle(color: Color(0xFF003B73)),
                            keyboardType: TextInputType.numberWithOptions(),
                            decoration: InputDecoration(
                              prefixIcon: Icon(CupertinoIcons.creditcard),
                              labelText: 'Card Number',
                              labelStyle: TextStyle(color: Color(0xFF0078A8)),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF0078A8)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF003B73)),
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

                          // _cardCreationDateController
                          TextFormField(
                            controller: _cardCreationDateController,
                            style: TextStyle(color: Color(0xFF003B73)),
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Card Creation Date',
                              labelStyle: TextStyle(color: Color(0xFF0078A8)),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF0078A8)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF003B73)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon: Icon(Icons.date_range),
                            ),
                            onTap: () => _selectCardCreationDate(context),
                          ),
                          SizedBox(height: 16.0),

                          // _cardExpiryDateController
                          TextFormField(
                            controller: _cardExpiryDateController,
                            style: TextStyle(color: Color(0xFF003B73)),
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Card Expiry Date',
                              labelStyle: TextStyle(color: Color(0xFF0078A8)),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF0078A8)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF003B73)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon: Icon(Icons.event),
                            ),
                            onTap: () => _selectCardExpiryDate(context),
                          ),
                          SizedBox(height: 16.0),

                          // _phoneNumberController
                          TextFormField(
                            controller: _phoneNumberController,
                            style: TextStyle(color: Color(0xFF003B73)),
                            keyboardType: TextInputType.numberWithOptions(),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.phone),
                              labelText: 'Phone Number',
                              labelStyle: TextStyle(color: Color(0xFF0078A8)),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF0078A8)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF003B73)),
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

                          // _emailAddressController
                          TextFormField(
                            controller: _emailAddressController,
                            style: TextStyle(color: Color(0xFF003B73)),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              labelText: 'Email Address',
                              labelStyle: TextStyle(color: Color(0xFF0078A8)),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF0078A8)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF003B73)),
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

                          // _accountStatusController
                          TextFormField(
                            controller: _accountStatusController,
                            style: TextStyle(color: Color(0xFF003B73)),
                            decoration: InputDecoration(
                              prefixIcon: Icon(CupertinoIcons.shield_fill),
                              labelText: 'Account Status',
                              labelStyle: TextStyle(color: Color(0xFF0078A8)),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF0078A8)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF003B73)),
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                              ),
                              child: isLoading
                                  ? CircularProgressIndicator(
                                      color: Colors.white)
                                  : Text('Submit',
                                      style: TextStyle(color: Colors.white)),
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
