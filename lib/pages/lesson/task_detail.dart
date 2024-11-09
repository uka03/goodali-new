import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:goodali/connection/model/lesson_response.dart';
import 'package:goodali/pages/training/provider/training_provider.dart';
import 'package:goodali/shared/components/auth_text_field.dart';
import 'package:goodali/shared/components/cached_image.dart';
import 'package:goodali/shared/components/custom_app_bar.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/shared/components/primary_button.dart';
import 'package:goodali/shared/general_scaffold.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/toasts.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TaskDetail extends StatefulWidget {
  const TaskDetail({super.key});

  static const String path = "/task-detail";

  @override
  State<TaskDetail> createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  late final PageController controller;
  ValueNotifier<int> selectedPage = ValueNotifier(0);
  late final TrainingProvider _provider;

  @override
  void initState() {
    super.initState();
    controller = PageController();
    _provider = Provider.of(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final page = ModalRoute.of(context)?.settings.arguments as int?;
      if (page != null) {
        controller.jumpToPage(page);
      }
    });
    controller.addListener(() {
      if (controller.page == controller.page?.toInt()) {
        selectedPage.value = controller.page?.toInt() ?? 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TrainingProvider>(
      builder: (context, provider, _) {
        final items = provider.tasks;
        return GeneralScaffold(
          appBar: CustomAppBar(),
          bottomBar: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: ListenableBuilder(
                builder: (context, value) {
                  return Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.all(12),
                        child: Text("${selectedPage.value + 1}/${items.length}"),
                      ),
                      HSpacer(),
                      Expanded(
                        child: PrimaryButton(
                          title: items.length == selectedPage.value + 1 ? "Дуусгах" : "Дараах",
                          onPressed: () async {
                            final task = items[selectedPage.value];
                            if (task.isAnswer == 1) {
                              if (task.answerData?.isEmpty == true) {
                                Toast.error(context, description: 'Та хариултаа бичих хэрэгтэй');
                                return;
                              }
                            }
                            if (task.type == 4 && task.videoUrl?.isNotEmpty == true) {
                              if (task.isAnswered == 0) {
                                Toast.error(context, description: "Та видеог дуустал нь үзсэн дараагүй байна.");
                                return;
                              }
                            }
                            await _provider.setAnswer(task.id, task.answerData);

                            if (items.length == selectedPage.value + 1) {
                              await _provider.getTraingingTask(_provider.lesson);
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            } else {
                              controller.nextPage(
                                duration: Duration(milliseconds: 200),
                                curve: Curves.linear,
                              );
                            }
                          },
                        ),
                      )
                    ],
                  );
                },
                listenable: selectedPage,
              ),
            ),
          ),
          child: PageView.builder(
            controller: controller,
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              final item = items[index];
              YoutubePlayerController? controllerYT;
              TextEditingController controllerText = TextEditingController(text: item.answerData);
              if (item.type == 4 && item.videoUrl?.isNotEmpty == true) {
                controllerYT = YoutubePlayerController(
                  initialVideoId: item.videoUrl ?? "",
                  flags: YoutubePlayerFlags(
                    showLiveFullscreenButton: false,
                  ),
                );
              }

              return TextTask(
                item: item,
                controllerYT: item.type == 4 ? controllerYT : null,
                controller: controllerText,
                onEnd: () {
                  setState(() {
                    item.isAnswered = item.isAnswered == 1 ? 0 : 1;
                  });
                },
              );
            },
          ),
        );
      },
    );
  }
}

class TextTask extends StatelessWidget {
  const TextTask({
    super.key,
    required this.item,
    this.controllerYT,
    required this.controller,
    required this.onEnd,
  });
  final TaskResponseData item;
  final YoutubePlayerController? controllerYT;
  final TextEditingController controller;
  final Function() onEnd;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (controllerYT != null)
            Column(
              children: [
                YoutubePlayer(
                  controller: controllerYT!,
                  bottomActions: const [],
                ),
                VSpacer(),
                CustomButton(
                  onTap: onEnd,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: item.isAnswered == 1 ? GeneralColors.successColor : GeneralColors.borderColor, width: 2),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: item.isAnswered == 1 ? GeneralColors.successColor : Colors.white,
                            border: Border.all(color: item.isAnswered == 1 ? GeneralColors.successColor : GeneralColors.borderColor, width: 2),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.check,
                              size: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        HSpacer(),
                        Expanded(
                          child: Text(
                            "Видеог дуустал нь үзсэн.",
                            style: GeneralTextStyle.titleText(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          VSpacer(),
          if (item.banner?.isNotEmpty == true)
            CachedImage(
              imageUrl: item.banner ?? "",
              width: 250,
              height: 250,
              borderRadius: 12,
            ),
          HtmlWidget(item.body ?? ""),
          VSpacer(),
          if (item.question?.isNotEmpty == true)
            Text(
              item.question ?? "",
              style: GeneralTextStyle.titleText(),
            ),
          if (item.isAnswer == 1)
            AuthTextField(
              extend: true,
              controller: controller,
              hintText: "Хариулт",
              onClear: () {
                item.answerData = "";
              },
              onChanged: (value) {
                item.answerData = value;
              },
            ),
          Container(),
        ],
      ),
    );
  }
}
