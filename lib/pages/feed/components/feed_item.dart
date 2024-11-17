import 'package:flutter/material.dart';
import 'package:goodali/connection/model/feed_response.dart';
import 'package:goodali/extensions/list_extensions.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/auth/provider/auth_provider.dart';
import 'package:goodali/pages/feed/components/tag_item.dart';
import 'package:goodali/pages/feed/feed_detail.dart';
import 'package:goodali/pages/feed/provider/feed_provider.dart';
import 'package:goodali/shared/components/cached_image.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/shared/components/custom_dropdown.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/dailogs.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/toasts.dart';
import 'package:goodali/utils/utils.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class PostItem extends StatelessWidget {
  const PostItem({
    super.key,
    required this.item,
    required this.provider,
    required this.authProvider,
    required this.pagingController,
    required this.onEdit,
  });
  final FeedResponseData item;
  final FeedProvider provider;
  final AuthProvider authProvider;
  final PagingController<int, FeedResponseData> pagingController;
  final Function() onEdit;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onTap: () async {
        final result = await Navigator.push<bool?>(
          context,
          MaterialPageRoute(
            builder: (context) => FeedDetail(item: item),
          ),
        );
        if (result == true) {
          pagingController.refresh();
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedImage(
                  imageUrl: item.avatar.toUrl(),
                  width: 30,
                  height: 30,
                  size: "xs",
                  borderRadius: 40,
                ),
                HSpacer(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.nickName ?? "Хэрэглэгч",
                        style: GeneralTextStyle.bodyText(textColor: GeneralColors.textGrayColor, fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        formatDate(item.createdAt),
                        style: GeneralTextStyle.bodyText(textColor: GeneralColors.textGrayColor, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                if (authProvider.user?.id == item.userId)
                  CustomMenu(
                    items: const [
                      "Засах",
                      "Устгах"
                    ],
                    menu: Icon(Icons.more_horiz),
                    onChanged: (value) {
                      switch (value?.toLowerCase()) {
                        case "засах":
                          onEdit();
                          break;
                        case "устгах":
                          showAlertDialog(
                            context,
                            title: Text(
                              "Та устгахдаа итгэлтэй байна уу?",
                              textAlign: TextAlign.center,
                            ),
                            onSuccess: () async {
                              final response = await provider.deletePost(
                                item.id,
                              );
                              if (response == true && context.mounted) {
                                pagingController.refresh();

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
                          break;
                        default:
                      }
                    },
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
                  return TagItem(tag: tag);
                },
              ),
            ),
            Text(
              item.title ?? "",
              style: GeneralTextStyle.titleText(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            VSpacer(),
            Text(
              item.body ?? "",
              textAlign: TextAlign.center,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
            VSpacer(),
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
                            provider.postDislike(item.id);
                          } else {
                            item.likes = (item.likes ?? 0) + 1;
                            item.isLike.value = true;
                            provider.postLike(item.id);
                          }
                        },
                      );
                    }),
                HSpacer(),
                ValueListenableBuilder<int?>(
                    valueListenable: item.replyCount,
                    builder: (context, value, _) {
                      return actionBtn(
                        context,
                        count: item.replys?.length,
                        iconPath: "assets/icons/ic_chat.png",
                        onPressed: () {},
                      );
                    }),
              ],
            )
          ],
        ),
      ),
    );
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
