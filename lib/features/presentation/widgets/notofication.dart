// // ==================== USER APP (button handler) ==================== //
// import 'dart:convert';
// import 'dart:developer';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:http/http.dart' as http;

// Future<void> sendNotificationToAdmin({
//   required String username,
//   required String bookName,
// }) async {
//   try {
//     // 1. Get admin token from Firestore
//     final DocumentSnapshot adminDoc = await FirebaseFirestore.instance
//         .collection('admin_tokens')
//         .doc('current_admin')
//         .get();

//     if (!adminDoc.exists || adminDoc['token'] == null) {
//       throw Exception('Admin token not found');
//     }

//     final String adminToken = adminDoc['token'];
//     final String userToken = await FirebaseMessaging.instance.getToken() ?? '';

//     // 2. Construct notification payload
//     final message = {
//       'notification': {
//         'title': 'New User Action',
//         'body': '$username interacted with $bookName',
//       },
//       'data': {
//         'type': 'user_action',
//         'username': username,
//         'bookName': bookName,
//         'userToken': userToken, // Include user token if needed
//         'timestamp': DateTime.now().toIso8601String(),
//         'click_action': 'FLUTTER_NOTIFICATION_CLICK', // Required for navigation
//       },
//       'to': adminToken,
//     };

//     // 3. Send via FCM (using HTTP for direct control)
//     const String serverKey = 'YOUR_FIREBASE_SERVER_KEY';
//     final response = await http.post(
//       Uri.parse('https://fcm.googleapis.com/fcm/send'),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'key=$serverKey',
//       },
//       body: jsonEncode(message),
//     );

//     if (response.statusCode != 200) {
//       throw Exception('FCM failed: ${response.body}');
//     }
//     log('📤 Notification sent successfully');
//   } catch (e) {
//     log('❌ Notification error: $e');
//     // Show user error feedback
//   }
// }

