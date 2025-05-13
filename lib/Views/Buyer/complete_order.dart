// import 'dart:convert';
// import 'package:agriconnect/Views/Buyer/mainBuyer.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class ConfirmedOrdersScreen extends StatefulWidget {
//   @override
//   _ConfirmedOrdersScreenState createState() => _ConfirmedOrdersScreenState();
// }

// class _ConfirmedOrdersScreenState extends State<ConfirmedOrdersScreen> {
//   List<Map<String, dynamic>> confirmedCrops = [];
//   int? userId;

//   @override
//   void initState() {
//     super.initState();
//     _initializeData();
//   }

//   Future<void> _initializeData() async {
//     await _loadUserData();
//     if (userId != null) {
//       await fetchConfirmedCrops();
//     }
//   }

//   Future<void> _loadUserData() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       userId = prefs.getInt('userId');
//     });
//     print("User ID Loaded: $userId");
//   }

//   Future<void> fetchConfirmedCrops() async {
//     if (userId == null) {
//       print("User ID is null. Cannot fetch crops.");
//       return;
//     }

//     final url = Uri.parse('http://152.67.10.128:5280/api/Order/buyer/$userId');
//     print("Fetching data from: $url");

//     try {
//       final response = await http.get(url);

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> jsonData = json.decode(response.body);
//         print("API Response: $jsonData");

//         List<Map<String, dynamic>> extractedCrops = [];

//         List<dynamic> orders = jsonData["\$values"] ?? [];
//         for (var order in orders) {
//           List<dynamic> cropsList = order["crops"]["\$values"] ?? [];
//           for (var crop in cropsList) {
//             if (crop["status"] == "ConfirmOrder") {
//               // Add orderId to each crop
//               crop["orderId"] = order["orderId"];
//               extractedCrops.add(crop);
//             }
//           }
//         }

//         setState(() {
//           confirmedCrops = extractedCrops;
//         });

//         print("Extracted Confirmed Crops: $confirmedCrops");
//       } else {
//         print("Error: ${response.statusCode} - ${response.body}");
//       }
//     } catch (e) {
//       print("Error fetching crops: $e");
//     }
//   }

//   Future<void> completeOrder(int orderId) async {
//     final url =
//         Uri.parse('http://152.67.10.128:5280/api/Order/complete/$orderId');
//     print("Completing order: $url");

//     try {
//       final response = await http.post(url);
//       if (response.statusCode == 200) {
//         print("Order $orderId marked as completed");
//         setState(() {
//           confirmedCrops.removeWhere((crop) => crop['orderId'] == orderId);
//         });
//       } else {
//         print(
//             "Error completing order: ${response.statusCode} - ${response.body}");
//       }
//     } catch (e) {
//       print("Error completing order: $e");
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
//           title: Text("Confirmed Orders"),
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
//         body: confirmedCrops.isEmpty
//             ? Center(child: CircularProgressIndicator())
//             : Column(
//                 children: [
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: confirmedCrops.length,
//                       itemBuilder: (context, index) {
//                         var crop = confirmedCrops[index];
//                         return Card(
//                           margin: EdgeInsets.all(10),
//                           elevation: 4,
//                           child: Padding(
//                             padding: EdgeInsets.all(10),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 crop['imageUrl'] != null
//                                     ? Image.network(
//                                         crop['imageUrl'],
//                                         height: 150,
//                                         width: double.infinity,
//                                         fit: BoxFit.cover,
//                                       )
//                                     : Container(),
//                                 SizedBox(height: 10),
//                                 Text("Name: ${crop['name']}",
//                                     style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold)),
//                                 Text("Category: ${crop['category']}"),
//                                 Text("Quantity: ${crop['quantity']}"),
//                                 Text("Amount: Rs. ${crop['amount']}"),
//                                 SizedBox(height: 10),
//                                 ElevatedButton(
//                                   onPressed: () {
//                                     completeOrder(crop['orderId']);
//                                     // completeOrder(crop['orderId']);
//                                     print(crop);
//                                   },
//                                   child: Text("Completed"),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
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

class ConfirmedOrdersScreen extends StatefulWidget {
  @override
  _ConfirmedOrdersScreenState createState() => _ConfirmedOrdersScreenState();
}

class _ConfirmedOrdersScreenState extends State<ConfirmedOrdersScreen> {
  List<Map<String, dynamic>> confirmedCrops = [];
  int? userId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadUserData();
    if (userId != null) {
      await fetchConfirmedCrops();
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

  Future<void> fetchConfirmedCrops() async {
    if (userId == null) {
      print("User ID is null. Cannot fetch crops.");
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

        List<Map<String, dynamic>> extractedCrops = [];

        List<dynamic> orders = jsonData["\$values"] ?? [];
        for (var order in orders) {
          List<dynamic> cropsList = order["crops"]["\$values"] ?? [];
          for (var crop in cropsList) {
            if (crop["status"] == "ConfirmOrder") {
              // Add orderId to each crop
              crop["orderId"] = order["orderId"];
              extractedCrops.add(crop);
            }
          }
        }

        setState(() {
          confirmedCrops = extractedCrops;
          _isLoading = false;
        });

        print("Extracted Confirmed Crops: $confirmedCrops");
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching crops: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> completeOrder(int orderId) async {
    final url =
        Uri.parse('http://152.67.10.128:5280/api/Order/complete/$orderId');
    print("Completing order: $url");

    try {
      final response = await http.post(url);
      if (response.statusCode == 200) {
        print("Order $orderId marked as completed");
        setState(() {
          confirmedCrops.removeWhere((crop) => crop['orderId'] == orderId);
        });
      } else {
        print(
            "Error completing order: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Error completing order: $e");
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
          title: Text("Confirmed Orders", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => BuyerMain()),
              );
            },
          ),
          backgroundColor: MyColors.primaryColor,
          elevation: 2,
        ),
        body: Container(
          color: Color(0xFFE8F5E9), // Light green background
          child: _isLoading
              ? Center(child: CircularProgressIndicator(color: MyColors.primaryColor))
              : confirmedCrops.isEmpty
                  ? Center(
                      child: Text("No confirmed orders yet.",
                          style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(8.0),
                      itemCount: confirmedCrops.length,
                      itemBuilder: (context, index) {
                        var crop = confirmedCrops[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                crop['imageUrl'] != null
                                    ? Container(
                                        width: double.infinity,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8.0),
                                          image: DecorationImage(
                                            image: NetworkImage(crop['imageUrl']),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        width: double.infinity,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8.0),
                                          color: Colors.grey[200],
                                        ),
                                        child: Icon(Icons.image_not_supported, size: 48, color: Colors.grey[400]),
                                      ),
                                SizedBox(height: 10),
                                Text("Name: ${crop['name']}",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87)),
                                SizedBox(height: 4),
                                Text("Category: ${crop['category']}", style: TextStyle(color: Colors.grey[600])),
                                SizedBox(height: 4),
                                Text("Quantity: ${crop['quantity']}", style: TextStyle(color: Colors.grey[600])),
                                SizedBox(height: 4),
                                Text("Amount: Rs. ${crop['amount']}",
                                    style: TextStyle(color: MyColors.primaryColor, fontWeight: FontWeight.w500)),
                                SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      completeOrder(crop['orderId']);
                                      print(crop);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: MyColors.primaryColor,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    child: Text("Mark as Completed"),
                                  ),
                                ),
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