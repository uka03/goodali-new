import 'package:flutter/material.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/text_styles.dart';

class ActionItem extends StatelessWidget {
  const ActionItem({
    super.key,
    required this.iconPath,
    required this.onPressed,
    this.count,
  });
  final String iconPath;
  final VoidCallback onPressed;
  final int? count;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onTap: onPressed,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: GeneralColors.inputColor,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Image.asset(
              iconPath,
              width: 24,
              height: 24,
            ),
          ),
          count != null
              ? Positioned(
                  right: 0,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: GeneralColors.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        (count ?? 0).toString(),
                        style: GeneralTextStyle.bodyText(
                          textColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }
}
