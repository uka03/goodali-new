import 'package:flutter/material.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/home/provider/home_provider.dart';
import 'package:goodali/pages/mood/mood_detail.dart';
import 'package:goodali/pages/podcast/components/podcast_item.dart';
import 'package:goodali/shared/components/cached_image.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/utils/spacer.dart';

class HomeFeel extends StatelessWidget {
  const HomeFeel({
    super.key,
    required this.homeData,
  });
  final HomeData homeData;

  @override
  Widget build(BuildContext context) {
    final double imageSize = MediaQuery.of(context).size.width / 3 - 30;
    return SingleChildScrollView(
      child: Column(
        children: [
          if (homeData.moodMain.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: PodcastItem(
                podcast: homeData.moodMain[0],
                type: 'mood',
              ),
            ),
          VSpacer(),
          GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: homeData.moods.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 0.7,
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              final mood = homeData.moods[index];
              return CustomButton(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    MoodDetail.path,
                    arguments: mood.id,
                  );
                },
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(80),
                      child: CachedImage(
                        imageUrl: mood.banner.toUrl(),
                        width: imageSize,
                        height: imageSize,
                        size: "xs",
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      mood.title ?? "",
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );

    // return CustomScrollView(
    //   slivers: [
    //     SliverToBoxAdapter(
    //       child:
    //     ),

    //
    //     const SliverToBoxAdapter(child: VSpacer()),

    //     // Mood Grid
    //     SliverGrid(

    //       delegate: SliverChildBuilderDelegate(
    //         (context, index) {

    //         },
    //       ),
    //     ),
    //   ],
    // );
  }
}
