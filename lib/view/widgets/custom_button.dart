import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final Color color;
  final VoidCallback onPressed;
  final Widget child;

  CustomButton({
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.color,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius),
             boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Shadow color
              spreadRadius: 2, // Spread radius
              blurRadius: 5, // Blur radius
              offset: Offset(0, 3), // Offset in the y direction
            ),
          ],
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}