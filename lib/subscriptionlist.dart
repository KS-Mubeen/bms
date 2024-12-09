import 'package:flutter/material.dart';
import 'package:flutter_basics/subscriptionedit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_basics/subscriptionview.dart';
import 'package:flutter_basics/subscriptionadd.dart';
import 'package:flutter_basics/encrypt.dart';
import 'package:flutter_basics/aes.dart';

class SubscriptionList extends StatefulWidget {
  final int id;

  SubscriptionList({required this.id});

  @override
  _SubscriptionListState createState() => _SubscriptionListState();
}

class _SubscriptionListState extends State<SubscriptionList> {
  List<dynamic> subscriptions = [];
  final aesEncryption = AESEncryption();
  final obj_encryption = encryption();
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadKeys();
  }

  // Load RSA keys on initialization
  Future<void> _loadKeys() async {
    await obj_encryption.loadKeys();
    apicall();
  }

  Future<void> apicall() async {
    final username = 'admin';
    final password = 'admin123';
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));

    try {
      final url =
          "https://karsaazebs.com/BMS/api/v1.php?table=subscription&action=list&q=(user_id~equals~${widget.id})";
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
        apicall();
      } else {
        print('Failed to delete item: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }


  Future<void> addFavourite(int id) async {
    final username = 'admin';
    final password = 'admin123';
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));

    try {
      final response = await http.delete(
        Uri.parse(
            "https://karsaazebs.com/BMS/api/favourite/subscription_is_favourite.php?id=$id"),
        headers: {
          'Authorization': basicAuth,
        },
      );

      if (response.statusCode == 200) {
        print('Item marked favrt successfully');
        apicall();
      } else {
        print('Failed to mark item fvrt: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }


  Future<void> removeFavourite(int id) async {
    final username = 'admin';
    final password = 'admin123';
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));

    try {
      final response = await http.delete(
        Uri.parse(
            "https://karsaazebs.com/BMS/api/favourite/subscription_isnot_favourite.php?id=$id"),
        headers: {
          'Authorization': basicAuth,
        },
      );

      if (response.statusCode == 200) {
        print('Item marked favrt successfully');
        apicall();
      } else {
        print('Failed to mark item fvrt: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }


   _getIcon(favourite_id) {
    if (favourite_id == 1) {
      return Icon(Icons.favorite);
    }
    if (favourite_id == 0) {
      return Icon(Icons.favorite_border);
    }
  }



  Future<bool> beforeDelete(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you want to delete this record?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Return false on cancel
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Return true on confirm
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    ) ??
        false; // Return false if the dialog is dismissed
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription List'),
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
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          itemCount: subscriptions.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
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
                            builder: (context) => SubscriptionAdd(userId: widget.id),
                          ),
                        );
                        if (result == true) {
                          apicall(); // Refresh the subscription list
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0078A8),
                        padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child:
                      const Text('Add New', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            } else {
              final subscription = subscriptions[index - 1];
              return Card(
                color: Colors.white.withOpacity(0.9),
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                //obj_encryption.decrypt(subscription['service_name']),
                                aesEncryption.decrypt(subscription['service_name'].toString()),
                                //subscription['service_name'] ?? 'No Service Name',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF003B73),
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                  'Username: ${aesEncryption.decrypt(subscription['username'])}',
                                //'Username: ${obj_encryption.decrypt(subscription['username'])}',
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () async {
                              bool confirmed = await beforeDelete(context);
                              if (confirmed) {
                                int deleteId = int.parse(subscription['id']);
                                await deleteItem(deleteId);
                              }
                            },
                          ),
                          IconButton(
                            icon: _getIcon(int.parse(subscription['favourite'])),
                            color: Colors.red,
                            onPressed: () {
                              if(int.parse(subscription['favourite']) == 0){
                                int favouriteId = int.parse(subscription['id']);
                                addFavourite(favouriteId);
                              }
                              if(int.parse(subscription['favourite']) == 1){
                                int favouriteId = int.parse(subscription['id']);
                                removeFavourite(favouriteId);
                              }

                            },
                          ),
                          //Text(subscription['favourite']),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Subscriptionedit(

                                    //username: subscription['username'] ?? '',

                                    username: aesEncryption.decrypt(subscription['username'].toString()),
                                    //username: obj_encryption.decrypt(subscription['username']),

                                    id: subscription['id'] ?? '',

                                    //service_name: obj_encryption.decrypt(subscription['service_name']),
                                    //service_name: subscription['service_name'] ?? '',
                                    service_name: aesEncryption.decrypt(subscription['service_name'].toString()),

                                    //url: obj_encryption.decrypt(subscription['url']),
                                    //url: subscription['url'] ?? '',
                                    url: aesEncryption.decrypt(subscription['url'].toString()),

                                    //password: obj_encryption.decrypt(subscription['password']),
                                    //password: subscription['password'] ?? '',
                                    password: aesEncryption.decrypt(subscription['password'].toString()),

                                    auto_renewal:
                                    subscription['auto_renewal'] ?? '0',
                                    next_renewal_date:
                                    subscription['next_renewal_date'] ?? '',
                                    expiry_date: subscription['expiry_date'] ?? '',
                                    other_description:
                                    subscription['other_description'] ?? '',
                                    active: subscription['active'] ?? '0',
                                  ),
                                ),
                              );
                              if (result == true) {
                                apicall(); // Reload the data on return
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0078A8),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Edit'),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Subscriptionview(
                                    //username: subscription['username'] ?? '',
                                    username: aesEncryption.decrypt(subscription['username'].toString()),
                                    //username: obj_encryption.decrypt(subscription['username']),

                                    id: subscription['id'] ?? '',

                                    //service_name: obj_encryption.decrypt(subscription['service_name']),
                                    //service_name: subscription['service_name'] ?? '',
                                    service_name: aesEncryption.decrypt(subscription['service_name'].toString()),

                                    //url: obj_encryption.decrypt(subscription['url']),
                                    //url: subscription['url'] ?? '',
                                    url: aesEncryption.decrypt(subscription['url'].toString()),

                                    //password: obj_encryption.decrypt(subscription['password']),
                                    //password: subscription['password'] ?? '',
                                    password: aesEncryption.decrypt(subscription['password'].toString()),

                                    auto_renewal: subscription['auto_renewal']
                                        ?.toString() ??
                                        'No Auto Renewal',
                                    next_renewal_date:
                                    subscription['next_renewal_date']?.toString() ??
                                        'No Next Renewal Date',
                                    expiry_date:
                                    subscription['expiry_date']?.toString() ??
                                        'No Expiry Date',
                                    other_description:
                                    subscription['other_description']?.toString() ??
                                        'No Other Description',
                                    active: subscription['active'] ?? 'No Active',
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0078A8),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('View'),
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
