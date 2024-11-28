import 'package:flutter/material.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/auth/provider/auth_provider.dart';
import 'package:goodali/shared/components/cached_image.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/globals.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/types.dart';
import 'package:provider/provider.dart';

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
    return Consumer<AuthProvider>(builder: (context, provider, _) {
      return Expanded(
        child: CustomButton(
          onTap: () {
            onChanged(item.index);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              item.index == 2 && provider.user != null
                  ? CachedImage(
                      imageUrl: provider.user?.avatar.toUrl() ?? "",
                      width: 30,
                      height: 30,
                      borderRadius: 50,
                    )
                  : Image.asset(
                      item.iconPath,
                      width: 30,
                      color: color,
                    ),
              VSpacer.sm(),
              Text(
                item.index == 2 && provider.user != null ? provider.user?.nickname ?? "" : item.title,
                style: GeneralTextStyle.bodyText(
                  fontWeight: FontWeight.w500,
                  textColor: color,
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
