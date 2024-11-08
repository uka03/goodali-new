import 'package:flutter/material.dart';
import 'package:goodali/connection/model/post_response.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/article/article_detail.dart';
import 'package:goodali/shared/components/cached_image.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/globals.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/utils.dart';

class ArticleItem extends StatelessWidget {
  const ArticleItem({
    super.key,
    required this.post,
    this.onPressed,
  });

  final PostResponseData? post;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onTap: () {
        if (onPressed != null) {
          onPressed!();
          return;
        }
        Navigator.pushNamed(context, ArticleDetail.path, arguments: post?.id);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedImage(
            imageUrl: post?.banner.toUrl() ?? placeholder,
            size: "xs",
            width: 80,
            height: 80,
            borderRadius: 8,
          ),
          HSpacer(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post?.title ?? "",
                  style: GeneralTextStyle.titleText(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                VSpacer.xs(),
                Text(
                  formatDate(post?.createdAt),
                  style: GeneralTextStyle.bodyText(textColor: GeneralColors.primaryColor),
                ),
                VSpacer(size: 12),
                Text(
                  removeHtmlTags(post?.body ?? ""),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
