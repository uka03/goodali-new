import 'package:flutter/material.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/home/provider/home_provider.dart';
import 'package:goodali/pages/training/training_page.dart';
import 'package:goodali/shared/components/cached_image.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/utils/globals.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/utils.dart';

class HomeTraining extends StatelessWidget {
  const HomeTraining({super.key, required this.homeData, this.onPressed});

  final List<HomeDataType> homeData;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: homeData.length,
      padding: EdgeInsets.symmetric(horizontal: 16),
      separatorBuilder: (context, index) => VSpacer(),
      itemBuilder: (context, index) {
        final item = homeData[index];
        return Column(
          children: [
            if (item.item.training != null)
              CustomButton(
                onTap: () {
                  if (onPressed != null) {
                    onPressed!();
                    return;
                  }
                  Navigator.pushNamed(context, TrainingPage.path, arguments: item.item.training?.id);
                },
                child: Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: CachedImage(
                        imageUrl: item.item.training?.banner.toUrl() ?? placeholder,
                        borderRadius: 8,
                      ),
                    ),
                    Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        gradient: LinearGradient(
                          stops: const [
                            0.6,
                            1
                          ],
                          colors: [
                            Colors.black.withOpacity(0.3),
                            Colors.transparent,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      top: 20,
                      bottom: 20,
                      left: 16,
                      right: 16,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  item.item.training?.name ?? "",
                                  style: GeneralTextStyle.titleText(
                                    fontSize: 34,
                                    textColor: Colors.white,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  removeHtmlTags(item.item.training?.body ?? ""),
                                  style: GeneralTextStyle.titleText(
                                    textColor: Colors.white,
                                    fontSize: 14,
                                  ),
                                  maxLines: 2,
                                  // overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          HSpacer(),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(60),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Дэлгэрэнгүй",
                                        style: GeneralTextStyle.titleText(
                                          fontSize: 14,
                                        ),
                                      ),
                                      HSpacer.sm(),
                                      Icon(
                                        Icons.arrow_forward,
                                        size: 20,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
