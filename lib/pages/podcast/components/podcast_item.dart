import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:goodali/connection/model/podcast_response.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/auth/provider/auth_provider.dart';
import 'package:goodali/pages/cart/provider/cart_provider.dart';
import 'package:goodali/pages/podcast/components/player_provider.dart';
import 'package:goodali/pages/podcast/podcast_player.dart';
import 'package:goodali/shared/components/cached_image.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/toasts.dart';
import 'package:goodali/utils/utils.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

class PodcastItem extends StatelessWidget {
  const PodcastItem({
    super.key,
    required this.podcast,
    this.onclickAfter,
  });

  final PodcastResponseData? podcast;
  final Function()? onclickAfter;

  @override
  Widget build(BuildContext context) {
    Widget actionBtn({required bool isCarted}) {
      if (podcast?.isPaid == false) {
        return CustomButton(
          onTap: () {
            final user = context.read<AuthProvider>().user;
            if (user != null) {
              final cart = context.read<CartProvider>();
              if (isCarted) {
                cart.removeCart(podcast?.productId);
                Toast.success(context, description: "Сагсанаас хасалаа.");
              } else {
                cart.addCart(podcast?.productId);
                Toast.success(context, description: "Сагсанд нэмэгдлээ.");
              }
            } else {
              Toast.error(context, description: "Та нэвтрэх хэрэгтэй.");
            }
          },
          child: Container(
            decoration: BoxDecoration(color: isCarted ? GeneralColors.primaryColor : GeneralColors.grayBGColor, borderRadius: BorderRadius.circular(20)),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Row(
              children: [
                Image.asset(
                  "assets/icons/ic_cart.png",
                  width: 24,
                  color: isCarted ? Colors.white : Colors.black,
                ),
                HSpacer.sm(),
                Text(
                  isCarted ? "Хасах" : "Сагслах",
                  style: GeneralTextStyle.titleText(
                    fontSize: 14,
                    textColor: isCarted ? Colors.white : Colors.black,
                  ),
                )
              ],
            ),
          ),
        );
      }
      // if (podcast?.isPaid == true) {
      //   return SizedBox();
      // }
      return SizedBox();
    }

    return Consumer2<PlayerProvider, CartProvider>(
      builder: (context, provider, cartprovider, _) {
        final isCarted = cartprovider.cartData?.cartItems?.where((e) => e.productId == podcast?.productId).toList();
        return CustomButton(
          onTap: () async {
            await Navigator.pushNamed(context, PodcastPlayer.path, arguments: {
              "id": podcast?.id,
              "data": podcast,
            });
            if (onclickAfter != null) {
              onclickAfter!();
            }
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
                    size: "xs",
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
                        if (podcast?.price != null)
                          Column(
                            children: [
                              VSpacer.sm(),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(text: "Үнэ: "),
                                    TextSpan(
                                      text: formatCurrency(podcast?.price ?? 0),
                                      style: GeneralTextStyle.bodyText(
                                        fontSize: 14,
                                        textColor: GeneralColors.primaryColor,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
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
                  Expanded(child: getCustomStatus(provider)),
                  actionBtn(
                    isCarted: isCarted?.isNotEmpty == true,
                  ),
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

  Widget getCustomStatus(PlayerProvider provider) {
    final isCurrentPodcast = provider.data?.id == podcast?.id;

    if (podcast == null) {
      return SizedBox();
    }
    return ListenableBuilder(
        listenable: podcast!.pausedTime,
        builder: (context, _) {
          final hasPausedTime = podcast?.pausedTime.value != null && podcast?.pausedTime.value != 0;
          return Row(
            children: [
              isCurrentPodcast
                  ? playerStatus(provider)
                  : audioBtn(
                      icon: Icons.play_arrow_rounded,
                      color: hasPausedTime ? GeneralColors.primaryColor : Colors.black,
                      onPressed: () async {
                        await provider.init(podcast);
                        provider.setPlayerState(CustomState.playing);
                      },
                    ),
              HSpacer(),
              Expanded(
                child: isCurrentPodcast
                    ? buildSeekBar(provider)
                    : hasPausedTime
                        ? buildProgressBar(
                            progress: Duration(seconds: podcast?.pausedTime.value ?? 0),
                            total: Duration(seconds: podcast?.audioDuration ?? 0),
                            remainingTime: (podcast?.audioDuration ?? 0) - (podcast?.pausedTime.value ?? 0),
                            isPaused: true,
                          )
                        : Text(
                            formatDuration(podcast?.audioDuration ?? 0),
                            style: GeneralTextStyle.bodyText(
                              fontSize: 14,
                            ),
                          ),
              ),
            ],
          );
        });
  }

  Widget buildSeekBar(PlayerProvider provider) {
    return StreamBuilder<SeekBarData>(
      stream: provider.streamController?.stream,
      builder: (context, snapshot) {
        final positionData = snapshot.data;

        return buildProgressBar(
          progress: positionData?.position ?? Duration.zero,
          total: positionData?.duration ?? Duration.zero,
          buffered: positionData?.bufferedPosition,
          remainingTime: ((positionData?.duration ?? Duration.zero) - (positionData?.position ?? Duration.zero)).inSeconds,
          onSeek: (value) {
            provider.audioPlayer?.seek(value, index: provider.audioPlayer?.effectiveIndices!.first);
          },
        );
      },
    );
  }

  Widget buildProgressBar({
    required Duration progress,
    required Duration total,
    bool isPaused = false,
    Duration? buffered,
    int? remainingTime,
    void Function(Duration)? onSeek,
  }) {
    return Row(
      children: [
        if (!isPaused)
          Expanded(
            child: ProgressBar(
              progress: progress,
              total: total,
              buffered: buffered,
              thumbGlowRadius: 0.0,
              thumbRadius: 0.0,
              progressBarColor: GeneralColors.primaryColor,
              baseBarColor: Color(0xFFF3F0EE),
              bufferedBarColor: Color.fromARGB(255, 209, 209, 209),
              timeLabelLocation: TimeLabelLocation.none,
              barHeight: 4,
              thumbColor: GeneralColors.primaryColor,
              onSeek: onSeek,
              timeLabelType: TimeLabelType.remainingTime,
              timeLabelTextStyle: GeneralTextStyle.bodyText(
                fontSize: 14,
                textColor: GeneralColors.grayColor,
              ),
            ),
          ),
        if (!isPaused) HSpacer(),
        if (remainingTime != null)
          Text(
            "${formatDuration(remainingTime)} үлдсэн",
            style: GeneralTextStyle.bodyText(
              fontSize: 14,
              textColor: GeneralColors.primaryColor,
            ),
          ),
      ],
    );
  }

  StreamBuilder<PlayerState> playerStatus(PlayerProvider provider) {
    return StreamBuilder<PlayerState>(
      stream: provider.audioPlayer?.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final processingState = playerState?.processingState;
        final playing = playerState?.playing;

        if (processingState == ProcessingState.loading || processingState == ProcessingState.buffering) {
          return loadingIndicator();
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
    );
  }

  Widget loadingIndicator() {
    return Container(
      decoration: BoxDecoration(color: GeneralColors.grayBGColor, borderRadius: BorderRadius.circular(30)),
      padding: const EdgeInsets.all(11),
      child: const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          color: Color.fromARGB(255, 160, 102, 102),
          strokeWidth: 2,
        ),
      ),
    );
  }
}
