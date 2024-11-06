import 'package:flutter/material.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/home/components/home_title.dart';
import 'package:goodali/pages/home/provider/home_provider.dart';
import 'package:goodali/pages/training/training_page.dart';
import 'package:goodali/shared/components/cached_image.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/utils/globals.dart';
import 'package:goodali/utils/spacer.dart';

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
            if (item.title?.isNotEmpty == true)
              HomeTitle(
                title: item.title ?? "",
              ),
            VSpacer(),
            if (item.item.training != null)
              CustomButton(
                onTap: () {
                  if (onPressed != null) {
                    onPressed!();
                    return;
                  }
                  Navigator.pushNamed(context, TrainingPage.path, arguments: item.item.training);
                },
                child: Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: CachedImage(
                        imageUrl: item.item.training?.banner.toUrl() ?? placeholder,
                        borderRadius: 8,
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
