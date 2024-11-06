import 'package:flutter/material.dart';
import 'package:goodali/connection/model/podcast_response.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/podcast/components/audio_controls.dart';
import 'package:goodali/pages/podcast/components/player_provider.dart';
import 'package:goodali/shared/components/cached_image.dart';
import 'package:goodali/shared/components/custom_app_bar.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:provider/provider.dart';

class PodcastPlayer extends StatefulWidget {
  const PodcastPlayer({super.key});
  static const String path = "/podcast";

  @override
  State<PodcastPlayer> createState() => _PodcastPlayerState();
}

class _PodcastPlayerState extends State<PodcastPlayer> {
  late final PlayerProvider _playerProvider;
  @override
  void initState() {
    super.initState();
    _playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final data = ModalRoute.of(context)?.settings.arguments as PodcastResponseData?;
      await _playerProvider.init(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: GeneralColors.primaryBGColor,
          appBar: CustomAppBar(),
          body: SafeArea(
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CachedImage(
                      imageUrl: provider.data?.banner.toUrl() ?? "",
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.width * 0.6,
                      borderRadius: 12,
                    ),
                    Text(
                      provider.data?.title.toString() ?? "",
                      style: GeneralTextStyle.titleText(fontSize: 24),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButton(
                          onTap: () {},
                          child: Column(
                            children: [
                              Icon(
                                Icons.arrow_downward_rounded,
                                size: 30,
                                color: GeneralColors.grayColor,
                              ),
                              VSpacer.sm(),
                              Text(
                                "Татах",
                                style: GeneralTextStyle.bodyText(),
                              )
                            ],
                          ),
                        ),
                        HSpacer(size: 80),
                        CustomButton(
                          onTap: () {},
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/icons/ic_info_menu.png",
                                width: 30,
                                height: 30,
                                color: GeneralColors.grayColor,
                              ),
                              VSpacer.sm(),
                              Text(
                                "Татах",
                                style: GeneralTextStyle.bodyText(),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    StreamBuilder<SeekBarData>(
                      stream: provider.streamController?.stream,
                      builder: (context, snapshot) {
                        final positionData = snapshot.data;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: Column(
                            children: [
                              CustomProgressBar(
                                progress: positionData?.position,
                                total: positionData?.duration,
                                buffered: positionData?.bufferedPosition,
                                onSeek: (value) {
                                  provider.audioPlayer?.seek(value);
                                },
                              ),
                              VSpacer(),
                              AudioControls(
                                audioProvider: provider,
                                positionData: positionData,
                              ),
                              VSpacer(),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Container(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CustomProgressBar extends StatelessWidget {
  const CustomProgressBar({
    super.key,
    required this.progress,
    required this.total,
    this.buffered,
    this.onSeek,
    this.isMiniPlayer = false,
  });
  final Duration? progress;
  final Duration? total;
  final Duration? buffered;
  final Function(Duration value)? onSeek;
  final bool isMiniPlayer;

  @override
  Widget build(BuildContext context) {
    return ProgressBar(
      progress: progress ?? Duration.zero,
      total: total ?? Duration.zero,
      buffered: buffered ?? Duration.zero,
      thumbGlowRadius: isMiniPlayer ? 0.0 : 30.0,
      thumbRadius: isMiniPlayer ? 0.0 : 10,
      progressBarColor: GeneralColors.primaryColor,
      baseBarColor: GeneralColors.grayColor,
      bufferedBarColor: Colors.grey,
      timeLabelLocation: isMiniPlayer ? TimeLabelLocation.none : null,
      onSeek: (value) {
        if (onSeek != null) {
          onSeek!(value);
        }
      },
      barHeight: 4,
      thumbColor: GeneralColors.primaryColor,
      timeLabelType: TimeLabelType.remainingTime,
      timeLabelTextStyle: GeneralTextStyle.bodyText(
        fontSize: 14,
        textColor: GeneralColors.grayColor,
      ),
    );
  }
}
