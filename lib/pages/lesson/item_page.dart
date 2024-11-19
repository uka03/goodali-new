import 'package:flutter/material.dart';
import 'package:goodali/connection/model/lesson_response.dart';
import 'package:goodali/connection/model/purchase_response.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/lesson/lesson_page.dart';
import 'package:goodali/pages/training/provider/training_provider.dart';
import 'package:goodali/shared/components/cached_image.dart';
import 'package:goodali/shared/components/custom_app_bar.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/shared/general_scaffold.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/globals.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:provider/provider.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({super.key});

  static const String path = "/item-page";

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  late final TrainingProvider _provider;
  @override
  void initState() {
    super.initState();
    _provider = Provider.of<TrainingProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final item = ModalRoute.of(context)?.settings.arguments as PurchaseTrainingData?;
      if (item != null) {
        showLoader();
        await _provider.getTraingingItem(item);
        dismissLoader();
      }
    });
  }

  @override
  void dispose() {
    _provider.items = [];
    _provider.trainingData = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GeneralScaffold(
      appBar: const CustomAppBar(),
      child: Consumer<TrainingProvider>(
        builder: (context, provider, _) {
          final items = provider.items;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                provider.trainingData?.name ?? "",
                style: GeneralTextStyle.titleText(fontSize: 32),
              ),
              const VSpacer(),
              Expanded(
                child: RefreshIndicator(
                  color: GeneralColors.primaryColor,
                  onRefresh: () async {
                    final provider = context.read<TrainingProvider>();
                    showLoader();
                    await provider.getTraingingItem(provider.trainingData);
                    dismissLoader();
                  },
                  child: ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (context, index) => const VSpacer(),
                    itemBuilder: (context, index) {
                      return TrainingItemTile(
                        item: items[index],
                        onClick: () async {
                          await Navigator.pushNamed(
                            context,
                            LessonPage.path,
                            arguments: items[index],
                          );
                          if (context.mounted) {
                            final provider = context.read<TrainingProvider>();
                            await provider.getTraingingItem(provider.trainingData);
                          }
                        },
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

class TrainingItemTile extends StatelessWidget {
  final LessonResponseData item;
  final Function() onClick;

  const TrainingItemTile({super.key, required this.item, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onTap: onClick,
      child: Row(
        children: [
          CachedImage(
            imageUrl: item.banner.toUrl(),
            height: 48,
            borderRadius: 8,
            size: "xs",
            width: 48,
          ),
          const HSpacer(),
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
          TaskStatusIcon(isComplete: item.allTask == item.done),
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
