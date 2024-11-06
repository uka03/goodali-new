import 'package:flutter/material.dart';
import 'package:goodali/connection/model/tag_response.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/text_styles.dart';

class TagItem extends StatelessWidget {
  const TagItem({
    super.key,
    required this.tag,
  });

  final TagResponseData? tag;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: GeneralColors.primaryColor,
              )),
          child: Text(
            tag?.name ?? "",
            style: GeneralTextStyle.bodyText(
              textColor: GeneralColors.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
