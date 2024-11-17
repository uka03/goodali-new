import 'package:flutter/material.dart';
import 'package:goodali/connection/model/feed_response.dart';
import 'package:goodali/extensions/list_extensions.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/auth/provider/auth_provider.dart';
import 'package:goodali/pages/feed/create_post.dart';
import 'package:goodali/pages/feed/provider/feed_provider.dart';
import 'package:goodali/shared/components/cached_image.dart';
import 'package:goodali/shared/components/custom_app_bar.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/shared/components/custom_dropdown.dart';
import 'package:goodali/shared/components/custom_text_field.dart';
import 'package:goodali/shared/general_scaffold.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/dailogs.dart';
import 'package:goodali/utils/empty_state.dart';
import 'package:goodali/utils/globals.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/toasts.dart';
import 'package:goodali/utils/utils.dart';
import 'package:provider/provider.dart';

class FeedDetail extends StatefulWidget {
  const FeedDetail({super.key, required this.item});
  final FeedResponseData item;
  static const String path = "/feed-detail";

  @override
  State<FeedDetail> createState() => _FeedDetailState();
}

class _FeedDetailState extends State<FeedDetail> {
  late final AuthProvider _authProvider;
  late final FeedProvider _feedProvider;

  @override
  void initState() {
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _feedProvider = Provider.of<FeedProvider>(context, listen: false);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      showLoader();
      await _authProvider.getMe();
      dismissLoader();
    });
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return Consumer<AuthProvider>(builder: (context, authProvider, _) {
      return GeneralScaffold(
        appBar: CustomAppBar(
          action: [
            if (authProvider.user?.id == item.userId)
              CustomMenu(
                items: const [
                  "Засах",
                  "Устгах"
                ],
                menu: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: GeneralColors.inputColor,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Icon(Icons.more_horiz),
                ),
                onChanged: (value) async {
                  switch (value?.toLowerCase()) {
                    case "засах":
                      final result = await Navigator.pushNamed(
                        context,
                        CreatePost.path,
                        arguments: item,
                      ) as Map<String, dynamic>?;
                      if (result != null) {
                        setState(() {
                          item.title = result["title"];
                          item.body = result["body"];
                          item.tags = result["tags"];
                        });
                      }
                      break;
                    case "устгах":
                      showAlertDialog(
                        context,
                        title: Text(
                          "Та устгахдаа итгэлтэй байна уу?",
                          textAlign: TextAlign.center,
                        ),
                        onSuccess: () async {
                          final response = await _feedProvider.deletePost(
                            item.id,
                          );
                          if (response == true && context.mounted) {
                            Toast.success(context, description: "Амжилттай устгагдлаа.");
                            Navigator.pop(context);
                            Navigator.pop(context, true);
                          } else {
                            if (context.mounted) {
                              Toast.error(context);
                              Navigator.pop(context);
                            }
                          }
                        },
                        onDismiss: () {
                          Navigator.pop(context);
                        },
                      );
                      break;
                    default:
                  }
                },
              ),
          ],
        ),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Row(
                      children: [
                        CachedImage(
                          imageUrl: item.avatar.toUrl(),
                          width: 40,
                          height: 40,
                          size: "xs",
                          borderRadius: 40,
                        ),
                        HSpacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.nickName ?? "Хэрэглэгч",
                              style: GeneralTextStyle.titleText(),
                            ),
                            VSpacer.xs(),
                            Text(
                              formatDate(item.createdAt),
                              style: GeneralTextStyle.bodyText(
                                textColor: GeneralColors.textGrayColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                VSpacer.xs(),
                SizedBox(
                  height: 28,
                  child: ListView.separated(
                    reverse: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: item.tags?.limitLenght(3) ?? 0,
                    separatorBuilder: (context, index) => HSpacer(),
                    itemBuilder: (context, index) {
                      final tag = item.tags?[index];
                      return Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: GeneralColors.primaryColor,
                                )),
                            child: Text(
                              tag?.name ?? "",
                              style: GeneralTextStyle.bodyText(
                                textColor: GeneralColors.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Text(
                  item.title ?? "",
                  style: GeneralTextStyle.titleText(),
                ),
                VSpacer(),
                Text(
                  item.body ?? "",
                  textAlign: TextAlign.center,
                ),
                VSpacer(size: 30),
                Row(
                  children: [
                    ValueListenableBuilder<bool?>(
                        valueListenable: item.isLike,
                        builder: (context, value, _) {
                          return actionBtn(
                            context,
                            count: item.likes,
                            iconPath: "assets/icons/ic_heart${value == true ? "_active" : ""}.png",
                            onPressed: () async {
                              if (value == true) {
                                item.likes = (item.likes ?? 1) - 1;
                                item.isLike.value = false;
                                _feedProvider.postDislike(item.id);
                              } else {
                                item.likes = (item.likes ?? 0) + 1;
                                item.isLike.value = true;
                                _feedProvider.postLike(item.id);
                              }
                            },
                          );
                        }),
                    HSpacer(),
                    actionBtn(
                      context,
                      count: item.replys?.length,
                      iconPath: "assets/icons/ic_chat.png",
                      onPressed: () {},
                    ),
                  ],
                ),
                VSpacer(),
                Row(
                  children: [
                    CachedImage(
                      imageUrl: authProvider.user?.avatar.toUrl() ?? "",
                      width: 40,
                      height: 40,
                      borderRadius: 40,
                    ),
                    HSpacer(),
                    Expanded(
                      child: CustomTextField(
                        controller: TextEditingController(),
                        withIcon: false,
                        readonly: true,
                        hintText: "Сэтгэгдэл бичих",
                        onTap: () {
                          showReplyModal();
                        },
                      ),
                    )
                  ],
                ),
                Divider(),
                if (item.replys?.isNotEmpty == true)
                  ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: item.replys?.length ?? 0,
                    separatorBuilder: (context, index) => Divider(),
                    itemBuilder: (context, index) {
                      final reply = item.replys?[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CachedImage(
                              imageUrl: reply?.avatar.toUrl() ?? "",
                              width: 40,
                              height: 40,
                              borderRadius: 40,
                            ),
                            HSpacer(),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              reply?.nickName ?? "Хэрэглэгч",
                                              style: GeneralTextStyle.titleText(),
                                            ),
                                            Text(
                                              formatDate(reply?.createdAt),
                                              style: GeneralTextStyle.bodyText(
                                                textColor: GeneralColors.textGrayColor,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      if (authProvider.user?.id == reply?.userId)
                                        CustomButton(
                                          onTap: () {
                                            showAlertDialog(
                                              context,
                                              title: Text(
                                                "Та устгахдаа итгэлтэй байна уу?",
                                                textAlign: TextAlign.center,
                                              ),
                                              onSuccess: () async {
                                                final response = await _feedProvider.deleteReply(
                                                  reply?.id,
                                                  item.id,
                                                );
                                                if (response == true && context.mounted) {
                                                  item.replys?.removeAt(index);
                                                  setState(() {});
                                                  Toast.success(context, description: "Амжилттай устгагдлаа.");
                                                  Navigator.pop(context);
                                                } else {
                                                  if (context.mounted) {
                                                    Toast.error(context);
                                                    Navigator.pop(context);
                                                  }
                                                }
                                              },
                                              onDismiss: () {
                                                Navigator.pop(context);
                                              },
                                            );
                                          },
                                          child: Icon(
                                            Icons.delete_outline,
                                            color: GeneralColors.primaryColor,
                                          ),
                                        )
                                    ],
                                  ),
                                  VSpacer(),
                                  Text(
                                    reply?.body ?? "",
                                    style: GeneralTextStyle.bodyText(),
                                  ),
                                  VSpacer(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                else
                  EmptyState(
                    title: "Сэтгэгдэл байхгүй байна",
                  )
              ],
            ),
          ],
        ),
      );
    });
  }

  showReplyModal() {
    final commtentController = TextEditingController();
    final formkey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Form(
          key: formkey,
          child: Container(
            constraints: BoxConstraints(maxHeight: 300),
            margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              decoration: BoxDecoration(color: GeneralColors.primaryBGColor),
              // height: 80,
              padding: EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      autofocus: true,
                      validator: (value) {
                        if ((value?.length ?? 0) < 5) {
                          return "Сэтгэгдэл хэсэг доод тал нь 5н тэмдэгт байх хэрэгтэй";
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        if (formkey.currentState?.validate() == true) {
                          postReply(commtentController.text);
                        }
                      },
                      controller: commtentController,
                      cursorColor: GeneralColors.primaryColor,
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onChanged: (value) {},
                      expands: false,
                      decoration: const InputDecoration(
                        filled: false,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        border: InputBorder.none,
                        hintText: 'Сэтгэгдэл бичих...',
                        hintStyle: TextStyle(color: GeneralColors.grayColor),
                      ),
                    ),
                  ),
                  CustomButton(
                    child: const Icon(Icons.send, color: GeneralColors.primaryColor),
                    onTap: () {
                      if (formkey.currentState?.validate() == true) {
                        postReply(commtentController.text);
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  postReply(String text) async {
    final response = await _feedProvider.postReply(
      widget.item.id,
      text,
    );
    if (response != null && mounted) {
      setState(() {
        widget.item.replys?.add(
          ReplyResponseData(
            body: response.body,
            nickName: _authProvider.user?.nickname,
            userId: response.userId,
            avatar: _authProvider.user?.avatar,
            id: response.id,
            createdAt: response.createdAt,
          ),
        );
        widget.item.replyCount.value = (widget.item.replyCount.value ?? 0) + 1;
      });

      Toast.success(context, description: "Амжилтай");
      Navigator.pop(context);
    }
  }

  Row actionBtn(
    BuildContext context, {
    int? count,
    required String iconPath,
    required Function() onPressed,
  }) {
    return Row(
      children: [
        CustomButton(
          onTap: onPressed,
          child: Image.asset(
            iconPath,
            width: 24,
            height: 24,
            color: GeneralColors.primaryColor,
          ),
        ),
        HSpacer(size: 10),
        Text(
          (count ?? 0).toString(),
          style: GeneralTextStyle.bodyText(
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
