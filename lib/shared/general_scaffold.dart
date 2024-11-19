import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/podcast/components/player_provider.dart';
import 'package:goodali/shared/components/cached_image.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/utils.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

class GeneralScaffold extends StatelessWidget {
  const GeneralScaffold({
    super.key,
    required this.child,
    this.appBar,
    this.padding,
    this.horizontalPadding,
    this.bottomBar,
    this.verticalPadding,
    this.bottom = true,
  });
  final Widget child;
  final PreferredSizeWidget? appBar;
  final EdgeInsets? padding;
  final double? horizontalPadding;
  final double? verticalPadding;
  final Widget? bottomBar;
  final bool bottom;

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerProvider>(
      builder: (context, provider, _) {
        final data = provider.data;
        return Scaffold(
          appBar: appBar,
          backgroundColor: GeneralColors.primaryBGColor,
          bottomNavigationBar: bottomBar,
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: data != null
              ? Container(
                  decoration: BoxDecoration(
                    color: GeneralColors.borderColor,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: Row(
                          children: [
                            CachedImage(
                              imageUrl: data.banner.toUrl(),
                              width: 40,
                              height: 40,
                              borderRadius: 4,
                            ),
                            HSpacer(),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    data.title ?? "",
                                    style: GeneralTextStyle.titleText(
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    removeHtmlTags(data.body ?? ""),
                                    style: GeneralTextStyle.bodyText(),
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                            StreamBuilder<PlayerState>(
                              stream: provider.audioPlayer?.playerStateStream,
                              builder: (context, snapshot) {
                                final playerState = snapshot.data;
                                final processingState = playerState?.processingState;
                                final playing = playerState?.playing;
                                if (processingState == ProcessingState.loading || processingState == ProcessingState.buffering) {
                                  return SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                      strokeWidth: 2,
                                    ),
                                  );
                                } else if (playing != true) {
                                  return audioBtn(
                                    icon: Icons.play_arrow_rounded,
                                    onPressed: () {
                                      provider.setPlayerState(CustomState.playing);
                                    },
                                  );
                                } else if (processingState != ProcessingState.completed) {
                                  return audioBtn(
                                    icon: Icons.pause_rounded,
                                    onPressed: () {
                                      provider.setPlayerState(CustomState.paused);
                                    },
                                  );
                                } else {
                                  provider.setPlayerState(CustomState.completed);
                                  return audioBtn(
                                    icon: Icons.replay,
                                    onPressed: () {
                                      provider.setPlayerState(CustomState.playing);
                                      provider.audioPlayer?.seek(
                                        Duration.zero,
                                        index: provider.audioPlayer?.effectiveIndices!.first,
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                            HSpacer(),
                            audioBtn(
                              icon: Icons.close,
                              onPressed: () {
                                provider.setPlayerState(CustomState.disposed);
                              },
                            ),
                          ],
                        ),
                      ),
                      StreamBuilder<SeekBarData>(
                        stream: provider.streamController?.stream,
                        builder: (context, snapshot) {
                          final positionData = snapshot.data;

                          return ProgressBar(
                            progress: positionData?.position ?? Duration.zero,
                            total: positionData?.duration ?? Duration.zero,
                            buffered: positionData?.bufferedPosition ?? Duration.zero,
                            thumbGlowRadius: 0.0,
                            thumbRadius: 0.0,
                            progressBarColor: GeneralColors.primaryColor,
                            baseBarColor: Color(0xFFF3F0EE),
                            bufferedBarColor: Color.fromARGB(255, 209, 209, 209),
                            timeLabelLocation: TimeLabelLocation.none,
                            onSeek: (value) {
                              provider.audioPlayer?.seek(
                                value,
                                index: provider.audioPlayer?.effectiveIndices!.first,
                              );
                            },
                            barHeight: 4,
                            thumbColor: GeneralColors.primaryColor,
                            timeLabelType: TimeLabelType.remainingTime,
                            timeLabelTextStyle: GeneralTextStyle.bodyText(
                              fontSize: 14,
                              textColor: GeneralColors.grayColor,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )
              : null,
          body: Padding(
            padding: padding ??
                EdgeInsets.symmetric(
                  horizontal: horizontalPadding ?? 20.0,
                  vertical: verticalPadding ?? 20.0,
                ),
            child: SafeArea(
              bottom: bottom,
              child: child,
            ),
          ),
        );
      },
    );
  }

  CustomButton audioBtn({required IconData icon, required Function() onPressed}) {
    return CustomButton(
      onTap: onPressed,
      child: Icon(
        icon,
        size: 30,
        color: Colors.black,
      ),
    );
  }
}
