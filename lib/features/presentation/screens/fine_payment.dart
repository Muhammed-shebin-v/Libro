import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FinePayment extends StatelessWidget {
  final String borrowId;
  const FinePayment({super.key,required this.borrowId});

  Future<void> payfine(String borrowID,context)async{
   await FirebaseFirestore.instance.collection('borrows').doc(borrowID).update({
      'status':'payed'
    });
    Navigator.pop(context,true);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop:false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Fine Payment'),
          leading: IconButton(onPressed: (){Navigator.pop(context,false);}, icon: Icon(Icons.arrow_back_ios)),
        ),
        body:Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('finepayment'),
                TextButton.icon(onPressed: (){
                  payfine(borrowId,context);
                }, label: Text('pay fine'),icon: Icon(Icons.payment),)
              ],
            ),
      
        ),
      ),
    );
  }
}