// import 'package:flutter/material.dart';
// import 'package:libro/features/presentation/dummmy/const.dart';
// import 'package:libro/features/presentation/dummmy/screen2.dart';
// import 'package:libro/features/presentation/dummmy/screen3.dart';

// class Screen1 extends StatefulWidget {
//   const Screen1({super.key});

//   @override
//   State<Screen1> createState() => _Screen1State();
// }

// class _Screen1State extends State<Screen1> {
//   String? name2;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Screen 1')),
//       body: Center(
//         child: Column(
//           children: [
//             Text('username:$username'),
//             Text('email:$email'),
//             Text('score:$score'),

//             TextButton(
//               onPressed: () {
//                 username = 'muhammed shebin';
//                 email = 'vakkayilshebin@gmail.com';
//                 score = 100;
//                 createdAt = DateTime.now();
//                 name2=username;
//                 setState(() {
                  
//                 });
//               },
//               child: Text('press to store data'),
//             ),
//             TextButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>Screen2(name:username!)));}, child: Text('User Screen >')),
//             TextButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>Screen3()));}, child: Text('NextScreen >'))
//           ],
//         ),
//       ),
//     );
//   }
// }
