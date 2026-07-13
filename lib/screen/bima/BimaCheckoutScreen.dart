// summary_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shirikisho/utils/WAColors.dart'; // Import for number formatting

class SummaryPage extends StatefulWidget {
  final String packageName;
  final int duration;
  final double packagePrice;

  SummaryPage({required this.packageName, required this.duration, required this.packagePrice});

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  @override
  Widget build(BuildContext context) {
    double totalAmount = widget.packagePrice * widget.duration; // Calculate total amount

    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Summary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Package Summary",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text("Package Name: ${widget.packageName}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text("Duration: ${widget.duration} Month${widget.duration > 1 ? 's' : ''}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text("Amount per Month: TZS ${NumberFormat.decimalPattern().format(widget.packagePrice)}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text("Total Amount: TZS ${NumberFormat.decimalPattern().format(totalAmount)}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle final payment logic here
                  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Payment Successful!")));
                  Navigator.pop(context); // Return to the previous screen after payment
                },
                child: Text("Confirm and Pay"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: WAPrimaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
