import 'package:flutter/material.dart';
import 'package:goodali/connection/model/video_response.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/video/video_detail.dart';
import 'package:goodali/shared/components/cached_image.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/utils/globals.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/utils.dart';

class VideoItem extends StatelessWidget {
  const VideoItem({
    super.key,
    required this.video,
    this.onPressed,
  });

  final VideoResponseData? video;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onTap: () {
        if (onPressed != null) {
          onPressed!();
          return;
        }
        Navigator.pushNamed(context, VideoDetail.path, arguments: video);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: CachedImage(
              imageUrl: video?.banner.toUrl() ?? placeholder,
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video?.title ?? "",
                  style: GeneralTextStyle.titleText(
                    fontSize: 16,
                  ),
                ),
                VSpacer.xs(),
                Text(
                  formatDate(video?.createdAt),
                  style: GeneralTextStyle.bodyText(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
