import 'package:flutter/material.dart';
import 'package:goodali/connection/model/lesson_response.dart';
import 'package:goodali/pages/lesson/task_detail.dart';
import 'package:goodali/pages/training/provider/training_provider.dart';
import 'package:goodali/shared/components/custom_app_bar.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/shared/general_scaffold.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:provider/provider.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  static const String path = "/task-page";

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  late final TrainingProvider _provider;
  @override
  void initState() {
    super.initState();
    _provider = Provider.of(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final item = ModalRoute.of(context)?.settings.arguments as LessonResponseData?;
      if (item != null) {
        _provider.getTraingingTask(item);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _provider.tasks = [];
    _provider.lesson = null;
  }

  @override
  Widget build(BuildContext context) {
    return GeneralScaffold(
      appBar: const CustomAppBar(),
      child: Consumer<TrainingProvider>(
        builder: (context, provider, _) {
          final items = provider.tasks;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                provider.lesson?.name ?? "",
                style: GeneralTextStyle.titleText(fontSize: 32),
              ),
              const VSpacer(),
              Expanded(
                child: RefreshIndicator(
                  color: GeneralColors.primaryColor,
                  onRefresh: () async {
                    final provider = context.read<TrainingProvider>();
                    await provider.getTraingingTask(provider.lesson);
                  },
                  child: ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (context, index) => const VSpacer(),
                    itemBuilder: (context, index) {
                      return TaskItem(
                        item: items[index],
                        index: index,
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

class TaskItem extends StatelessWidget {
  final TaskResponseData item;
  final int index;

  const TaskItem({super.key, required this.item, required this.index});

  String getTask(int? type) {
    switch (type) {
      case 0:
        return "Унших материал";
      case 1:
        return "Бичих";
      case 2:
        return "Сонсох";
      case 3:
        return "Хийх";
      case 4:
        return "Үзэх";
      case 5:
        return "Мэдрэх";
      case 6:
        return "Судлах";
      default:
        return "Unknown";
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onTap: () {
        Navigator.pushNamed(context, TaskDetail.path, arguments: index);
      },
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${index + 1}.${getTask(item.type)}",
                  style: GeneralTextStyle.titleText(),
                ),
                VSpacer.sm(),
                Text(item.isAnswered == 1 ? "Дууссан" : "Хийгээгүй"),
              ],
            ),
          ),
          const HSpacer(),
          TaskStatusIcon(isComplete: item.isAnswered == 1),
        ],
      ),
    );
  }
}

class TaskStatusIcon extends StatelessWidget {
  final bool isComplete;

  const TaskStatusIcon({super.key, required this.isComplete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isComplete ? GeneralColors.successColor : Colors.white,
        border: Border.all(
          color: isComplete ? GeneralColors.successColor : GeneralColors.borderColor,
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
    );
  }
}
