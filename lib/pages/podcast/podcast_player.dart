import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:goodali/connection/model/podcast_response.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/podcast/components/audio_controls.dart';
import 'package:goodali/pages/podcast/components/player_provider.dart';
import 'package:goodali/shared/components/cached_image.dart';
import 'package:goodali/shared/components/custom_app_bar.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/dailogs.dart';
import 'package:goodali/utils/globals.dart';
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
      final arg = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      showLoader();
      PodcastResponseData? data;
      if (arg["data"] != null) {
        data = arg["data"];
      } else {
        data = await _playerProvider.getPodcastById(arg["id"]);
      }
      dismissLoader();
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CachedImage(
                  imageUrl: provider.data?.banner.toUrl() ?? "",
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.width * 0.6,
                  size: "small",
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
                      onTap: () {
                        showModalSheet(
                          context,
                          child: SingleChildScrollView(
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: HtmlWidget(provider.data?.body ?? ""),
                            ),
                          ),
                        );
                      },
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
                            "Тайлбар",
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
    this.progressBarColor,
    this.baseBarColor,
    this.bufferedBarColor,
    this.textColor,
  });
  final Duration? progress;
  final Duration? total;
  final Duration? buffered;
  final Function(Duration value)? onSeek;
  final bool isMiniPlayer;
  final Color? progressBarColor, baseBarColor, bufferedBarColor, textColor;

  @override
  Widget build(BuildContext context) {
    return ProgressBar(
      progress: progress ?? Duration.zero,
      total: total ?? Duration.zero,
      buffered: buffered ?? Duration.zero,
      thumbGlowRadius: isMiniPlayer ? 0.0 : 30.0,
      thumbRadius: isMiniPlayer ? 0.0 : 10,
      progressBarColor: progressBarColor ?? GeneralColors.primaryColor,
      baseBarColor: baseBarColor ?? GeneralColors.grayColor,
      bufferedBarColor: bufferedBarColor ?? Colors.grey,
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
        textColor: textColor ?? GeneralColors.grayColor,
      ),
    );
  }
}
