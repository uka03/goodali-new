import 'package:flutter/material.dart';
import 'package:goodali/pages/podcast/components/player_provider.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:just_audio/just_audio.dart';

class AudioControls extends StatelessWidget {
  const AudioControls({
    super.key,
    required this.audioProvider,
    required this.positionData,
  });

  final PlayerProvider audioProvider;
  final SeekBarData? positionData;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomButton(
          onTap: () {
            if (positionData?.duration != null && positionData?.position != null) {
              if (positionData!.position > Duration(seconds: 15)) {
                audioProvider.audioPlayer?.seek(
                  positionData!.position - Duration(seconds: 15),
                );
              }
            }
          },
          child: Container(
            decoration: BoxDecoration(color: GeneralColors.inputColor, borderRadius: BorderRadius.circular(50)),
            padding: EdgeInsets.all(15),
            child: Image.asset(
              "assets/icons/ic_replay_15.png",
              width: 30,
              height: 30,
              color: Colors.black,
              fit: BoxFit.cover,
            ),
          ),
        ),
        HSpacer(size: 20),
        StreamBuilder<PlayerState>(
          stream: audioProvider.audioPlayer?.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading || processingState == ProcessingState.buffering) {
              return Container(
                  decoration: BoxDecoration(color: GeneralColors.primaryColor, borderRadius: BorderRadius.circular(50)),
                  padding: EdgeInsets.all(22),
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ));
            } else if (playing != true) {
              return audioBtn(
                icon: Icons.play_arrow_rounded,
                onPressed: () {
                  audioProvider.setPlayerState(CustomState.playing);
                },
              );
            } else if (processingState != ProcessingState.completed) {
              return audioBtn(
                icon: Icons.pause_rounded,
                onPressed: () {
                  audioProvider.setPlayerState(CustomState.paused);
                },
              );
            } else {
              audioProvider.setPlayerState(CustomState.completed);
              return audioBtn(
                icon: Icons.replay,
                onPressed: () {
                  audioProvider.setPlayerState(CustomState.playing);
                  audioProvider.audioPlayer?.seek(
                    Duration.zero,
                    index: audioProvider.audioPlayer?.effectiveIndices!.first,
                  );
                },
              );
            }
          },
        ),
        HSpacer(size: 20),
        CustomButton(
          onTap: () {
            if (positionData?.duration != null && positionData?.position != null) {
              if (positionData!.duration - Duration(seconds: 15) > positionData!.position) {
                audioProvider.audioPlayer?.seek(
                  positionData!.position + Duration(seconds: 15),
                );
              }
            }
          },
          child: Container(
            decoration: BoxDecoration(color: GeneralColors.inputColor, borderRadius: BorderRadius.circular(50)),
            padding: EdgeInsets.all(15),
            child: Image.asset(
              "assets/icons/ic_forward_15.png",
              width: 30,
              height: 30,
              fit: BoxFit.cover,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  CustomButton audioBtn({required IconData icon, required Function() onPressed}) {
    return CustomButton(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(color: GeneralColors.primaryColor, borderRadius: BorderRadius.circular(50)),
        padding: EdgeInsets.all(20),
        child: Icon(
          icon,
          size: 40,
          color: Colors.white,
        ),
      ),
    );
  }
}
