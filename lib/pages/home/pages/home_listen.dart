import 'package:flutter/material.dart';
import 'package:goodali/extensions/list_extensions.dart';
import 'package:goodali/pages/album/components/album_item.dart';
import 'package:goodali/pages/home/components/home_title.dart';
import 'package:goodali/pages/home/provider/home_provider.dart';
import 'package:goodali/pages/podcast/components/podcast_item.dart';
import 'package:goodali/pages/video/components/video_item.dart';
import 'package:goodali/utils/spacer.dart';

class HomeListen extends StatelessWidget {
  const HomeListen({
    super.key,
    required this.homeData,
  });

  final List<HomeDataType> homeData;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: homeData.length,
      separatorBuilder: (context, index) => VSpacer(),
      itemBuilder: (context, index) {
        final data = homeData[index];
        return Column(
          children: [
            if (data.title?.isNotEmpty == true)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    HomeTitle(
                      title: data.title ?? "",
                      onPressed: data.path?.isNotEmpty == true
                          ? () {
                              Navigator.pushNamed(context, data.path ?? "/");
                            }
                          : null,
                    ),
                    VSpacer(),
                  ],
                ),
              ),
            if (data.item.albums?.isNotEmpty == true)
              SizedBox(
                height: 250,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: data.item.albums?.limitLenght(6) ?? 0,
                  separatorBuilder: (context, index) => HSpacer(),
                  itemBuilder: (context, index) {
                    final album = data.item.albums?[index];
                    return AlbumItem(album: album);
                  },
                ),
              ),
            if (data.item.podcast != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: PodcastItem(
                  podcast: data.item.podcast,
                  type: 'podcast',
                ),
              ),
            if (data.item.video != null)
              VideoItem(
                video: data.item.video,
              ),
          ],
        );
      },
    );
    // return SliverList(
    //   delegate: SliverChildListDelegate(
    //     [
    //       Padding(
    //         padding: const EdgeInsets.symmetric(horizontal: 16.0),
    //         child: HomeTitle(
    //           title: "Цомог лекц",
    //           onPressed: () {
    //             Navigator.pushNamed(context, AlbumsPage.path);
    //           },
    //         ),
    //       ),
    //       VSpacer(),
    // SizedBox(
    //   height: 250,
    //   child: ListView.separated(
    //     padding: EdgeInsets.symmetric(horizontal: 16),
    //     scrollDirection: Axis.horizontal,
    //     itemCount: homeData.albums.limitLenght(6),
    //     separatorBuilder: (context, index) => HSpacer(),
    //     itemBuilder: (context, index) {
    //       final album = homeData.albums[index];
    //       return AlbumItem(album: album);
    //     },
    //   ),
    // ),
    //       VSpacer(),
    //       Padding(
    //         padding: const EdgeInsets.symmetric(horizontal: 16.0),
    //         child: HomeTitle(
    //           title: "Подкаст",
    //         ),
    //       ),
    //       VSpacer(),
    //       ListView.builder(
    //         padding: EdgeInsets.symmetric(horizontal: 16),
    //         physics: NeverScrollableScrollPhysics(),
    //         shrinkWrap: true,
    //         itemCount: homeData.podcasts.limitLenght(4),
    //         itemBuilder: (context, index) {
    //           final podcast = homeData.podcasts[index];

    //           return PodcastItem(
    //             podcast: podcast,
    //           );
    //         },
    //       ),
    //       VSpacer(),
    //       Padding(
    //         padding: const EdgeInsets.symmetric(horizontal: 16.0),
    //         child: HomeTitle(
    //           title: "Видео",
    //           onPressed: () {
    //             Navigator.pushNamed(context, VideosPage.path);
    //           },
    //         ),
    //       ),
    //       VSpacer(),
    //       ListView.builder(
    //         physics: NeverScrollableScrollPhysics(),
    //         shrinkWrap: true,
    //         itemCount: homeData.videos.limitLenght(4),
    //         itemBuilder: (context, index) {
    //           final video = homeData.videos[index];
    //           return VideoItem(video: video);
    //         },
    //       ),
    //     ],
    //   ),
    // );
  }
}
