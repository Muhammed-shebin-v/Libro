import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:libro/features/auth/auth_service.dart';
import 'package:libro/features/data/models/user_model.dart';
import 'package:libro/features/presentation/screens/login_screen.dart';
import 'package:libro/core/themes/fonts.dart';
import 'package:libro/features/presentation/widgets/sub2.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatelessWidget {
  Settings({super.key});
  final _auth = AuthService();
    Future<void> deleteUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
     prefs..remove('uid')..
     remove('username')..remove('imgUrl');
     

   
  }
  @override
  Widget build(BuildContext contextS) {
    return Scaffold(
      backgroundColor: AppColors.color60,
      appBar: AppBar(
        backgroundColor: AppColors.color60,
        title: Text('Settings and Activitiy', style: AppFonts.heading2),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your Account', style: AppFonts.heading3),
              Gap(5),
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
                          boxShadow: [BoxShadow(offset: Offset(2, 2))],
                        ),
                        child: Image(
                          image: AssetImage('lib/assets/calcifer.jpg'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Sarah John', style: AppFonts.body1),
                            Text(
                              'password,personal info,profile image',
                              style: AppFonts.body2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(children: [Icon(Icons.arrow_forward), Gap(14)]),
                ],
              ),
              Gap(50),
              Text('More info and Support', style: AppFonts.heading3),
              Gap(5),
              SizedBox(
                height: 230,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(icons[index]),
                            Gap(10),
                            Text(infos[index]),
                          ],
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.arrow_forward),
                        ),
                      ],
                    );
                  },
                  itemCount: infos.length,
                ),
              ),
              Gap(50),

              Gap(10),
             
              Gap(5),
              InkWell(
                onTap: ()async{
                 await showLogoutDialog(contextS);
                 await deleteUserFromPrefs();
                  },
                child: Text('Log out', style: TextStyle(color: Colors.red)),
              ),
              Expanded(child: SizedBox()),
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

  final infos = [
    'About',
    'Privacy',
    'Help - connect admin',
    'Subscription',
    'Fine history',
  ];
  final icons = [
    Icons.home_outlined,
    Icons.privacy_tip_outlined,
    Icons.help_outlined,
    Icons.subscriptions_outlined,
    Icons.history_outlined,
  ];
  Future<void> showLogoutDialog(BuildContext contextS) async {
  return showDialog(
    context: contextS,
    builder: (context) => AlertDialog(
      title: Text("Logout"),
      content: Text("Do you really want to log out?"),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), 
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: ()async {
            await  _auth.signout();
            
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LibroSubscriptionScreen2()),
                  );
          },
          child: Text("Logout", style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}
}