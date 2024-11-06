import 'package:flutter/material.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/spacer.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.hasPresident = false,
    this.title,
    this.action,
    this.leading,
    this.bgColor,
    this.bottom,
  });

  final bool hasPresident;
  final Widget? title, leading;
  final List<Widget>? action;
  final Color? bgColor;
  final PreferredSizeWidget? bottom;
  @override
  get preferredSize => Size.fromHeight(hasPresident ? 90 : 50);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: true,
      leading: leading,
      scrolledUnderElevation: 0,
      backgroundColor: bgColor ?? GeneralColors.primaryBGColor,
      centerTitle: false,
      title: title,
      bottom: bottom,
      actions: [
        ...action ?? [],
        HSpacer()
      ],
    );
  }
}
