
import 'package:flutter/material.dart';


class RetourButton extends StatelessWidget {
  final VoidCallback onPressed;

  const RetourButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(
        Icons.reply,
        color: Colors.orange,
        size: 30,
      ),
      label: Text(
        "Retour",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        backgroundColor: Colors.orange.shade100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
