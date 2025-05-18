// import 'package:agriconnect/Views/chatting/chatScrren.dart';
// import 'package:agriconnect/Views/chatting/registerScreen.dart';
// import 'package:agriconnect/constants/colors.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// class ContactsScreen extends StatefulWidget {
//   final String phone;
//   ContactsScreen({required this.phone});

//   @override
//   State<ContactsScreen> createState() => _ContactsScreenState();
// }

// class _ContactsScreenState extends State<ContactsScreen> {
//   final DatabaseReference dbRef = FirebaseDatabase.instance.ref();

//   // ✅ Logout Function
//   Future<void> logout(BuildContext context) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.clear();

//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => RegisterScreen()),
//     );
//   }

//   // ✅ Add Contact Dialog
//   Future<void> showAddContactDialog() async {
//     TextEditingController phoneController = TextEditingController();
//     TextEditingController nameController = TextEditingController();

//     await showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Add Contact'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: phoneController,
//                 decoration: InputDecoration(labelText: 'Phone Number'),
//               ),
//               TextField(
//                 controller: nameController,
//                 decoration: InputDecoration(labelText: 'Name'),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 String contactPhone = phoneController.text.trim();
//                 String contactName = nameController.text.trim();

//                 // 🔍 Check if user exists
//                 DataSnapshot snapshot = await dbRef.child('users').child(contactPhone).get();
//                 if (snapshot.exists) {
//                   // ✅ Save contact under current user
//                   await dbRef
//                       .child('contacts')
//                       .child(widget.phone)
//                       .child(contactPhone)
//                       .set({
//                     'name': contactName,
//                     'phone': contactPhone,
//                   });
//                   Navigator.pop(context);
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('User not found')),
//                   );
//                 }
//               },
//               child: Text('Add'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Contacts',style: TextStyle(color: Colors.white),),
//         backgroundColor: MyColors.primaryColor,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () => logout(context),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.green,
//         onPressed: showAddContactDialog,
//         child: Icon(Icons.person_add),
//       ),
//       body: StreamBuilder(
//         stream: dbRef.child('contacts').child(widget.phone).onValue,
//         builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
//           if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
//             return Center(
//               child: Text("No contacts found.\nTap '+' to add one.", textAlign: TextAlign.center),
//             );
//           }

//           Map<dynamic, dynamic> contactsMap =
//               snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

//           List<Map<String, dynamic>> contacts = contactsMap.entries.map((entry) {
//             return {
//               'phone': entry.value['phone'],
//               'name': entry.value['name'],
//             };
//           }).toList();

//           return ListView.builder(
//             itemCount: contacts.length,
//             itemBuilder: (context, index) {
//               final contact = contacts[index];

//               return Card(
//                 elevation: 4,
//                 margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: ListTile(
//                   leading: CircleAvatar(
//                     backgroundColor: Colors.green.shade700,
//                     child: Icon(Icons.person, color: Colors.white),
//                   ),
//                   title: Text(
//                     contact['name']!,
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   subtitle: Text(contact['phone']!),
//                   trailing: Icon(Icons.chat, color: Colors.green),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ChatScreen(
//                           sender: widget.phone,
//                           receiver: contact['phone']!,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:agriconnect/Views/chatting/chatScrren.dart';
import 'package:agriconnect/Views/chatting/registerScreen.dart';
import 'package:agriconnect/constants/colors.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactsScreen extends StatefulWidget {
  final String phone;
  ContactsScreen({required this.phone});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  bool _isLoading = false; // Track loading state
  List<Map<String, dynamic>> _contacts = []; // Use a List to store contacts

  // ✅ Logout Function
  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => RegisterScreen()),
    );
  }

  // ✅ Add Contact Dialog
  Future<void> showAddContactDialog() async {
    TextEditingController phoneController = TextEditingController();
    TextEditingController nameController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Contact',
              style: TextStyle(fontWeight: FontWeight.w600)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                String contactPhone = phoneController.text.trim();
                String contactName = nameController.text.trim();

                if (contactPhone.isEmpty || contactName.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill in all fields.')),
                  );
                  return; // Don't proceed if fields are empty
                }

                setState(() {
                  _isLoading = true; // Show loading indicator during the check
                });
                // 🔍 Check if user exists
                DatabaseEvent event =
                    await dbRef.child('users').child(contactPhone).once();
                DataSnapshot snapshot = event.snapshot;

                if (snapshot.value != null) {
                  // ✅ Save contact under current user
                  await dbRef
                      .child('contacts')
                      .child(widget.phone)
                      .child(contactPhone)
                      .set({
                    'name': contactName,
                    'phone': contactPhone,
                  });
                  Navigator.pop(context);
                  // Refresh the contact list after adding.
                  fetchContacts(); // Call fetchContacts to update the list
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('User not found')),
                  );
                }
                setState(() {
                  _isLoading = false; // Hide loading indicator
                });
              },
              child: _isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    )
                  : Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // Function to fetch and update the contacts list
  Future<void> fetchContacts() async {
    setState(() {
      _isLoading = true;
    });
    DatabaseEvent event =
        await dbRef.child('contacts').child(widget.phone).once();
    DataSnapshot snapshot = event.snapshot;

    if (snapshot.value != null) {
      Map<dynamic, dynamic> contactsMap =
          snapshot.value as Map<dynamic, dynamic>;
      List<Map<String, dynamic>> fetchedContacts =
          contactsMap.entries.map((entry) {
        return {
          'phone': entry.value['phone'] ?? '', // Handle null values
          'name': entry.value['name'] ?? '', // Handle null values
        };
      }).toList();
      setState(() {
        _contacts = fetchedContacts;
      });
    } else {
      setState(() {
        _contacts = []; // Ensure _contacts is empty if no data
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchContacts(); // Load contacts when the screen initializes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contacts',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: MyColors.primaryColor,
        elevation: 2,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () => logout(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.primaryColor,
        onPressed: showAddContactDialog,
        child: Icon(Icons.person_add, color: Colors.white),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: MyColors.primaryColor),
            ) // Show loading indicator
          : _contacts.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "No contacts found.\nTap '+' to add a contact.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: _contacts.length,
                  itemBuilder: (context, index) {
                    final contact = _contacts[index];
                    final String contactName =
                        contact['name'] ?? 'Unknown'; // Provide a default value
                    final String contactPhone = contact['phone'] ??
                        'No Phone'; // Provide a default value

                    return Card(
                      elevation: 3,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: MyColors.primaryColor,
                          child: Text(
  contactName.isNotEmpty ? contactName[0].toUpperCase() : '?',
  style: TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  ),
),
                        ),
                        title: Text(
                          contactName,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                        subtitle: Text(contactPhone),
                        trailing:
                            Icon(Icons.chat, color: MyColors.primaryColor),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                sender: widget.phone,
                                receiver: contactPhone,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
