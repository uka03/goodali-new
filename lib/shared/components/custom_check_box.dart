import 'package:flutter/material.dart';
import 'package:goodali/utils/colors.dart';

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox({super.key, required this.value, required this.onChanged});
  final bool value;
  final Function(bool? value) onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      width: 24,
      child: Checkbox(
        value: value,
        fillColor: WidgetStateProperty.all<Color>(
          value ? GeneralColors.primaryColor : GeneralColors.primaryBGColor,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        side: BorderSide(color: GeneralColors.borderColor, width: 2),
        splashRadius: 5,
        onChanged: onChanged,
      ),
    );
  }
}
