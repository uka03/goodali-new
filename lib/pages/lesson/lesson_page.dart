import 'package:flutter/material.dart';
import 'package:goodali/connection/model/lesson_response.dart';
import 'package:goodali/pages/training/provider/training_provider.dart';
import 'package:goodali/shared/components/custom_app_bar.dart';
import 'package:goodali/shared/general_scaffold.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:provider/provider.dart';

class LessonPage extends StatefulWidget {
  const LessonPage({super.key});

  static const String path = "/lesson-page";

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final item = ModalRoute.of(context)?.settings.arguments as LessonResponseData?;
      if (item != null) {
        context.read<TrainingProvider>().getTraingingLesson(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GeneralScaffold(
      appBar: const CustomAppBar(),
      child: Selector<TrainingProvider, LessonResponseData?>(
        selector: (context, provider) => provider.item,
        builder: (context, lesson, _) {
          if (lesson == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lesson.name ?? "",
                style: GeneralTextStyle.titleText(fontSize: 32),
                maxLines: 2,
              ),
              const VSpacer(),
              Expanded(
                child: RefreshIndicator(
                  color: GeneralColors.primaryColor,
                  onRefresh: () async {
                    await context.read<TrainingProvider>().getTraingingLesson(lesson);
                  },
                  child: Selector<TrainingProvider, List<LessonResponseData>>(
                    selector: (context, provider) => provider.lessons,
                    builder: (context, lessons, _) {
                      return ListView.separated(
                        itemCount: lessons.length,
                        itemBuilder: (context, index) {
                          final item = lessons[index];
                          return LessonItem(item: item);
                        },
                        separatorBuilder: (BuildContext context, int index) => const VSpacer(),
                      );
                    },
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

  const LessonItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name ?? "",
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
    );
  }
}
