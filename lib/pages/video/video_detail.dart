import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goodali/connection/model/video_response.dart';
import 'package:goodali/pages/home/components/home_title.dart';
import 'package:goodali/pages/video/components/video_item.dart';
import 'package:goodali/pages/video/provider/video_provider.dart';
import 'package:goodali/shared/components/custom_app_bar.dart';
import 'package:goodali/shared/components/custom_read_more.dart';
import 'package:goodali/shared/general_scaffold.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoDetail extends StatefulWidget {
  const VideoDetail({super.key});

  static const String path = "/video-detail";

  @override
  _VideoDetailState createState() => _VideoDetailState();
}

class _VideoDetailState extends State<VideoDetail> {
  YoutubePlayerController? _controller;
  late final VideoProvider provider;
  VideoResponseData? video;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<VideoProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final videoInitial = ModalRoute.of(context)?.settings.arguments as VideoResponseData?;

      provider.getSimilarVideos(videoInitial?.id);
      setState(() {
        video = videoInitial;
        _controller = YoutubePlayerController(
          initialVideoId: video?.videoUrl ?? "", // YouTube видеоны ID
          flags: YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
            isLive: false,
            enableCaption: true,
            forceHD: true,
            hideThumbnail: true,
            controlsVisibleAtStart: true,
          ),
        );
      });
      _controller?.addListener(() {
        if (_controller!.value.isFullScreen) {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        } else {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        }
      });
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller != null
        ? YoutubePlayerBuilder(
            builder: (context, player) {
              return Selector<VideoProvider, List<VideoResponseData>>(
                  selector: (p0, p1) => p1.similarVideos,
                  builder: (context, videos, _) {
                    return GeneralScaffold(
                      horizontalPadding: 0,
                      appBar: CustomAppBar(),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            player,
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                children: [
                                  VSpacer(),
                                  Text(
                                    video?.title ?? "",
                                    style: GeneralTextStyle.titleText(fontSize: 24),
                                    textAlign: TextAlign.center,
                                  ),
                                  CustomReadMore(
                                    text: removeHtmlTags(video?.body ?? ""),
                                  ),
                                  HomeTitle(
                                    title: "Төстэй видео",
                                  ),
                                ],
                              ),
                            ),
                            VSpacer(),
                            ListView.separated(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: videos.length,
                              separatorBuilder: (context, index) => VSpacer(),
                              itemBuilder: (context, index) {
                                final simVideo = videos[index];
                                return VideoItem(
                                  video: simVideo,
                                  onPressed: () {
                                    _controller?.load(simVideo.videoUrl ?? "");
                                    provider.getSimilarVideos(simVideo.id);
                                    setState(() {
                                      video = simVideo;
                                    });
                                  },
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    );
                  });
            },
            player: YoutubePlayer(
              controller: _controller!,
              showVideoProgressIndicator: true,
              onReady: () {
                print('Player is ready.');
              },
              onEnded: (data) {},
            ),
          )
        : GeneralScaffold(child: SizedBox.shrink());
  }
}
