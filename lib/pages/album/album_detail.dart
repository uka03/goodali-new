import 'package:flutter/material.dart';
import 'package:goodali/connection/model/feedback_response.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/album/provider/album_provider.dart';
import 'package:goodali/pages/album/reply_page.dart';
import 'package:goodali/pages/auth/provider/auth_provider.dart';
import 'package:goodali/pages/cart/cart_page.dart';
import 'package:goodali/pages/cart/provider/cart_provider.dart';
import 'package:goodali/pages/home/components/home_title.dart';
import 'package:goodali/pages/podcast/components/podcast_item.dart';
import 'package:goodali/shared/components/action_item.dart';
import 'package:goodali/shared/components/cached_image.dart';
import 'package:goodali/shared/components/custom_app_bar.dart';
import 'package:goodali/shared/components/custom_read_more.dart';
import 'package:goodali/shared/components/primary_button.dart';
import 'package:goodali/shared/general_scaffold.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/empty_state.dart';
import 'package:goodali/utils/globals.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/toasts.dart';
import 'package:goodali/utils/utils.dart';
import 'package:provider/provider.dart';

class AlbumDetail extends StatefulWidget {
  const AlbumDetail({super.key});

  static const String path = "/album-detail";

  @override
  State<AlbumDetail> createState() => _AlbumDetailState();
}

class _AlbumDetailState extends State<AlbumDetail> {
  late final AlbumProvider provider;
  late final AuthProvider authProvider;
  // late final
  @override
  void initState() {
    super.initState();
    provider = Provider.of<AlbumProvider>(context, listen: false);
    authProvider = Provider.of<AuthProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      showLoader();
      final id = ModalRoute.of(context)?.settings.arguments as int?;
      await provider.getAlbum(id);
      await authProvider.getMe();
      await provider.getReplies(id, "lecture");
      dismissLoader();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CartProvider, AlbumProvider>(
      builder: (context, cartProvider, albumProvider, _) {
        final albumData = albumProvider.albumDetail;
        final album = albumProvider.albumDetail?.album;
        final isCarted = cartProvider.cartData?.cartItems?.where((e) => e.productId == album?.productId).toList();

        final isPaid = albumProvider.albumDetail?.lectures?.where((e) => e.isPaid == true).toList() ?? [];
        return GeneralScaffold(
          appBar: CustomAppBar(
            action: [
              Consumer<CartProvider>(
                builder: (context, cartProvider, _) {
                  return ActionItem(
                    iconPath: "assets/icons/ic_cart.png",
                    count: cartProvider.cartData?.cartItems?.length,
                    onPressed: () {
                      Navigator.pushNamed(context, CartPage.path);
                    },
                  );
                },
              ),
            ],
          ),
          bottomBar: isPaid.isEmpty && album?.isPaid == false
              ? SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: PrimaryButton(
                      isEnable: isCarted?.isEmpty == true,
                      onPressed: () {
                        if (authProvider.user != null) {
                          final cart = context.read<CartProvider>();
                          cart.addCart(album?.productId);
                          Toast.success(context, description: "Сагсанд нэмэгдлээ.");
                        } else {
                          Toast.error(context, description: "Та нэвтрэх хэрэгтэй.");
                        }
                      },
                      title: isCarted?.isEmpty == true ? "Цомог сагслах" : " Цомог сагсалсан",
                    ),
                  ),
                )
              : null,
          child: albumData != null
              ? ListView(
                  children: [
                    Center(
                      child: CachedImage(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.width * 0.5,
                        imageUrl: album?.banner.toUrl() ?? "",
                        borderRadius: 20,
                      ),
                    ),
                    VSpacer(size: 32),
                    Center(
                      child: Text(
                        album?.title ?? "",
                        style: GeneralTextStyle.titleText(fontSize: 20),
                      ),
                    ),
                    VSpacer(),
                    CustomReadMore(
                      text: removeHtmlTags(album?.body ?? ""),
                    ),
                    VSpacer(),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: "Үргэлжлэх хугацаа: "),
                          TextSpan(
                            text: formatDuration(album?.audioDuration ?? 0),
                            style: GeneralTextStyle.titleText(),
                          )
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    VSpacer(),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: "Үнэ: "),
                          TextSpan(
                            text: formatCurrency(album?.price ?? 0),
                            style: GeneralTextStyle.titleText(),
                          )
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Divider(color: GeneralColors.borderColor),
                    ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: albumData.lectures?.length ?? 0,
                      separatorBuilder: (context, index) => Divider(color: GeneralColors.borderColor),
                      itemBuilder: (context, index) {
                        final podcast = albumData.lectures?[index];
                        return PodcastItem(
                          podcast: podcast,
                          onclickAfter: () {
                            if (podcast?.isPaid == true) {
                              albumProvider.getReplies(album?.id, "lecture");
                            }
                          },
                          type: 'lecture',
                        );
                      },
                    ),
                    VSpacer(size: 30),
                    HomeTitle(
                      title: "Сэтгэгдэл",
                      onPressed: albumProvider.replies.length >= 3
                          ? () {
                              Navigator.pushNamed(context, ReplyPage.path, arguments: ReplyArg(id: album?.id, type: "lecture"));
                            }
                          : null,
                    ),
                    VSpacer(size: 24),
                    albumProvider.replies.isNotEmpty == true
                        ? ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: albumProvider.replies.length,
                            separatorBuilder: (context, index) => Divider(color: GeneralColors.borderColor),
                            itemBuilder: (context, index) {
                              final reply = albumProvider.replies[index];
                              return ReplyItem(reply: reply);
                            },
                          )
                        : EmptyState(
                            title: "Одоогоор сэтгэгдэл байхгүй байна",
                          ),
                  ],
                )
              : Center(),
        );
      },
    );
  }
}

class ReplyItem extends StatelessWidget {
  const ReplyItem({
    super.key,
    required this.reply,
  });

  final FeedbackResponseData reply;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedImage(
              imageUrl: reply.avatar.toUrl(),
              height: 40,
              width: 40,
              borderRadius: 100,
              fit: BoxFit.cover,
            ),
            HSpacer(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reply.nickName ?? "",
                    style: GeneralTextStyle.titleText(
                      fontSize: 14,
                    ),
                  ),
                  VSpacer.xs(),
                  Text(
                    reply.lectureName ?? reply.trainingName ?? "",
                    style: GeneralTextStyle.bodyText(
                      textColor: GeneralColors.primaryColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Text(
              formatDate(
                reply.createdAt ?? "",
              ),
              style: GeneralTextStyle.titleText(
                fontSize: 14,
                textColor: GeneralColors.grayColor,
              ),
            )
          ],
        ),
        VSpacer.xs(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(reply.text ?? ""),
        ),
      ],
    );
  }
}
