import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:libro/features/data/models/book.dart';

class BorrowDetails extends StatelessWidget {
  final BookModel bookData;
  const BorrowDetails({super.key, required this.bookData});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap(20),
        _buildRow(
          (bookData.returnDate!.difference(DateTime.now()).inDays).toString(),
          'Remaining Days:',
          Icons.date_range_outlined,
        ),
        _buildRow(bookData.status!, 'Status', Icons.verified_outlined),
        _buildRow(bookData.fine.toString(), 'Fine', Icons.money),
        _buildRow(
          DateFormat(
            'dd-MM-yyyy',
          ).format(DateTime.parse(bookData.borrowDate.toString())),
          'Borrowed Date',
          Icons.calendar_month_outlined,
        ),
        _buildRow(
          DateFormat(
            'dd-MM-yyyy',
          ).format(DateTime.parse(bookData.returnDate.toString())),
          'Return Date',
          Icons.calendar_month_outlined,
        ),
      ],
    );
  }

  Widget _buildRow(String data, String title, IconData icon) {
    return Row(children: [Icon(icon), Text('$title:$data')]);
  }
}
