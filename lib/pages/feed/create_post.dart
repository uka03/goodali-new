import 'package:flutter/material.dart';
import 'package:goodali/connection/model/feed_response.dart';
import 'package:goodali/connection/model/tag_response.dart';
import 'package:goodali/pages/auth/provider/auth_provider.dart';
import 'package:goodali/pages/feed/provider/feed_provider.dart';
import 'package:goodali/shared/components/auth_text_field.dart';
import 'package:goodali/shared/components/custom_app_bar.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/shared/components/primary_button.dart';
import 'package:goodali/shared/general_scaffold.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/dailogs.dart';
import 'package:goodali/utils/globals.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/toasts.dart';
import 'package:provider/provider.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  static const String path = "/create-post";

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  late final FeedProvider _feedProvider;
  late final AuthProvider _authProvider;
  FeedResponseData? data;

  @override
  void initState() {
    super.initState();
    _feedProvider = Provider.of<FeedProvider>(context, listen: false);
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final item = ModalRoute.of(context)?.settings.arguments as FeedResponseData?;
      _titleController.text = item?.title ?? "";
      _contentController.text = item?.body ?? "";
      setState(() {
        data = item;
      });
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  onTagModal({required List<TagResponseData?> tag}) {
    if (_formKey.currentState?.validate() == false) {
      return;
    }
    List<TagResponseData?> selectedTags = data != null ? data?.tags ?? [] : [];

    showModalSheet(
      context,
      withExpanded: false,
      isScrollControlled: true,
      child: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Холбогдох сэдэв",
                  style: GeneralTextStyle.titleText(fontSize: 24),
                ),
              ),
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.start,
                spacing: 10,
                runSpacing: 10,
                children: tag.map((e) {
                  final isSelected = selectedTags.where((item) => item?.id == e?.id).isNotEmpty;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedTags.remove(e);
                        } else {
                          if (selectedTags.length >= 3) {
                            selectedTags.removeLast();
                          }
                          selectedTags.add(e);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected ? GeneralColors.primaryColor : GeneralColors.borderColor,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        color: isSelected ? GeneralColors.primaryColor : null,
                      ),
                      child: Text(
                        e?.name ?? "",
                        style: GeneralTextStyle.titleText(
                          fontSize: 16,
                          textColor: isSelected ? Colors.white : GeneralColors.grayColor,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              VSpacer(),
              PrimaryButton(
                title: data != null ? "Засах" : "Сонгох",
                onPressed: () async {
                  if (data != null) {
                    showLoader();
                    final respone = await _feedProvider.updatePost(
                      title: _titleController.text,
                      body: _contentController.text,
                      id: data?.id,
                      tags: selectedTags.map((e) => e?.id).toList(),
                    );
                    dismissLoader();
                    if (respone.success == true) {
                      if (context.mounted) {
                        Toast.success(
                          context,
                          description: "Амжилттай засагдалаа нийтлэгдлээ.",
                        );
                        Navigator.pop(context);
                        Navigator.pop(context, {
                          "title": _titleController.text,
                          "body": _contentController.text,
                          "tags": selectedTags,
                        });
                      }
                    } else {
                      if (context.mounted) {
                        Toast.error(context, description: "Уучилаарай. Пост засах явцад алдаа гарлаа.");
                      }
                    }
                  } else {
                    if (selectedTags.isEmpty) {
                      Toast.error(context, description: "Холбогдох сэдэв сонгоно уу?");
                    } else {
                      Navigator.pop(context);
                      onWherePostModal(selectedTags: selectedTags);
                    }
                  }
                },
              )
            ],
          );
        },
      ),
    );
  }

  onWherePostModal({required List<TagResponseData?> selectedTags}) async {
    TypeItem? selectedItem;
    final user = await _authProvider.getMe();
    final hasTraining = user?.hasTraining ?? false;
    if (!mounted) return;
    showModalSheet(
      context,
      withExpanded: false,
      child: StatefulBuilder(builder: (context, setState) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Хаана постлох вэ?",
                style: GeneralTextStyle.titleText(fontSize: 24),
              ),
            ),
            ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: fireTypes.map(
                (e) {
                  if (hasTraining == false && e.index == 1) {
                    return SizedBox();
                  }

                  return CustomButton(
                    onTap: () {
                      setState(() {
                        selectedItem = e;
                      });
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(e.title),
                          ),
                          HSpacer(size: 10),
                          Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: selectedItem?.index == e.index ? GeneralColors.primaryColor : Colors.white,
                              border: Border.all(color: selectedItem?.index == e.index ? GeneralColors.primaryColor : GeneralColors.borderColor, width: 2),
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
              ).toList(),
            ),
            VSpacer(),
            PrimaryButton(
              title: "Сонгох",
              onPressed: () async {
                if (selectedItem == null) {
                  Toast.error(context, description: "Хаана постлох вэ?");
                } else {
                  showLoader();
                  final respone = await _feedProvider.createPost(
                    title: _titleController.text,
                    body: _contentController.text,
                    postType: selectedItem?.index,
                    tags: selectedTags.map((e) => e?.id).toList(),
                  );
                  dismissLoader();
                  if (respone.success == true) {
                    if (context.mounted) {
                      Toast.success(context, description: "Амжилттай пост нийтлэгдлээ.");
                      Navigator.pop(context);
                      Navigator.pop(context, true);
                    }
                  } else {
                    if (context.mounted) {
                      Toast.error(context, description: "Уучилаарай. Пост нийтлэх явцад алдаа гарлаа.");
                    }
                  }
                }
              },
            )
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GeneralScaffold(
      appBar: CustomAppBar(
        title: const Text("Пост нэмэх"),
      ),
      bottomBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Та өдөрт 2 удаа пост оруулах эрхтэй юм шүү.",
          ),
          Container(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 32),
            color: Colors.transparent,
            child: PrimaryButton(
              onPressed: () {
                onTagModal(tag: _feedProvider.tags);
              },
              title: data != null ? "Засах" : "Нийтлэх",
            ),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                "Та юу бодож байна?",
                style: GeneralTextStyle.titleText(fontSize: 20),
              ),
              VSpacer(),
              AuthTextField(
                controller: _titleController,
                hintText: "Гарчиг",
                keyboardType: TextInputType.text,
                maxLength: 30,
                validator: (value) {
                  if (value?.isEmpty ?? false) {
                    return "Гарчигийг оруулна уу";
                  }
                  if ((value?.length ?? 0) < 2) {
                    return "Гарчиг доод тал нь 2 тэмдэгт байх хэрэгтэй";
                  }
                  return null;
                },
              ),
              AuthTextField(
                  controller: _contentController,
                  hintText: "Үндсэн хэсэг",
                  keyboardType: TextInputType.text,
                  maxLength: 1200,
                  extend: true,
                  validator: (value) {
                    if (value?.isEmpty ?? false) {
                      return "Үндсэн хэсэгийг оруулна уу";
                    }
                    if ((value?.length ?? 0) < 2) {
                      return "Үндсэн хэсэг доод тал нь 5н тэмдэгт байх хэрэгтэй";
                    }
                    return null;
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
