import 'package:flutter/material.dart';
import 'package:libro/features/auth/auth_service.dart';
import 'package:libro/features/presentation/widgets/form.dart';
import 'package:libro/features/presentation/widgets/long_button.dart';

class ForgetPassword extends StatelessWidget {
   ForgetPassword({super.key});
  TextEditingController _emailController =TextEditingController();
  final _auth =AuthService();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text('Enter your email to send you a password reset email'),
          CustomForm(title: 'Email', controller:_emailController , validator: (value) {
            if(value==null||value.isEmpty){
              return 'Enter valid email';
            }
            return null;
          }),
          CustomLongButton(widget: Text('Send Email'), ontap: (){
            _auth.sendForgetEmailLink(email: _emailController.text);
          })
        ],
      ),
    );
  }
}