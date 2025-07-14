import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:libro/features/auth/auth_service.dart';
import 'package:libro/core/themes/fonts.dart';
import 'package:libro/features/presentation/screens/user_edit.dart';
import 'package:libro/features/presentation/widgets/chatscree.dart';
import 'package:libro/features/presentation/widgets/sub2.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatelessWidget {
  final String uid;
  final String userName;
  final String imgUrl;
  Settings({super.key, required this.imgUrl, required this.uid, required this.userName});

  final _auth = AuthService();

  final List<String> infos = [
    'About',
    'Privacy',
    'Subscription',
    'Fine history',
  ];

  final List<IconData> icons = [
    Icons.home_outlined,
    Icons.privacy_tip_outlined,
    Icons.subscriptions_outlined,
    Icons.history_outlined,
  ];

  Future<void> deleteUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs..remove('uid')..remove('username')..remove('imgUrl');
  }

  Future<void> showLogoutDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Do you really want to log out?"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              await _auth.signout();
              await deleteUserFromPrefs();
              if (!context.mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LibroSubscriptionScreen2()),
              );
            },
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color60,
      appBar: AppBar(
        backgroundColor: AppColors.color60,
        title: Text('Settings and Activity', style: AppFonts.heading2),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your Account', style: AppFonts.heading3),
              const Gap(5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: const [BoxShadow(offset: Offset(2, 2))],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(imgUrl, fit: BoxFit.fill),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(userName, style: AppFonts.body1),
                            Text('password, personal info, profile image', style: AppFonts.body2),
                          ],
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserEditScreen(uid: uid)),
                    ),
                  ),
                ],
              ),
              const Gap(50),
              Text('More Info and Support', style: AppFonts.heading3),
              const Gap(5),
              SizedBox(
                height: 230,
                child: ListView.builder(
                  itemCount: infos.length,
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(icons[index]),
                            const Gap(10),
                            Text(infos[index]),
                          ],
                        ),
                        IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_forward)),
                      ],
                    );
                  },
                ),
              ),
              const Gap(50),
              InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Chatscreen(userId: uid)),
                ),
                child:  Text(
                  'Chat with Admin',
                  style: TextStyle(color:AppColors.black),
                ),
              ),
              Gap(20),
              InkWell(
                onTap: () async => await showLogoutDialog(context),
                child: const Text('Log out', style: TextStyle(color: Colors.red)),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Text('Version 1.0.2', style: AppFonts.body1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
