import 'package:flutter/material.dart';
import 'package:tbc_application/util/constants/colors.dart';

class EnumDropdown<T extends Enum> extends StatelessWidget {
  final String label;
  final String hint;
  final List<T> items;
  final T? value;
  final void Function(T?) onChanged;
  final bool disabled;
  final Widget? suffixIcon;
  final String Function(T item) getLabel;

  const EnumDropdown({
    super.key,
    required this.label,
    required this.hint,
    required this.items,
    required this.onChanged,
    required this.getLabel,
    this.value,
    this.disabled = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: disabled ? FColors.primaryExtraSoft : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 1, color: FColors.secondaryExtraSoft),
        ),
        child: DropdownButtonFormField<T>(
          value: value,
          onChanged: disabled ? null : onChanged,
          icon: suffixIcon ?? const Icon(Icons.arrow_drop_down),
          style: const TextStyle(fontSize: 14, fontFamily: 'poppins'),
          decoration: InputDecoration(
            label: Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: InputBorder.none,
            hintText: hint,
            hintStyle: const TextStyle(
              fontSize: 14,
              fontFamily: 'poppins',
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(getLabel(item), style: Theme.of(context).textTheme.bodyLarge),
            );
          }).toList(),
        ),
      ),
    );
  }
}
