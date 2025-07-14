import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:libro/features/data/models/book.dart';
import 'package:libro/features/data/models/user_model.dart';
import 'package:libro/features/presentation/screens/fine_payment.dart';
import 'package:libro/features/presentation/widgets/review.dart';

class ReturnService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> returnBookRquest(
    BookModel bookData,
    BuildContext context,
    UserModel userData,
  ) async {
    try {
      showLoadingDialogBorrow(context);
      final userDoc = await _firestore.collection('users').doc(userData.uid).get();
      if (!userDoc.exists) {
        log("User not found");
        throw Exception("User not found");
      }

      // if(bookData.status!= 'borrowed'){
      //   return;
      // }
      if (bookData.status == 'overdue'||bookData.fine!>0) {
        Navigator.pop(context);
        final result = await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (context) => FinePayment(borrowId: bookData.borrowId!),
          ),
        );
        if (result == true) {
        await  Navigator.push(context, MaterialPageRoute(builder: (context)=>AddReviewScreen(bookId: bookData.uid, userId: userData.uid!, userName:userData.username! , userImage:userData.imgUrl! )));
          successSnackBar("Book's return request sent", context);
        } else {
          errorSnackBar('request not sent,due to pending fine', context);
          log('hehehe');
        }
      } else if (bookData.status == 'borrowed') {
        await  Navigator.push(context, MaterialPageRoute(builder: (context)=>AddReviewScreen(bookId: bookData.uid, userId: userData.uid!, userName:userData.username! , userImage:userData.imgUrl! )));
        updateBorrowStatus(bookData.borrowId!);
        Navigator.pop(context);
        successSnackBar("Book's return request sent", context);
      } else if (bookData.status == 'requested') {
        Navigator.pop(context);
        cautionSnackBar(
          'your request is pending,wait for admin repond!',
          context,
        );
      } else {
        Navigator.pop(context);
        errorSnackBar('something went wrong', context);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void showLoadingDialogBorrow(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );
  }

  void updateBorrowStatus(String borrowId) async {
    _firestore.collection('borrows').doc(borrowId).update({
      'status': 'requested',
    });
  }

  void successSnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_box_outline_blank_outlined, color: Colors.white),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void errorSnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void cautionSnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline_outlined, color: Colors.white),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
