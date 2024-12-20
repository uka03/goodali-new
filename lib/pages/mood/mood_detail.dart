import 'package:flutter/material.dart';
import 'package:goodali/connection/model/podcast_response.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/mood/provider/mood_provider.dart';
import 'package:goodali/pages/podcast/components/audio_controls.dart';
import 'package:goodali/pages/podcast/components/player_provider.dart';
import 'package:goodali/pages/podcast/podcast_player.dart';
import 'package:goodali/shared/components/cached_image.dart';
import 'package:goodali/shared/components/custom_app_bar.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/utils/globals.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/utils.dart';
import 'package:provider/provider.dart';

class MoodDetail extends StatefulWidget {
  const MoodDetail({super.key});
  static const String path = "mood-detail";

  @override
  State<MoodDetail> createState() => _MoodDetailState();
}

class _MoodDetailState extends State<MoodDetail> {
  late final MoodProvider _provider;
  final _pagingController = PageController(initialPage: 0);
  final page = ValueNotifier<double>(1);
  late final PlayerProvider _playerProvider;

  @override
  void initState() {
    super.initState();
    _provider = Provider.of<MoodProvider>(context, listen: false);
    _playerProvider = Provider.of<PlayerProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final id = ModalRoute.of(context)?.settings.arguments as int?;
      showLoader();
      await _provider.getMoodItems(id);
      dismissLoader();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _playerProvider.setPlayerState(CustomState.disposed);
    _provider.moodDetails = [];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: const [
            Color(0xFFE991FA),
            Color(0xFF84A3F7)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Consumer2<MoodProvider, PlayerProvider>(
        builder: (context, provider, audioProvider, _) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: CustomAppBar(
              bgColor: Colors.transparent,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(4), // Өндрийг тохируулсан
                child: ValueListenableBuilder<double>(
                  valueListenable: page,
                  builder: (context, value, _) {
                    return TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.linear,
                      tween: Tween<double>(
                        begin: 0,
                        end: value / (provider.moodDetails.isEmpty ? 1 : provider.moodDetails.length),
                      ),
                      builder: (context, value, _) => SizedBox(
                        height: 2,
                        child: LinearProgressIndicator(
                          value: value,
                          color: Colors.white,
                          backgroundColor: Colors.white.withOpacity(0.2),
                        ),
                      ),
                    );
                  },
                ),
              ),
              leading: CustomButton(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: Colors.white,
                ),
              ),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _pagingController,
                      itemCount: provider.moodDetails.length,
                      onPageChanged: (value) {
                        page.value = value.toDouble() + 1;
                        audioProvider.setPlayerState(CustomState.paused);
                      },
                      itemBuilder: (context, index) {
                        final moodDetail = provider.moodDetails[index];

                        if (moodDetail.audio?.isNotEmpty == true && moodDetail.id != audioProvider.data?.id) {
                          final data = PodcastResponseData.fromJson(moodDetail.toJson());
                          audioProvider.init(data, "mood");
                        }

                        return Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  if (moodDetail.banner?.isNotEmpty == true)
                                    Center(
                                      child: CachedImage(
                                        imageUrl: moodDetail.banner.toUrl(),
                                        width: 200,
                                        height: 200,
                                        size: "small",
                                        borderRadius: 20,
                                      ),
                                    ),
                                  VSpacer(size: 24),
                                  Text(
                                    moodDetail.title ?? "",
                                    style: GeneralTextStyle.bodyText(
                                      fontSize: 16,
                                      textColor: Colors.white,
                                    ),
                                  ),
                                  VSpacer(size: 32),
                                  Text(
                                    removeHtmlTags(
                                      moodDetail.body ?? "",
                                    ),
                                    style: GeneralTextStyle.titleText(
                                      textColor: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              if (moodDetail.audio?.isNotEmpty == true && moodDetail.audio != "Audio failed to upload")
                                StreamBuilder<SeekBarData>(
                                  stream: audioProvider.streamController?.stream,
                                  builder: (context, snapshot) {
                                    final positionData = snapshot.data;
                                    return Column(
                                      children: [
                                        CustomProgressBar(
                                          progress: positionData?.position,
                                          total: positionData?.duration,
                                          buffered: positionData?.bufferedPosition,
                                          onSeek: (value) {
                                            audioProvider.audioPlayer?.seek(value);
                                          },
                                          progressBarColor: Colors.white,
                                          baseBarColor: Colors.white.withOpacity(0.3),
                                          bufferedBarColor: Colors.white.withOpacity(0.4),
                                          textColor: Colors.white,
                                        ),
                                        VSpacer(),
                                        AudioControls(
                                          audioProvider: audioProvider,
                                          positionData: positionData,
                                        ),
                                        VSpacer(),
                                      ],
                                    );
                                  },
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: ValueListenableBuilder(
                      valueListenable: page,
                      builder: (context, value, _) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            value != 1
                                ? CustomButton(
                                    onTap: () {
                                      _pagingController.previousPage(
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.linear,
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: EdgeInsets.all(12),
                                      child: Icon(
                                        Icons.arrow_back,
                                        size: 24,
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                            CustomButton(
                              onTap: () {
                                if (value != provider.moodDetails.length) {
                                  _pagingController.nextPage(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.linear,
                                  );
                                } else {
                                  Navigator.pop(context);
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                child: Text(
                                  value != provider.moodDetails.length ? "Дараах" : "Дуусгах",
                                  style: GeneralTextStyle.titleText(),
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
