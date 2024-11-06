import 'package:flutter/material.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/globals.dart';
import 'package:goodali/utils/text_styles.dart';

class TypeBar extends StatelessWidget {
  const TypeBar({
    super.key,
    required this.onChanged,
    required this.selectedType,
    required this.typeItems,
  });
  final Function(int index) onChanged;
  final int selectedType;
  final List<TypeItem> typeItems;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      padding: EdgeInsets.symmetric(horizontal: 16),
      isScrollable: true,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorWeight: 4,
      tabAlignment: TabAlignment.center,
      labelPadding: EdgeInsets.symmetric(horizontal: 4),
      onTap: onChanged,
      indicatorColor: GeneralColors.primaryColor,
      labelColor: GeneralColors.primaryColor,
      labelStyle: GeneralTextStyle.titleText(
        fontWeight: FontWeight.w600,
      ),
      tabs: typeItems
          .map(
            (type) => TypeItemWidget(type: type, selectedType: selectedType),
          )
          .toList(),
    );
  }
}

class TypeItemWidget extends StatelessWidget {
  const TypeItemWidget({
    super.key,
    required this.type,
    required this.selectedType,
  });

  final TypeItem type;
  final int selectedType;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(3),
          bottomRight: Radius.circular(3),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Center(
        child: Text(
          type.title,
          style: GeneralTextStyle.titleText(
            textColor: selectedType == type.index ? GeneralColors.primaryColor : GeneralColors.grayColor,
            fontWeight: selectedType == type.index ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
