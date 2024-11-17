import 'package:flutter/material.dart';
import 'package:goodali/connection/model/album_response.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/album/provider/album_provider.dart';
import 'package:goodali/pages/auth/provider/auth_provider.dart';
import 'package:goodali/pages/cart/cart_page.dart';
import 'package:goodali/pages/cart/provider/cart_provider.dart';
import 'package:goodali/pages/podcast/components/podcast_item.dart';
import 'package:goodali/shared/components/action_item.dart';
import 'package:goodali/shared/components/cached_image.dart';
import 'package:goodali/shared/components/custom_app_bar.dart';
import 'package:goodali/shared/components/custom_read_more.dart';
import 'package:goodali/shared/components/primary_button.dart';
import 'package:goodali/shared/general_scaffold.dart';
import 'package:goodali/utils/colors.dart';
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
      dismissLoader();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Selector<AlbumProvider, AlbumDetailResponseData?>(
      selector: (p0, p1) => p1.albumDetail,
      builder: (context, albumData, child) {
        final album = albumData?.album;
        return Consumer<CartProvider>(builder: (context, cartProvider, _) {
          final isCarted = cartProvider.cartData?.cartItems?.where((e) => e.productId == album?.productId).toList();
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
            bottomBar: album?.isPaid == false
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
                        title: isCarted?.isEmpty == true ? "Цомог саглах" : "Цомог саглалсан",
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
                          );
                        },
                      )
                      // Center(child: ,)
                    ],
                  )
                : Center(),
          );
        });
      },
    );
  }
}
