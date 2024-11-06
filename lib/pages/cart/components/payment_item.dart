import 'package:flutter/material.dart';
import 'package:goodali/shared/components/cached_image.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';

class PaymentItem extends StatelessWidget {
  const PaymentItem({
    super.key,
    required this.onPressed,
    required this.logoPath,
    required this.text,
    this.logoOnline = false,
  });

  final Function() onPressed;
  final String logoPath;
  final String text;
  final bool logoOnline;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: GeneralColors.inputColor,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            logoOnline
                ? CachedImage(
                    imageUrl: logoPath,
                    width: 30,
                    height: 30,
                  )
                : Image.asset(
                    logoPath,
                    width: 30,
                    height: 30,
                  ),
            HSpacer(),
            Expanded(
              child: Text(
                text,
                style: GeneralTextStyle.bodyText(
                  fontSize: 16,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_right_rounded,
              color: GeneralColors.grayColor,
              size: 26,
            )
          ],
        ),
      ),
    );
  }
}
