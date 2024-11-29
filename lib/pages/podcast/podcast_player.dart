import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:goodali/connection/model/podcast_response.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/podcast/components/audio_controls.dart';
import 'package:goodali/pages/podcast/components/player_provider.dart';
import 'package:goodali/shared/components/auth_text_field.dart';
import 'package:goodali/shared/components/cached_image.dart';
import 'package:goodali/shared/components/custom_app_bar.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/shared/components/primary_button.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/dailogs.dart';
import 'package:goodali/utils/globals.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/toasts.dart';
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
      await _playerProvider.init(data, arg["type"]);
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
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.85,
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
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        provider.data?.title.toString() ?? "",
                        style: GeneralTextStyle.titleText(fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButton(
                          onTap: () {
                            showModalSheet(
                              context,
                              height: MediaQuery.of(context).size.height * 0.8,
                              isScrollControlled: true,
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
                        if (provider.data?.isPaid == true)
                          Row(
                            children: [
                              HSpacer(size: 30),
                              CustomButton(
                                onTap: () {
                                  final controllerComment = TextEditingController();
                                  final formKey = GlobalKey<FormState>();
                                  showModalSheet(
                                    context,
                                    height: 300,
                                    isScrollControlled: true,
                                    child: Form(
                                      key: formKey,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 16),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Expanded(
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: AuthTextField(
                                                  controller: controllerComment,
                                                  maxLength: 1200,
                                                  extend: true,
                                                  hintText: "Сэтгэгдэл",
                                                  validator: (value) {
                                                    if (value?.isEmpty == true) {
                                                      return "Заавал бөглөх";
                                                    }
                                                    if ((value?.length ?? 0) < 5) {
                                                      return "Сэтгэгдэл доод тал нь 5 тэмдэгт байх хэрэгтэй";
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                            ),
                                            VSpacer(),
                                            PrimaryButton(
                                              onPressed: () async {
                                                if (formKey.currentState?.validate() == true) {
                                                  showLoader();
                                                  final response = await _playerProvider.postAlbumFeedback(
                                                    lectureId: provider.data?.id,
                                                    albumId: provider.data?.albumId,
                                                    text: controllerComment.text,
                                                    productId: provider.data?.productId,
                                                  );
                                                  if (response.success == true) {
                                                    if (context.mounted) {
                                                      Navigator.pop(context);
                                                      Toast.success(context, description: "Амжилттай сэтгэгдэл үлдээлээ.");
                                                    }
                                                  } else {
                                                    if (context.mounted) {
                                                      Navigator.pop(context);
                                                      Toast.error(context, description: response.message ?? response.error);
                                                    }
                                                  }
                                                  dismissLoader();
                                                }
                                              },
                                              title: "Сэтгэгдэл үлдээх",
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    Image.asset(
                                      "assets/icons/ic_chat.png",
                                      width: 30,
                                      height: 30,
                                      color: GeneralColors.grayColor,
                                    ),
                                    VSpacer.sm(),
                                    Text(
                                      "Сэтгэгдэл бичих",
                                      style: GeneralTextStyle.bodyText(),
                                    )
                                  ],
                                ),
                              ),
                            ],
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
      baseBarColor: baseBarColor ?? Color(0xFFF3F0EE),
      bufferedBarColor: bufferedBarColor ?? Color.fromARGB(255, 209, 209, 209),
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
