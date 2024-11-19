import 'package:flutter/material.dart';
import 'package:goodali/connection/model/podcast_response.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/book/provider/book_provider.dart';
import 'package:goodali/pages/cart/provider/cart_provider.dart';
import 'package:goodali/shared/components/cached_image.dart';
import 'package:goodali/shared/components/custom_app_bar.dart';
import 'package:goodali/shared/components/primary_button.dart';
import 'package:goodali/shared/general_scaffold.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/globals.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/toasts.dart';
import 'package:goodali/utils/utils.dart';
import 'package:provider/provider.dart';

class BookPage extends StatefulWidget {
  const BookPage({super.key});
  static const String path = "/book-page";

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  late final BookProvider _provider;
  PodcastResponseData? book;
  @override
  void initState() {
    super.initState();
    _provider = Provider.of(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final id = ModalRoute.of(context)?.settings.arguments as int?;
      final response = await _provider.getBookById(id);
      setState(() {
        book = response;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, _) {
        final isCarted = cartProvider.cartData?.cartItems?.where((e) => book?.productId == e.productId).isNotEmpty ?? false;
        return GeneralScaffold(
          horizontalPadding: 0,
          appBar: CustomAppBar(),
          bottomBar: book?.isPaid == true
              ? null
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: PrimaryButton(
                      backgroundColor: isCarted ? GeneralColors.primaryColor.withOpacity(0.6) : GeneralColors.primaryColor,
                      title: isCarted ? "Ном сагcаас хасах" : "Ном сагcлах",
                      onPressed: () {
                        if (isCarted) {
                          cartProvider.removeCart(book?.productId);
                          Toast.success(context, description: "Амжилтай хасалаа");
                        } else {
                          cartProvider.addCart(book?.productId);
                          Toast.success(context, description: "Амжилтай нэмлээ");
                        }
                      },
                    ),
                  ),
                ),
          child: ListView(
            children: [
              CachedImage(
                imageUrl: book?.banner.toUrl() ?? placeholder,
                height: 280,
                fit: BoxFit.contain,
              ),
              VSpacer(),
              Text(
                book?.title ?? "",
                style: GeneralTextStyle.titleText(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              VSpacer.sm(),
              Text(
                "Онлайн ном",
                style: GeneralTextStyle.bodyText(textColor: GeneralColors.primaryColor),
                textAlign: TextAlign.center,
              ),
              VSpacer.sm(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  removeHtmlTags(book?.body ?? ""),
                  style: GeneralTextStyle.bodyText(fontSize: 14),
                ),
              ),
              VSpacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Хугацаа",
                      style: GeneralTextStyle.bodyText(fontSize: 14),
                    ),
                    VSpacer.sm(),
                    Text(
                      formatDuration(book?.audioDuration ?? 0),
                      style: GeneralTextStyle.titleText(),
                    ),
                    VSpacer.sm(),
                    Divider(),
                  ],
                ),
              ),
              VSpacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Үнэ",
                      style: GeneralTextStyle.bodyText(fontSize: 14),
                    ),
                    VSpacer.sm(),
                    Text(
                      formatCurrency(book?.price ?? 0),
                      style: GeneralTextStyle.titleText(),
                    ),
                    VSpacer.sm(),
                    Divider(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
