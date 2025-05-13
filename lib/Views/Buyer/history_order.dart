// import 'dart:convert';
// import 'package:agriconnect/Views/Buyer/mainBuyer.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class HistoryOrder extends StatefulWidget {
//   @override
//   _HistoryOrderState createState() => _HistoryOrderState();
// }

// class _HistoryOrderState extends State<HistoryOrder> {
//   List<Map<String, dynamic>> completedOrders = [];
//   int? userId;
//   double totalAmount = 0.0;

//   @override
//   void initState() {
//     super.initState();
//     _initializeData();
//   }

//   Future<void> _initializeData() async {
//     await _loadUserData();
//     if (userId != null) {
//       await fetchCompletedOrders();
//     }
//   }

//   Future<void> _loadUserData() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       userId = prefs.getInt('userId');
//     });
//     print("User ID Loaded: $userId");
//   }

//   Future<void> fetchCompletedOrders() async {
//     if (userId == null) {
//       print("User ID is null. Cannot fetch orders.");
//       return;
//     }

//     final url = Uri.parse('http://152.67.10.128:5280/api/Order/buyer/$userId');
//     print("Fetching data from: $url");

//     try {
//       final response = await http.get(url);

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> jsonData = json.decode(response.body);
//         print("API Response: $jsonData");

//         List<Map<String, dynamic>> extractedOrders = [];
//         double sumTotal = 0.0;

//         List<dynamic> orders = jsonData["\$values"] ?? [];
//         for (var order in orders) {
//           List<dynamic> crops = order["crops"]["\$values"] ?? [];

//           // Check if at least one crop in the order has "Completed" status
//           bool hasCompletedCrop =
//               crops.any((crop) => crop["status"] == "Completed");

//           if (hasCompletedCrop) {
//             extractedOrders.add(order);

//             // Calculate total amount for completed crops in this order
//             for (var crop in crops) {
//               if (crop["status"] == "Completed") {
//                 sumTotal += (crop['amount'] ?? 0).toDouble();
//               }
//             }
//           }
//         }

//         setState(() {
//           completedOrders = extractedOrders;
//           totalAmount = sumTotal;
//         });

//         print("Extracted Completed Orders: $completedOrders");
//       } else {
//         print("Error: ${response.statusCode} - ${response.body}");
//       }
//     } catch (e) {
//       print("Error fetching orders: $e");
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
//           title: Text("Completed Orders"),
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back),
//             onPressed: () {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => BuyerMain()),
//               );
//             },
//           ),
//         ),
//         body: Column(
//           children: [
//             Expanded(
//               child: completedOrders.isEmpty
//                   ? Center(child: CircularProgressIndicator())
//                   : ListView.builder(
//                       itemCount: completedOrders.length,
//                       itemBuilder: (context, index) {
//                         var order = completedOrders[index];
//                         List<dynamic> crops = order["crops"]["\$values"] ?? [];

//                         return Card(
//                           margin: EdgeInsets.all(8),
//                           elevation: 3,
//                           child: Padding(
//                             padding: EdgeInsets.all(8),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text("Order ID: ${order['orderId']}",
//                                     style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold)),
//                                 Text(
// "Total Amount: Rs. ${crops.fold<int>(0, (sum, crop) => crop['status'] == 'Completed' ? sum + (crop['amount'] as num).toInt() : sum)}"
// ,
//                                     style: TextStyle(fontSize: 14)),
//                                 Text("Date: ${order['orderDate']}",
//                                     style: TextStyle(fontSize: 14)),
//                                 SizedBox(height: 5),
//                                 Text("Crops:",
//                                     style:
//                                         TextStyle(fontWeight: FontWeight.bold)),
//                                 ...crops
//                                     .where(
//                                         (crop) => crop["status"] == "Completed")
//                                     .map<Widget>((crop) {
//                                   return ListTile(
//                                     leading: crop['imageUrl'] != null &&
//                                             crop['imageUrl'].isNotEmpty
//                                         ? Image.network(
//                                             crop['imageUrl'],
//                                             width: 50,
//                                             height: 50,
//                                             fit: BoxFit.cover,
//                                             errorBuilder:
//                                                 (context, error, stackTrace) =>
//                                                     Icon(Icons.broken_image,
//                                                         size: 50),
//                                           )
//                                         : Icon(Icons.image_not_supported,
//                                             size: 50),
//                                     title: Text(
//                                         "${crop['name']} (${crop['quantity']})"),
//                                     subtitle:
//                                         Text("Amount: Rs. ${crop['amount']}"),
//                                   );
//                                 }).toList(),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//             ),
//             Container(
//               padding: EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.green[100],
//                 border: Border(
//                   top: BorderSide(color: Colors.green, width: 2),
//                 ),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text("Total Amount:",
//                       style:
//                           TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                   Text("Rs. $totalAmount",
//                       style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.green[800])),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'package:agriconnect/Views/Buyer/mainBuyer.dart';
import 'package:agriconnect/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // For date formatting

class HistoryOrder extends StatefulWidget {
  @override
  _HistoryOrderState createState() => _HistoryOrderState();
}

class _HistoryOrderState extends State<HistoryOrder> {
  List<Map<String, dynamic>> completedOrders = [];
  int? userId;
  double totalAmount = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadUserData();
    if (userId != null) {
      await fetchCompletedOrders();
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId');
    });
    print("User ID Loaded: $userId");
  }

  Future<void> fetchCompletedOrders() async {
    if (userId == null) {
      print("User ID is null. Cannot fetch orders.");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final url = Uri.parse('http://152.67.10.128:5280/api/Order/buyer/$userId');
    print("Fetching data from: $url");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        print("API Response: $jsonData");

        List<Map<String, dynamic>> extractedOrders = [];
        double sumTotal = 0.0;

        List<dynamic> orders = jsonData["\$values"] ?? [];
        for (var order in orders) {
          List<dynamic> crops = order["crops"]["\$values"] ?? [];

          bool hasCompletedCrop =
              crops.any((crop) => crop["status"] == "Completed");

          if (hasCompletedCrop) {
            extractedOrders.add(order);

            for (var crop in crops) {
              if (crop["status"] == "Completed") {
                sumTotal += (crop['amount'] ?? 0).toDouble();
              }
            }
          }
        }

        setState(() {
          completedOrders = extractedOrders;
          totalAmount = sumTotal;
          _isLoading = false;
        });

        print("Extracted Completed Orders: $completedOrders");
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        setState(() {
          _isLoading = false;
        });
        // Consider showing an error message to the user
      }
    } catch (e) {
      print("Error fetching orders: $e");
      setState(() {
        _isLoading = false;
      });
      // Consider showing an error message to the user
    }
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
          title: Text("Completed Orders", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
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
          backgroundColor: MyColors.primaryColor,
        ),
        body: Container(
          color: Color(0xFFE8F5E9), // Light green background
          child: Column( // Wrapped ListView.builder and Container in a Column
            children: [
              Expanded(
                child: _isLoading
                    ? Center(child: CircularProgressIndicator(color: MyColors.primaryColor))
                    : completedOrders.isEmpty
                        ? Center(
                            child: Text("No completed orders yet.",
                                style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.all(8.0),
                            itemCount: completedOrders.length,
                            itemBuilder: (context, index) {
                              var order = completedOrders[index];
                              List<dynamic> crops = order["crops"]["\$values"] ?? [];
                              DateTime orderDate = DateTime.parse(order['orderDate']);
                              String formattedDate =
                                  DateFormat('MMM dd,').format(orderDate);

                              return Card(
                                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                color: Colors.white,
                                child: Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Order ID: ${order['orderId']}",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: MyColors.primaryColor)),
                                      SizedBox(height: 4),
                                      Text("Order Date: $formattedDate",
                                          style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                                      SizedBox(height: 8),
                                      Text("Items:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87)),
                                      SizedBox(height: 4),
                                      ...crops
                                          .where((crop) => crop["status"] == "Completed")
                                          .map<Widget>((crop) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 60,
                                                height: 60,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: crop['imageUrl'] != null &&
                                                        crop['imageUrl'].isNotEmpty
                                                    ? ClipRRect(
                                                        borderRadius: BorderRadius.circular(8),
                                                        child: Image.network(
                                                          crop['imageUrl'],
                                                          width: 60,
                                                          height: 60,
                                                          fit: BoxFit.cover,
                                                          errorBuilder: (context, error, stackTrace) =>
                                                              Icon(Icons.broken_image, size: 30),
                                                        ),
                                                      )
                                                    : Icon(Icons.image, size: 30, color: Colors.grey[400]),
                                              ),
                                              SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(crop['name'] ?? "N/A",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w500, fontSize: 16)),
                                                    Text("Quantity: ${crop['quantity'] ?? 'N/A'}"),
                                                    Text(
                                                        "Amount: Rs. ${crop['amount'] ?? 'N/A'}",
                                                        style: TextStyle(color: MyColors.primaryColor)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: MyColors.primaryColor, width: 2),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total Amount:",
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("Rs. ${totalAmount.toStringAsFixed(2)}",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: MyColors.primaryColor)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}