import 'package:flutter/material.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/text_styles.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    this.content,
    this.title,
    this.backgroundColor,
    required this.onPressed,
    this.textColor,
    this.radius,
  });
  final VoidCallback onPressed;
  final Widget? content;
  final String? title;
  final Color? backgroundColor, textColor;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          elevation: WidgetStatePropertyAll(0),
          backgroundColor: WidgetStatePropertyAll(
            backgroundColor ?? GeneralColors.primaryColor,
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius ?? 16),
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: content ??
                  Text(
                    title ?? '',
                    textAlign: TextAlign.center,
                    style: GeneralTextStyle.titleText(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      textColor: textColor ?? GeneralColors.primaryBGColor,
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
