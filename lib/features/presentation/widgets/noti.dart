// // user_bloc.dart
// import 'dart:convert';
// import 'package:bloc/bloc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';

// class UserBloc extends Bloc<UserEvent, UserState> {
//   final FirebaseFirestore firestore;
//   final FirebaseMessaging messaging;
//   final FirebaseAuth auth;

//   UserBloc({
//     required this.firestore,
//     required this.messaging,
//     required this.auth,
//   }) : super(UserInitial()) {
//     on<InitUserEvent>(_onInitUser);
//     on<NotificationReceivedEvent>(_onNotificationReceived);
//     on<NotificationOpenedEvent>(_onNotificationOpened);
//   }

//   Future<void> _onInitUser(
//       InitUserEvent event, Emitter<UserState> emit) async {
//     emit(UserLoading());
//     try {
//       // Get or create FCM token
//       final token = await _getFcmToken();

//       // Save token to user document
//       await _saveTokenToFirestore(token);

//       // Set up notification listeners
//       _setupNotificationHandlers();

//       emit(UserReady());
//     } catch (e) {
//       emit(UserError(message: 'Initialization failed: $e'));
//     }
//   }

//   Future<String> _getFcmToken() async {
//     // Request permissions for mobile platforms
//     if (!kIsWeb) {
//       final settings = await messaging.requestPermission();
//       if (settings.authorizationStatus == AuthorizationStatus.denied) {
//         throw Exception('Notification permission denied');
//       }
//     }

//     // Get token
//     final token = await messaging.getToken(
//       vapidKey: kIsWeb ? 'YOUR_VAPID_KEY' : null,
//     );
    
//     if (token == null) throw Exception('Failed to get FCM token');
//     return token;
//   }

//   Future<void> _saveTokenToFirestore(String token) async {
//     final user = auth.currentUser;
//     if (user == null) throw Exception('User not authenticated');
    
//     await firestore.collection('users').doc(user.uid).set({
//       'fcmToken': token,
//       'lastUpdated': FieldValue.serverTimestamp(),
//     }, SetOptions(merge: true));
//   }

//   void _setupNotificationHandlers() {
//     // Foreground messages
//     FirebaseMessaging.onMessage.listen((message) {
//       add(NotificationReceivedEvent(message: message));
//     });

//     // Background/terminated messages
//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       add(NotificationOpenedEvent(message: message));
//     });

//     // Initial message from terminated state
//     FirebaseMessaging.instance.getInitialMessage().then((message) {
//       if (message != null) {
//         add(NotificationOpenedEvent(message: message));
//       }
//     });
//   }

//   Future<void> _onNotificationReceived(
//       NotificationReceivedEvent event, Emitter<UserState> emit) async {
//     // Handle foreground notifications
//     emit(NotificationReceivedState(message: event.message));
    
//     // For mobile: Show local notification
//     if (!kIsWeb) {
//       await _showLocalNotification(event.message);
//     }
//   }

//   Future<void> _onNotificationOpened(
//       NotificationOpenedEvent event, Emitter<UserState> emit) async {
//     // Navigate to specific screen
//     final route = event.message.data['route'] ?? '/home';
//     emit(NotificationOpenedState(
//       route: route,
//       data: event.message.data,
//     ));
//   }

//   Future<void> _showLocalNotification(RemoteMessage message) async {
//     // Implementation for mobile local notifications
//     // (Would require flutter_local_notifications package)
//   }
// }

// // user_event.dart

// @immutable
// abstract class UserEvent {}

// class InitUserEvent extends UserEvent {}

// class NotificationReceivedEvent extends UserEvent {
//   final RemoteMessage message;

//   NotificationReceivedEvent({required this.message});
// }

// class NotificationOpenedEvent extends UserEvent {
//   final RemoteMessage message;

//   NotificationOpenedEvent({required this.message});
// }

// // user_state.dart

// @immutable
// abstract class UserState {}

// class UserInitial extends UserState {}

// class UserLoading extends UserState {}

// class UserReady extends UserState {}

// class UserError extends UserState {
//   final String message;

//   UserError({required this.message});
// }

// class NotificationReceivedState extends UserState {
//   final RemoteMessage message;

//   NotificationReceivedState({required this.message});
// }

// class NotificationOpenedState extends UserState {
//   final String route;
//   final Map<String, dynamic> data;

//   NotificationOpenedState({required this.route, required this.data});
// }

// // approved_screen.dart
// class ApprovedScreen extends StatelessWidget {
//   const ApprovedScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Approval Confirmed')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.check_circle, size: 100, color: Colors.green),
//             const SizedBox(height: 20),
//             const Text(
//               'Your request has been approved!',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 30),
//             ElevatedButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Back to Home'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }