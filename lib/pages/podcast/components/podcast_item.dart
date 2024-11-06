import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:goodali/connection/model/podcast_response.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/cart/provider/cart_provider.dart';
import 'package:goodali/pages/podcast/components/player_provider.dart';
import 'package:goodali/pages/podcast/podcast_player.dart';
import 'package:goodali/shared/components/cached_image.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/utils.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

class PodcastItem extends StatelessWidget {
  const PodcastItem({
    super.key,
    required this.podcast,
  });

  final PodcastResponseData? podcast;

  @override
  Widget build(BuildContext context) {
    Widget actionBtn() {
      if (podcast?.isPaid == false) {
        return CustomButton(
          onTap: () {
            final cart = context.read<CartProvider>();
            cart.addCart(podcast?.productId);
          },
          child: Image.asset(
            "assets/icons/ic_cart.png",
            width: 24,
            color: GeneralColors.grayColor,
          ),
        );
      }
      // if (podcast?.isPaid == true) {
      //   return SizedBox();
      // }
      return Icon(
        Icons.arrow_downward_rounded,
        color: GeneralColors.grayColor,
      );
    }

    return Consumer<PlayerProvider>(
      builder: (context, provider, _) {
        return CustomButton(
          onTap: () {
            Navigator.pushNamed(context, PodcastPlayer.path, arguments: podcast);
          },
          child: Column(
            children: [
              VSpacer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CachedImage(
                    width: 44,
                    height: 44,
                    imageUrl: podcast?.banner.toUrl() ?? "",
                    borderRadius: 4,
                  ),
                  HSpacer(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          podcast?.title ?? "",
                          style: GeneralTextStyle.titleText(),
                        ),
                        VSpacer.sm(),
                        Text(
                          removeHtmlTags(podcast?.body ?? ""),
                          style: GeneralTextStyle.bodyText(
                            textColor: GeneralColors.grayColor,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              VSpacer(),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        provider.data?.id == podcast?.id
                            ? StreamBuilder<PlayerState>(
                                stream: provider.audioPlayer?.playerStateStream,
                                builder: (context, snapshot) {
                                  final playerState = snapshot.data;
                                  final processingState = playerState?.processingState;
                                  final playing = playerState?.playing;
                                  if (processingState == ProcessingState.loading || processingState == ProcessingState.buffering) {
                                    return Container(
                                      decoration: BoxDecoration(color: GeneralColors.grayBGColor, borderRadius: BorderRadius.circular(30)),
                                      padding: EdgeInsets.all(11),
                                      child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: const Color.fromARGB(255, 160, 102, 102),
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    );
                                  } else if (playing != true) {
                                    return audioBtn(
                                      icon: Icons.play_arrow_rounded,
                                      color: GeneralColors.primaryColor,
                                      onPressed: () async {
                                        provider.setPlayerState(CustomState.playing);
                                      },
                                    );
                                  } else if (processingState != ProcessingState.completed) {
                                    return audioBtn(
                                      icon: Icons.pause_rounded,
                                      color: GeneralColors.primaryColor,
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
                              )
                            : audioBtn(
                                icon: Icons.play_arrow_rounded,
                                onPressed: () async {
                                  await provider.init(podcast);
                                  provider.setPlayerState(CustomState.playing);
                                },
                              ),
                        HSpacer(),
                        provider.data?.id == podcast?.id
                            ? Expanded(
                                child: StreamBuilder<SeekBarData>(
                                  stream: provider.streamController?.stream,
                                  builder: (context, snapshot) {
                                    final positionData = snapshot.data;

                                    return Row(
                                      children: [
                                        Expanded(
                                          child: ProgressBar(
                                            progress: positionData?.position ?? Duration.zero,
                                            total: positionData?.duration ?? Duration.zero,
                                            buffered: positionData?.bufferedPosition ?? Duration.zero,
                                            thumbGlowRadius: 0.0,
                                            thumbRadius: 0.0,
                                            progressBarColor: GeneralColors.primaryColor,
                                            baseBarColor: GeneralColors.grayColor,
                                            bufferedBarColor: Colors.grey,
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
                                          ),
                                        ),
                                        HSpacer(),
                                        Text(
                                          "${formatDuration(((positionData?.duration ?? Duration.zero) - (positionData?.position ?? Duration.zero)).inSeconds)} үлдсэн",
                                          style: GeneralTextStyle.bodyText(
                                            fontSize: 14,
                                            textColor: GeneralColors.primaryColor,
                                          ),
                                        ),
                                        HSpacer(),
                                      ],
                                    );
                                  },
                                ),
                              )
                            : Text(formatDuration(podcast?.audioDuration)),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      actionBtn(),
                      HSpacer(),
                      Icon(
                        Icons.more_horiz,
                        color: GeneralColors.grayColor,
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget audioBtn({required IconData icon, required Function() onPressed, Color? color}) {
    return CustomButton(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(color: GeneralColors.grayBGColor, borderRadius: BorderRadius.circular(30)),
        padding: EdgeInsets.all(8),
        child: Icon(
          icon,
          size: 26,
          color: color,
        ),
      ),
    );
  }
}
