import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final int? maxLine;
 final void Function()? onTap;
  final TextInputType keyboardType;
  final TextEditingController? controller;
final String? Function(String?)? validator;
  CustomTextField({
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.validator,
     this.labelText,
      this.maxLine, this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        validator:validator,
        maxLines: maxLine,
        onTap:onTap,
        decoration: InputDecoration(
          hintText: hintText,
           labelStyle: const TextStyle(
        color: Colors.grey, 
        fontSize: 14.0,
        fontWeight: FontWeight.w500   
      
      ),
          labelText: labelText,
          contentPadding: const EdgeInsets.symmetric(vertical: 17.0, horizontal: 10),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[400]!),
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.grey[400]!),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.grey[400]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.grey[400]!),
          ),
        ),
        keyboardType: keyboardType,
        controller: controller,
      ),
    );
  }
}