import 'package:flutter/material.dart';
import 'package:goodali/connection/model/tag_response.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/shared/components/primary_button.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key, required this.tags, required this.selectedTags, required this.onFinished});
  final List<TagResponseData?> tags;
  final List<TagResponseData?> selectedTags;
  final Function(List<TagResponseData?>) onFinished;

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  List<TagResponseData?> tags = [];
  List<TagResponseData?> selectedTags = [];

  @override
  void initState() {
    super.initState();
    selectedTags = List.from(widget.selectedTags);
    tags = widget.tags;
  }

  List<TagResponseData?> setSelectedTags({TagResponseData? tag}) {
    setState(() {
      if (tag != null) {
        if (selectedTags.contains(tag)) {
          selectedTags.remove(tag);
        } else {
          selectedTags.add(tag);
        }
      }
    });

    return selectedTags;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GeneralColors.primaryBGColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                "Шүүлтүүр",
                style: GeneralTextStyle.titleText(
                  fontSize: 24,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: tags.length,
              separatorBuilder: (context, index) => VSpacer(size: 0),
              itemBuilder: (context, index) {
                final tag = tags[index];
                final isSelected = selectedTags.contains(tag);
                return CustomButton(
                  onTap: () {
                    setSelectedTags(tag: tag);
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(tag?.name ?? ""),
                        ),
                        HSpacer(size: 10),
                        Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: isSelected ? GeneralColors.primaryColor : Colors.white,
                            border: Border.all(color: isSelected ? GeneralColors.primaryColor : GeneralColors.borderColor, width: 2),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.check,
                              size: 15,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          PrimaryButton(
            title: "Шүүх",
            onPressed: () {
              Navigator.pop(context);
              widget.onFinished(selectedTags);
            },
          )
        ],
      ),
    );
  }
}
