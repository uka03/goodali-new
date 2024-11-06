import 'package:flutter/material.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/text_styles.dart';

class HomeTitle extends StatelessWidget {
  const HomeTitle({
    super.key,
    required this.title,
    this.onPressed,
  });
  final String title;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: GeneralTextStyle.titleText(fontSize: 24),
        ),
        if (onPressed != null)
          CustomButton(
            onTap: () {
              onPressed!();
            },
            child: Icon(
              Icons.arrow_forward,
              size: 28,
              color: GeneralColors.grayColor,
            ),
          )
      ],
    );
  }
}
