import 'package:flutter/material.dart';
import 'package:medi_alert/utils/colors.dart';

class QuickActionCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback? onTap; // Optional callback function

  const QuickActionCard({
    required this.title,
    required this.description,
    this.onTap, // Initialize the callback function
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Card(
        color: WHITE,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 4,
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w700),
          ),
          subtitle: Text(description),
          horizontalTitleGap: 20,
          trailing: Icon(Icons.arrow_forward, color: Colors.blue),
          onTap: () {
            if (onTap != null) {
              onTap!(); // Call the callback function if it is provided
            }
          },
        ),
      ),
    );
  }
}
