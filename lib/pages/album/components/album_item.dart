import 'package:flutter/material.dart';
import 'package:goodali/connection/model/album_response.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/album/album_detail.dart';
import 'package:goodali/shared/components/cached_image.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/globals.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';

class AlbumItem extends StatelessWidget {
  const AlbumItem({
    super.key,
    required this.album,
  });

  final AlbumResponseData? album;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onTap: () {
        Navigator.pushNamed(context, AlbumDetail.path, arguments: album?.id);
      },
      child: SizedBox(
        width: 180,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedImage(
              borderRadius: 8,
              height: 180,
              width: 180,
              size: "xs",
              imageUrl: album?.banner.toUrl() ?? placeholder,
            ),
            VSpacer(size: 12),
            Text(
              album?.title ?? "",
              style: GeneralTextStyle.titleText(
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            VSpacer(size: 12),
            Text(
              "${album?.totalLectures} aудио",
              style: GeneralTextStyle.bodyText(
                textColor: GeneralColors.textGrayColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
