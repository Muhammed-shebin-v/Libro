// // user_home_screen.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:libro/features/presentation/widgets/noti.dart';

// class UserHomeScreen extends StatelessWidget {
//   const UserHomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<UserBloc, UserState>(
//       listener: (context, state) {
//         if (state is NotificationOpenedState) {
//           // Navigate to the specified route
//           Navigator.pushNamed(context, state.route);
          
//           // Run custom function based on notification type
//           if (state.data['type'] == 'admin_approval') {
//             _handleAdminApproval(state.data);
//           }
//         }
//       },
//       child: Scaffold(
//         appBar: AppBar(title: const Text('User App')),
//         body: BlocBuilder<UserBloc, UserState>(
//           builder: (context, state) {
//             if (state is UserLoading) {
//               return const Center(child: CircularProgressIndicator());
//             }
            
//             if (state is UserError) {
//               return Center(child: Text(state.message));
//             }
            
//             return const Center(
//               child: Text('Home Screen - Waiting for notifications'),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   void _handleAdminApproval(Map<String, dynamic> data) {
//     final username = data['username'] ?? 'User';
//     print('Running custom function for $username');
//     // Add your custom business logic here
//   }
// }