// import 'package:agriconnect/Views/chatting/chatScrren.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ContactsScreen extends StatelessWidget {
//   final String phone;
//   ContactsScreen({required this.phone});
//   final DatabaseReference dbRef = FirebaseDatabase.instance.ref();

//   @override
//   Widget build(BuildContext context) {
//     print(phone);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Contacts'),
//         backgroundColor: Colors.green,
//       ),
//       body: StreamBuilder(
//         stream: dbRef.child('users').onValue,
//         builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
//           if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
//             return Center(child: CircularProgressIndicator());
//           }

//           Map<dynamic, dynamic>? usersMap =
//               snapshot.data!.snapshot.value as Map<dynamic, dynamic>?;
//           List users =
//               usersMap?.keys.where((key) => key != phone).toList() ?? [];

//           return Column(
//             children: [
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: users.length,
//                   itemBuilder: (context, index) {
//                     String contactPhone = users[index];

//                     return Card(
//                       elevation: 4,
//                       margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: ListTile(
//                         leading: CircleAvatar(
//                           backgroundColor: Colors.green.shade700,
//                           child: Icon(Icons.person, color: Colors.white),
//                         ),
//                         title: Text(
//                           usersMap![contactPhone]['name'],
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         subtitle: Text(contactPhone),
//                         trailing: Icon(Icons.chat, color: Colors.green),
//                         onTap: () {
//                           // Navigate to ChatScreen with required arguments
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => ChatScreen(
//                                 sender: phone,
//                                 receiver: contactPhone,
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               // ✅ Signup Button (at the bottom)
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
