import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class CustomDropdownField<T> extends StatelessWidget {
  final String? labelText;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
final double? width;
  CustomDropdownField({
    this.labelText,
    this.value,
    required this.items,
    this.onChanged,
    this.validator, this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField2<T>(
        isExpanded: true,
        
        value: value,
        items: items,
        onChanged: onChanged,
        validator: validator,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
          ),
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
           suffixIconConstraints: BoxConstraints(
            maxWidth: width ?? 200,
          ),
        ),
      ),
    );
  }
}
