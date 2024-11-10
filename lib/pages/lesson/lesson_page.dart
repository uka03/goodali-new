import 'package:flutter/material.dart';
import 'package:goodali/connection/model/lesson_response.dart';
import 'package:goodali/pages/lesson/task_page.dart';
import 'package:goodali/pages/training/provider/training_provider.dart';
import 'package:goodali/shared/components/custom_app_bar.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/shared/general_scaffold.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/dailogs.dart';
import 'package:goodali/utils/globals.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/utils.dart';
import 'package:provider/provider.dart';

class LessonPage extends StatefulWidget {
  const LessonPage({super.key});

  static const String path = "/lesson-page";

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  late final TrainingProvider _provider;
  @override
  void initState() {
    super.initState();
    _provider = Provider.of(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final item = ModalRoute.of(context)?.settings.arguments as LessonResponseData?;
      if (item != null) {
        showLoader();
        await _provider.getTraingingLesson(item);
        dismissLoader();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _provider.lessons = [];
    _provider.item = null;
  }

  @override
  Widget build(BuildContext context) {
    return GeneralScaffold(
      appBar: const CustomAppBar(),
      child: Consumer<TrainingProvider>(
        builder: (context, provider, _) {
          final item = provider.item;
          final items = provider.lessons;

          if (item == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name ?? "",
                style: GeneralTextStyle.titleText(fontSize: 32),
                maxLines: 2,
              ),
              const VSpacer(),
              Expanded(
                child: RefreshIndicator(
                  color: GeneralColors.primaryColor,
                  onRefresh: () async {
                    showLoader();
                    await context.read<TrainingProvider>().getTraingingLesson(item);
                    dismissLoader();
                  },
                  child: ListView.separated(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return LessonItem(
                        item: item,
                        index: index,
                        onClick: () async {
                          if (item.locked == true) {
                            final date = formatDate(item.openDate);
                            showAlertDialog(
                              context,
                              onSuccess: () {},
                              onDismiss: () {},
                              title: Text(
                                "Анхааруулга",
                                style: GeneralTextStyle.titleText(fontSize: 24),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Уг хичээл түгжээтэй байна.",
                                    style: GeneralTextStyle.titleText(),
                                  ),
                                  Divider(),
                                  Text.rich(
                                    TextSpan(
                                      text: "Нээгдэх хугацаа: ",
                                      children: [
                                        TextSpan(
                                          text: date,
                                          style: GeneralTextStyle.titleText(),
                                        )
                                      ],
                                      style: GeneralTextStyle.titleText(fontSize: 14),
                                    ),
                                  )
                                ],
                              ),
                              actions: [
                                CustomButton(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          padding: EdgeInsets.symmetric(vertical: 10),
                                          child: Center(
                                            child: Text(
                                              "Буцах",
                                              style: GeneralTextStyle.titleText(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            );
                          } else {
                            Navigator.pushNamed(context, TaskPage.path, arguments: item);
                          }
                        },
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) => const VSpacer(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class LessonItem extends StatelessWidget {
  final LessonResponseData item;
  final int index;
  final Function() onClick;

  const LessonItem({super.key, required this.item, required this.index, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onTap: onClick,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${index + 1}.${item.name ?? ""}",
                  style: GeneralTextStyle.titleText(),
                ),
                VSpacer.sm(),
                Text("${item.done ?? 0}/${item.allTask ?? 0} даалгавар"),
              ],
            ),
          ),
          const HSpacer(),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: item.allTask == item.done ? GeneralColors.successColor : Colors.white,
              border: Border.all(
                color: item.allTask == item.done ? GeneralColors.successColor : GeneralColors.borderColor,
                width: 2,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.check,
                size: 15,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
