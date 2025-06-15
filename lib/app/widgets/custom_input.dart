import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:tbc_application/util/constants/sizes.dart';

class CustomInput extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool disabled;
  final Widget? prefixIcon;
  final void Function(String? value) onSaved;
  final String? Function(String? value) validator;
  
  CustomInput({
    required this.controller,
    required this.label,
    required this.hint,
    this.disabled = true,
    this.prefixIcon,
    required this.onSaved,
    required this.validator,
  });

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(FSizes.borderRadiusMd),
      child: TextFormField(
        enabled: widget.disabled,
        decoration: InputDecoration(
          prefixIcon: widget.prefixIcon,
          labelText: widget.label.tr,
        ),
        controller: widget.controller,
        onSaved: (value) => widget.onSaved(value),
        validator: (value) => widget.validator(value),
      ),
    );
  }
}
