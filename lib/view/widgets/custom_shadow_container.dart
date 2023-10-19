import 'package:flutter/material.dart';

class CustomShadowContainer extends StatelessWidget {
  final Widget child;

  CustomShadowContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 230, 230, 230),
            blurRadius: 9,
            offset: Offset(3, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}
