// // import 'dart:convert';
// // import 'package:agriconnect/Views/Buyer/mainBuyer.dart';
// // import 'package:agriconnect/constants/colors.dart';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;

// // class TransactionScreen extends StatefulWidget {
// //   final int userId;
// //   const TransactionScreen({super.key, required this.userId});

// //   @override
// //   _TransactionScreenState createState() => _TransactionScreenState();
// // }

// // class _TransactionScreenState extends State<TransactionScreen> {
// //   List transactions = [];
// //   Map<int, Map<String, String>> receiverDetails = {};

// //   @override
// //   void initState() {
// //     super.initState();
// //     fetchTransactions();
// //   }

// //   Future<void> fetchTransactions() async {
// //     final response = await http.get(
// //       Uri.parse(
// //           'http://152.67.10.128:5280/api/Order/transactions/buyer/${widget.userId}'),
// //     );

// //     if (response.statusCode == 200) {
// //       final data = jsonDecode(response.body);
// //       setState(() {
// //         transactions = data['\$values'];
// //       });
// //       fetchReceiverDetails();
// //     }
// //   }

// //   Future<void> fetchReceiverDetails() async {
// //     for (var transaction in transactions) {
// //       int receiverId = transaction['receiverId'];
// //       if (!receiverDetails.containsKey(receiverId)) {
// //         final response = await http.get(
// //           Uri.parse('http://152.67.10.128:5280/api/Admin/$receiverId'),
// //         );

// //         if (response.statusCode == 200) {
// //           final data = jsonDecode(response.body);
// //           setState(() {
// //             receiverDetails[receiverId] = {
// //               'name': data['userName'],
// //               'phone': data['phoneNumber'],
// //               'address': data['address'],
// //             };
// //           });
// //         }
// //       }
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return WillPopScope(
// //       onWillPop: () async {
// //         Navigator.pushReplacement(
// //           context,
// //           MaterialPageRoute(builder: (context) => BuyerMain()),
// //         );
// //         return false;
// //       },
// //       child: Scaffold(
// //         // extendBodyBehindAppBar: true,
// //         appBar: AppBar(
// //           backgroundColor: Colors.transparent,
// //           title:
// //           Text('Transaction Details',style: TextStyle(fontWeight: FontWeight.w900,color: MyColors.primaryColor),)),
// //         body: transactions.isEmpty
// //             ? const Center(child: CircularProgressIndicator())
// //             : Container(
// //         decoration: const BoxDecoration(
// //           image: DecorationImage(
// //             image: AssetImage('assets/bg8.png'),
// //             fit: BoxFit.cover,
// //           ),
// //         ),
// //               child: ListView.builder(
// //                   itemCount: transactions.length,
// //                   itemBuilder: (context, index) {
// //                     var transaction = transactions[index];
// //                     var receiverId = transaction['receiverId'];
// //                     var receiver = receiverDetails[receiverId] ?? {};

// //                     return Card(
// //                       color: Colors.white,
// //                       margin: const EdgeInsets.all(10),
// //                       child: Padding(
// //                         padding: const EdgeInsets.all(10),
// //                         child: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             Text('Transaction ID: ${transaction['transactionId']}',style:TextStyle(color: MyColors.primaryColor,fontWeight: FontWeight.bold)),
// //                             Text('Type: ${transaction['transactionType']}',style:TextStyle(color: MyColors.primaryColor)),
// //                             Text('Amount: \$${transaction['amount']}',style:TextStyle(color: MyColors.primaryColor)),
// //                             Text('Date: ${transaction['transectionAt']}',style:TextStyle(color: MyColors.primaryColor)),
// //                             const SizedBox(height: 10),
// //                             receiver.isNotEmpty
// //                                 ? Column(
// //                                     crossAxisAlignment: CrossAxisAlignment.start,
// //                                     children: [
// //                                       Text('Receiver: ${receiver['name']}',style:TextStyle(color: MyColors.primaryColor,

// //                                               fontWeight: FontWeight.bold)),
// //                                       Text('Phone: ${receiver['phone']}',style:TextStyle(color: MyColors.primaryColor)),
// //                                       Text('Address: ${receiver['address']}',style:TextStyle(color: MyColors.primaryColor)),
// //                                     ],
// //                                   )
// //                                 :  Text('Fetching receiver details...',style:TextStyle(color: MyColors.primaryColor)),
// //                           ],
// //                         ),
// //                       ),
// //                     );
// //                   },
// //                 ),
// //             ),
// //       ),
// //     );
// //   }
// // }

// import 'dart:convert';
// import 'package:agriconnect/Views/Buyer/mainBuyer.dart';
// import 'package:agriconnect/constants/colors.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class TransactionScreen extends StatefulWidget {
//   final int userId;
//   const TransactionScreen({super.key, required this.userId});

//   @override
//   _TransactionScreenState createState() => _TransactionScreenState();
// }

// class _TransactionScreenState extends State<TransactionScreen> {
//   List transactions = [];
//   Map<int, Map<String, String>> receiverDetails = {};
//   bool _isLoading = true; // Add a loading state

//   @override
//   void initState() {
//     super.initState();
//     fetchTransactions();
//   }

//   Future<void> fetchTransactions() async {
//     setState(() {
//       _isLoading = true;
//     });
//     final response = await http.get(
//       Uri.parse(
//           'http://152.67.10.128:5280/api/Order/transactions/buyer/${widget.userId}'),
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       setState(() {
//         transactions = data['\$values'];
//       });
//       await fetchReceiverDetails(); // Wait for receiver details to load
//     } else {
//       // Handle error appropriately
//       print('Failed to fetch transactions: ${response.statusCode}');
//       // Optionally show an error message to the user
//     }
//     setState(() {
//       _isLoading = false;
//     });
//   }

//   Future<void> fetchReceiverDetails() async {
//     for (var transaction in transactions) {
//       int receiverId = transaction['receiverId'];
//       if (!receiverDetails.containsKey(receiverId)) {
//         final response = await http.get(
//           Uri.parse('http://152.67.10.128:5280/api/Admin/$receiverId'),
//         );

//         if (response.statusCode == 200) {
//           final data = jsonDecode(response.body);
//           setState(() {
//             receiverDetails[receiverId] = {
//               'name': data['userName'],
//               'phone': data['phoneNumber'],
//               'address': data['address'],
//             };
//           });
//         } else {
//           print('Failed to fetch receiver details for ID $receiverId: ${response.statusCode}');
//           // Optionally handle error for individual receiver details
//         }
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => BuyerMain()),
//         );
//         return false;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: MyColors.primaryColor.withOpacity(0.9),
//           title: const Text(
//             'Transaction Details',
//             style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
//           ),
//           iconTheme: const IconThemeData(color: Colors.white), // Style back button
//         ),
//         body: Container(
//           decoration: const BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage('assets/bg8.png'),
//               fit: BoxFit.cover,
//             ),
//           ),
//           child: _isLoading
//               ?  Center(child: CircularProgressIndicator(color: MyColors.primaryColor,))
//               : transactions.isEmpty
//                   ? const Center(
//                       child: Text(
//                         'No transactions found.',
//                         style: TextStyle(fontSize: 16, color: Colors.white),
//                       ),
//                     )
//                   : ListView.builder(
//                       itemCount: transactions.length,
//                       itemBuilder: (context, index) {
//                         var transaction = transactions[index];
//                         var receiverId = transaction['receiverId'];
//                         var receiver = receiverDetails[receiverId] ?? {};

//                         return Card(
//                           color: Colors.white.withOpacity(0.8),
//                           margin: const EdgeInsets.all(10),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12.0),
//                           ),
//                           elevation: 3,
//                           child: Padding(
//                             padding: const EdgeInsets.all(16),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Transaction ID: ${transaction['transactionId']}',
//                                   style: TextStyle(
//                                     color: MyColors.primaryColor,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Text(
//                                   'Type: ${transaction['transactionType']}',
//                                   style: const TextStyle(color: Colors.black87),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   'Amount: \$${transaction['amount']}',
//                                   style: const TextStyle(color: Colors.green),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   'Date: ${transaction['transectionAt']}',
//                                   style: const TextStyle(color: Colors.grey),
//                                 ),
//                                 const SizedBox(height: 12),
//                                 receiver.isNotEmpty
//                                     ? Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             'Receiver: ${receiver['name']}',
//                                             style:  TextStyle(
//                                               color: MyColors.primaryColor,
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 16,
//                                             ),
//                                           ),
//                                           const SizedBox(height: 4),
//                                           Text('Phone: ${receiver['phone']}',
//                                               style: const TextStyle(color: Colors.black87)),
//                                           const SizedBox(height: 4),
//                                           Text('Address: ${receiver['address']}',
//                                               style: const TextStyle(color: Colors.black87)),
//                                         ],
//                                       )
//                                     : Text('Fetching receiver details...',
//                                         style: const TextStyle(color: Colors.orange)),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                 ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:agriconnect/Views/Buyer/mainBuyer.dart';
import 'package:agriconnect/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TransactionScreen extends StatefulWidget {
  final int userId;
  const TransactionScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  List transactions = [];
  Map<int, Map<String, String>> receiverDetails = {};
  bool _isLoading = true; // Added for loading state

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    final response = await http.get(
      Uri.parse(
          'http://152.67.10.128:5280/api/Order/transactions/buyer/${widget.userId}'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        transactions = data['\$values'];
      });
      await fetchReceiverDetails(); // Await here for sequential execution
    } else {
      print("Failed to load transactions: ${response.statusCode}"); //Important
      setState(() {
        _isLoading = false;
      });
      // Show error message to the user, maybe using a SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load transactions.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> fetchReceiverDetails() async {
    for (var transaction in transactions) {
      int receiverId = transaction['receiverId'];
      if (!receiverDetails.containsKey(receiverId)) {
        final response = await http.get(
          Uri.parse('http://152.67.10.128:5280/api/Admin/$receiverId'),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          setState(() {
            receiverDetails[receiverId] = {
              'name': data['userName'],
              'phone': data['phoneNumber'],
              'address': data['address'],
            };
          });
        } else {
          print(
              "Failed to load receiver details for ID $receiverId: ${response.statusCode}");
          setState(() {
            _isLoading = false;
          });
          // Show error message to the user, maybe using a SnackBar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to load receiver details.'),
              backgroundColor: Colors.red,
            ),
          );
          return; // Important: Exit the function if fetching details fails
        }
      }
    }
    setState(() {
      _isLoading = false; // Set loading to false after all details are fetched
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BuyerMain()),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.primaryColor,
          title: Text('Transaction Details',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => BuyerMain()),
              );
            },
          ),
          elevation: 2,
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bg8.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: _isLoading // Show loading indicator
              ? Center(
                  child:
                      CircularProgressIndicator(color: MyColors.primaryColor))
              : transactions.isEmpty
                  ? Center(
                      child: Text("No transactions found.",
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    )
                  : ListView.builder(
                      itemCount: transactions.length,
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      itemBuilder: (context, index) {
                        var transaction = transactions[index];
                        var receiverId = transaction['receiverId'];
                        var receiver = receiverDetails[receiverId] ?? {};

                        return Card(
                          color: Colors.white.withOpacity(0.9),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 8.0),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'PayFast Transaction ID: ${transaction['payFastPaymentId']}',
                                  style: TextStyle(
                                      color: MyColors.primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Type: ${transaction['transactionType']}',
                                  style: TextStyle(
                                      color: Colors.grey[800], fontSize: 14),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Amount: \$${transaction['amount']}',
                                  style: TextStyle(
                                      color: MyColors.primaryColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Date: ${transaction['transectionAt']}',
                                  style: TextStyle(
                                      color: Colors.grey[800], fontSize: 14),
                                ),
                                SizedBox(height: 12),
                                Divider(
                                  color: Colors.grey[300],
                                  height: 1,
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Receiver Details:',
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                                SizedBox(height: 8),
                                receiver.isNotEmpty
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Name: ${receiver['name']}',
                                            style: TextStyle(
                                                color: MyColors.primaryColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            'Phone: ${receiver['phone']}',
                                            style: TextStyle(
                                                color: Colors.grey[800],
                                                fontSize: 14),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            'Address: ${receiver['address']}',
                                            style: TextStyle(
                                                color: Colors.grey[800],
                                                fontSize: 14),
                                          ),
                                        ],
                                      )
                                    : Text('Fetching receiver details...',
                                        style: TextStyle(
                                            color: MyColors.primaryColor,
                                            fontSize: 14)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ),
    );
  }
}
