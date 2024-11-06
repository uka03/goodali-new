import 'package:flutter/material.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/globals.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/types.dart';

class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({
    super.key,
    required this.onChanged,
    required this.selectedIndex,
  });
  final Function(int index) onChanged;
  final int selectedIndex;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: bottomItems
            .map(
              (e) => BottomItem(
                item: e,
                selectedIndex: selectedIndex,
                onChanged: onChanged,
              ),
            )
            .toList(),
      ),
    );
  }
}

class BottomItem extends StatelessWidget {
  const BottomItem({
    super.key,
    required this.item,
    required this.selectedIndex,
    required this.onChanged,
  });
  final BottomItemData item;
  final int selectedIndex;
  final Function(int index) onChanged;

  @override
  Widget build(BuildContext context) {
    final color = selectedIndex == item.index ? GeneralColors.primaryColor : GeneralColors.grayColor;
    return Expanded(
      child: CustomButton(
        onTap: () {
          onChanged(item.index);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              item.iconPath,
              width: 30,
              color: color,
            ),
            VSpacer.sm(),
            Text(
              item.title,
              style: GeneralTextStyle.bodyText(
                fontWeight: FontWeight.w500,
                textColor: color,
              ),
            )
          ],
        ),
      ),
    );
  }
}
