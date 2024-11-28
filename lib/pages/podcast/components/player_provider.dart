import 'dart:async';

import 'package:flutter/material.dart';
import 'package:goodali/connection/dio_client.dart';
import 'package:goodali/connection/model/base_response.dart';
import 'package:goodali/connection/model/podcast_response.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/utils/globals.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';

class PlayerProvider extends ChangeNotifier {
  final _dioClient = DioClient();
  PodcastResponseData? data;
  AudioPlayer? audioPlayer;
  StreamSubscription? sub;
  CustomState? customState;
  BehaviorSubject<SeekBarData>? streamController;
  Stream<SeekBarData> get _seekBarDataStream => Rx.combineLatest3<Duration, Duration, Duration?, SeekBarData>(
        audioPlayer?.positionStream ?? Stream.empty(),
        audioPlayer?.bufferedPositionStream ?? Stream.empty(),
        audioPlayer?.durationStream ?? Stream.empty(),
        (position, bufferedPosition, duration) => SeekBarData(
          position: position,
          bufferedPosition: bufferedPosition,
          duration: duration ?? Duration.zero,
        ),
      );

  Future<PodcastResponseData> getPodcastById(int? id) async {
    return await _dioClient.getPodcast(id);
  }

  init(PodcastResponseData? item) async {
    if (item?.id == data?.id) {
      return;
    }
    if (item != null) {
      try {
        await setPlayerState(CustomState.disposed);
        data = item;
        audioPlayer ??= AudioPlayer();

        streamController = BehaviorSubject<SeekBarData>();
        sub = _seekBarDataStream.listen((event) {
          streamController?.sink.add(event);
        });

        if (audioPlayer != null && data?.audio != "Audio failed to upload" && data?.audio != null) {
          await audioPlayer?.setAudioSource(
              AudioSource.uri(
                Uri.parse(
                  data?.audio.toUrl() ?? "",
                ),
                tag: MediaItem(
                  id: data?.audio ?? "",
                  title: data?.title ?? "",
                  artist: "Goodali",
                  artUri: Uri.parse(data?.banner.toUrl() ?? placeholder),
                ),
              ),
              initialPosition: Duration(seconds: item.pausedTime.value ?? 0));
        }
      } catch (e) {
        print("Error setting audio source: $e");
      }
      notifyListeners();
    }
  }

  Future<void> setPlayerState(
    CustomState state,
  ) async {
    customState = state;
    try {
      switch (state) {
        case CustomState.playing:
          audioPlayer?.play();
          break;
        case CustomState.paused:
          audioPlayer?.pause();
          break;
        case CustomState.stopped:
          audioPlayer?.stop();
          break;
        case CustomState.disposed:
          if (data != null) {
            await _dioClient.podcastPausedTime(data?.id, audioPlayer?.position.inSeconds ?? 0);
          }
          data?.pausedTime.value = audioPlayer?.position.inSeconds;

          await audioPlayer?.stop();
          // await audioPlayer?.dispose();
          await sub?.cancel();
          // audioPlayer = null;
          await streamController?.close();
          streamController = null;
          data = null;
          customState = null;
          // _initiated = false;
          break;
        default:
          break;
      }
    } catch (e) {
      print("Error setting player state: $e");
    }

    notifyListeners();
  }

  Future<BaseResponse> postAlbumFeedback({
    int? lectureId,
    int? productId,
    int? albumId,
    String? text,
  }) async {
    return await _dioClient.postAlbumFeedback(lectureId: lectureId, albumId: albumId, productId: productId, text: text);
  }
}

class SeekBarData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
  SeekBarData({
    required this.duration,
    required this.bufferedPosition,
    required this.position,
  });
}

enum CustomState {
  /// initial state, stop has been called or an error occurred.
  stopped,

  /// Currently playing audio.
  playing,

  /// Pause has been called.
  paused,

  /// The audio successfully completed (reached the end).
  completed,

  /// The player has been disposed and should not be used anymore.
  disposed,
}
